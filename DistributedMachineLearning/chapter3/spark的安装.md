# Spark的安装

## 一、本地安装

### 1. 安装Hadoop 

[Hadoop安装教程_单机/伪分布式配置_Hadoop2.6.0(2.7.1)/Ubuntu14.04(16.04)](https://dblab.xmu.edu.cn/blog/7/)

### 2. 安装Spark 

[Spark2.1.0+入门：Spark的安装和使用(Python版)](https://dblab.xmu.edu.cn/blog/1689/)

## 二、Anaconda安装

### 1. 安装Java环境

在Linux命令行界面中，执行如下Shell命令（注意：当前登录用户名是hadoop）：

```bash
cd /usr/lib
sudo mkdir jvm #创建/usr/lib/jvm目录用来存放JDK文件
cd ~ #进入hadoop用户的主目录cd Downloads  #注意区分大小写字母，刚才已经通过FTP软件把JDK安装包jdk-8u162-linux-x64.tar.gz上传到该目录下
sudo tar -zxvf ./jdk-8u162-linux-x64.tar.gz -C /usr/lib/jvm  #把JDK文件解压到/usr/lib/jvm目录下
```

上面使用了解压缩命令tar，如果对Linux命令不熟悉，可以参考[常用的Linux命令用法](https://dblab.xmu.edu.cn/blog/1624-2/)。

JDK文件解压缩以后，可以执行如下命令到/usr/lib/jvm目录查看一下：

```bash
cd /usr/lib/jvmls
```

可以看到，在/usr/lib/jvm目录下有个jdk1.8.0_162目录。
下面继续执行如下命令，设置环境变量：

```bash
cd ~vim ~/.bashrc
```

上面命令使用vim编辑器（[查看vim编辑器使用方法](https://dblab.xmu.edu.cn/blog/1607-2/)）打开了hadoop这个用户的环境变量配置文件，请在这个文件的开头位置，添加如下几行内容：

```
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_162
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
```

保存.bashrc文件并退出vim编辑器。然后，继续执行如下命令让.bashrc文件的配置立即生效：

```bash
source ~/.bashrc
```

这时，可以使用如下命令查看是否安装成功：

```bash
java -version
```

如果能够在屏幕上返回如下信息，则说明安装成功：

```
hadoop@ubuntu:~$ java -version
java version "1.8.0_162"
Java(TM) SE Runtime Environment (build 1.8.0_162-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.162-b12, mixed mode)
```

### 2. 安装anaconda

Anaconda清华大学镜像下载：https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/

### 3. 安装spark使用conda

```
conda create -n pyspark_env
conda activate pyspark_env
```

激活环境后，使用以下命令安装 pypark、您选择的 python 版本，以及您希望在与 pypark 相同的会话中使用的其他包(也可以分几个步骤进行安装)。

```
conda install -c conda-forge pyspark  # can also add "python=3.8 some_package [etc.]" here
```

## 三、Docker容器

```shell
docker pull bitnami/spark:3
```

