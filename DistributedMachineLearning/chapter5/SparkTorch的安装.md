# SparkTorch的安装

[GitHub仓库地址](https://github.com/dmmiller612/sparktorch)

## 一、介绍

This is an implementation of Pytorch on Apache Spark. The goal of this library is to provide a simple, understandable interface in distributing the training of your Pytorch model on Spark. With SparkTorch, you can easily integrate your deep learning model with a ML Spark Pipeline. Underneath the hood, SparkTorch offers two distributed training approaches through tree reductions and a parameter server. Through the api, the user can specify the style of training, whether that is distributed synchronous or hogwild.

### Why should I use this?

Like SparkFlow, SparkTorch's main objective is to seamlessly work with Spark's ML Pipelines. This library provides three core components:

- Data parallel distributed training for large datasets. SparkTorch offers distributed synchronous and asynchronous training methodologies. This is useful for training very large datasets that do not fit into a single machine.
- Full integration with Spark's ML library. This ensures that you can save and load pipelines with your trained model.
- Inference. With SparkTorch, you can load your existing trained model and run inference on billions of records in parallel.

On top of these features, SparkTorch can utilize barrier execution, ensuring that all executors run concurrently during training (This is required for synchronous training approaches).

## 二、安装

Install SparkTorch via pip: `pip install sparktorch`

SparkTorch requires Apache Spark >= 2.4.4, and has only been tested on PyTorch versions >= 1.3.0.