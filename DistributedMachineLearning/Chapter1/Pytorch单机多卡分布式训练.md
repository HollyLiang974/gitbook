# PyTorch分布式训练

## 预备知识

[参考链接](https://blog.csdn.net/zzxxxaa1/article/details/121421075)

## 1. 进程通信概念  

### 1.1 主机，进程  

每个主机可以运行多个进程，通常各个进程都是在做各自的事情，进程之间互不相干。

在**MPI**（MPI是一个跨语言的通讯协议，用于编写并行计算机。支持点对点和广播）中，我们可以拥有一组可以互发消息的进程，这些进程甚至可以跨主机进行通信，这是我们称主机为节点，进程为工作节点，但在PyTorch中，还是采用主机和进程的说法。

### 1.2 World，Rank

**world**可以认为是所有进程的集合。如下图中Host1中Host2中所有的进程集合被称为一个world，world size代表的就是这组能够通信的进程总数，图中world size=6。

![world](D:\研究生\gitbook\DistributedMachineLearning\img\World.png)



**rank** 可以认为是这组能够通信的进程在world中的序号

![rank](D:\研究生\gitbook\DistributedMachineLearning\img\rank.png)

**Local Rank** 可以认为是可以互相通信的进程在自己主机上的序号，注意每个主机中local rank的编号都是从零开始的

![local Rank](D:\研究生\gitbook\DistributedMachineLearning\img\local rank.png)

## 2. PyTorch单机多卡数据并行

### 2.1 启动多进程

```python
#run_multiprocess.py
#运行命令：python run_multiprocess.py
import torch.multiprocessing as mp #这是一个多进程的包
 
def run(rank, size):
    print("world size:{}. I'm rank {}.".format(size,rank))
 
 
if __name__ == "__main__":
    world_size = 4
    #设置多进程的启动方式为spawn，使用此方式启动的进程,只会执行和 target 参数或者 run() 方法相关的代码。
    mp.set_start_method("spawn") 
    #创建进程对象
    #target为该进程要运行的函数，args为target函数的输入参数
    p0 = mp.Process(target=run, args=(0, world_size))
    p1 = mp.Process(target=run, args=(1, world_size))
    p2 = mp.Process(target=run, args=(2, world_size))
    p3 = mp.Process(target=run, args=(3, world_size))
 
    #启动进程
    p0.start()
    p1.start()
    p2.start()
    p3.start()
 
    #当前进程会阻塞在join函数，直到相应进程结束。
    p0.join() #主线程等待p终止，p.join只能join住start开启的进程,而不能join住run开启的进程
    p1.join()
    p2.join()
    p3.join()
```



### 2.2 多进程间通信

```python
#multiprocess_comm.py
#运行命令：python multiprocess_comm.py
 
import os
import torch.distributed as dist #PyTorch 分布式训练包
import torch.multiprocessing as mp
 
def run(rank, size):
    #MASTER_ADDR和MASTER_PORT是通信模块初始化需要的两个环境变量。
    #由于是在单机上，所以用localhost的ip就可以了。
    os.environ['MASTER_ADDR'] = '127.0.0.1'
    #端口可以是任意空闲端口
    os.environ['MASTER_PORT'] = '29500'
    #通信模块初始化
    #进程会阻塞在该函数，直到确定所有进程都可以通信。
    dist.init_process_group('gloo', rank=rank, world_size=size)#初始化分布式环境，第一个参数指定的是通信后端
    print("world size:{}. I'm rank {}.".format(size,rank))
 
 
if __name__ == "__main__":
    #world size的数量要与开启的进程数量相等，否则会出错
    world_size = 4
    mp.set_start_method("spawn")
    #创建进程对象
    #target为该进程要运行的函数，args为函数的输入参数
    p0 = mp.Process(target=run, args=(0, world_size))
    p1 = mp.Process(target=run, args=(1, world_size))
    p2 = mp.Process(target=run, args=(2, world_size))
    p3 = mp.Process(target=run, args=(3, world_size))
 
    #启动进程
    p0.start()
    p1.start()
    p2.start()
    p3.start()
 
    #等待进程结束
    p0.join()
    p1.join()
    p2.join()
    p3.join()
```



### 2.3 单机多卡数据并行训练（使用CPU）

PyTorch关于分布式训练，增加了很多更加高层的封装，例如DistributedDataParallel,DistributedSampler，为了便于理解，本示例没有使用这些封装

#### 代码示例

```python
# multiprocess_training.py
# 运行命令：python multiprocess_training.py
import os
import torch
import torch.distributed as dist
import torch.multiprocessing as mp
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms


# 用于平均梯度的函数
def average_gradients(model):
    size = float(dist.get_world_size())
    for param in model.parameters():
        dist.all_reduce(param.grad.data, op=dist.ReduceOp.SUM)
        param.grad.data /= size


# 模型
class ConvNet(nn.Module):
    def __init__(self, num_classes=10):
        super(ConvNet, self).__init__()
        self.layer1 = nn.Sequential(
            nn.Conv2d(1, 16, kernel_size=5, stride=1, padding=2),
            nn.BatchNorm2d(16),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        self.layer2 = nn.Sequential(
            nn.Conv2d(16, 32, kernel_size=5, stride=1, padding=2),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2))
        self.fc = nn.Linear(7 * 7 * 32, num_classes)

    def forward(self, x):
        out = self.layer1(x)
        out = self.layer2(out)
        out = out.reshape(out.size(0), -1)
        out = self.fc(out)
        return out


def accuracy(outputs, labels):
    _, preds = torch.max(outputs, 1)  # taking the highest value of prediction.
    correct_number = torch.sum(preds == labels.data)
    return (correct_number / len(preds)).item()


def run(rank, size):
    # MASTER_ADDR和MASTER_PORT是通信模块初始化需要的两个环境变量。
    # 由于是在单机上，所以用localhost的ip就可以了。
    os.environ['MASTER_ADDR'] = '127.0.0.1'
    # 端口可以是任意空闲端口
    os.environ['MASTER_PORT'] = '29500'
    dist.init_process_group('gloo', rank=rank, world_size=size)

    # 1.数据集预处理
    train_dataset = torchvision.datasets.MNIST(root='../data',
                                               train=True,
                                               transform=transforms.ToTensor(),
                                               download=True)
    training_loader = torch.utils.data.DataLoader(train_dataset, batch_size=100, shuffle=True)

    # 2.搭建模型
    # device = torch.device("cuda:{}".format(rank))
    device = torch.device("cpu")
    print(device)
    torch.manual_seed(0)
    model = ConvNet().to(device)
    torch.manual_seed(rank)
    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=0.001, momentum=0.9)  # fine tuned the lr
    # 3.开始训练
    epochs = 15
    batch_num = len(training_loader)
    running_loss_history = []
    for e in range(epochs):
        for i, (inputs, labels) in enumerate(training_loader):
            inputs = inputs.to(device)
            labels = labels.to(device)
            # 前向传播
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            optimizer.zero_grad()
            # 反传
            loss.backward()
            # 记录loss
            running_loss_history.append(loss.item())
            # 参数更新前需要Allreduce梯度。
            average_gradients(model)
            # 参数更新
            optimizer.step()
            if (i + 1) % 50 == 0 and rank == 0:
                print('Epoch [{}/{}], Step [{}/{}], Loss: {:.4f},acc:{:.2f}'.format(e + 1, epochs, i + 1, batch_num,
                                                                                    loss.item(),
                                                                                    accuracy(outputs, labels)))


if __name__ == "__main__":
    world_size = 4
    mp.set_start_method("spawn")
    # 创建进程对象
    # target为该进程要运行的函数，args为target函数的输入参数
    p0 = mp.Process(target=run, args=(0, world_size))
    p1 = mp.Process(target=run, args=(1, world_size))
    p2 = mp.Process(target=run, args=(2, world_size))
    p3 = mp.Process(target=run, args=(3, world_size))

    # 启动进程
    p0.start()
    p1.start()
    p2.start()
    p3.start()

    # 当前进程会阻塞在join函数，直到相应进程结束。
    p0.join()
    p1.join()
    p2.join()
    p3.join()
```

#### 训练效果

![](D:\研究生\gitbook\DistributedMachineLearning\img\train.png)
