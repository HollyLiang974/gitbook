# Analytics-Zoo

## 一、介绍

Analytics Zoo是统一的数据分析AI平台，支持笔记本、云、Hadoop Cluster、K8s Cluster等平台、此外，Analytics Zoo提供了端到端的pipeline，大家可以将AI模型应用到分布式大数据场景中。Analytics Zoo还提供了端到端的ML workflow和内置的模型和算法。具体而言，在底层的使用环境中，支持深度学习框架，如TensorFlow、PyTorch、OpenVINO等，还支持分布式框架，如Spark、Flink、Ray等，还可以使用Python库，如Numpy、Pandas、sklearn等。在端到端的pipeline中用户可以使用原生的TensorFlow和PyTorch，用户只需要很简单的修改就可以将原有的TensorFlow和PyTorch代码移植到Spark上来做分布式训练。Analytics Zoo还提供了RayOnSpark，ML Pipeplines，Automatic Cluster Serving，支持流式Serving。在内置算法中，提供了推荐算法，时序算法，视觉以及自然语言处理等

## 二、安装

```bash
conda create -n zoo python=3.7 # zoo is conda environment name, you can use any name you like.
conda activate zoo
pip install analytics-zoo # install either version 0.9 or latest nightly build
pip install torch==1.7.1 torchvision==0.8.2
pip install six cloudpickle
pip install jep==3.9.0
```

## 参考链接

[Analytics Zoo 入门](http://www.taodudu.cc/news/show-4512503.html)

[](https://bigdl.readthedocs.io/en/latest/doc/Orca/Howto/pytorch-quickstart.html)

