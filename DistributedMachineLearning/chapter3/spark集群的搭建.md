# Spark集群的搭建

## 一、使用三台电脑来搭建一个小型分布式集群环境安装

参考方法：[Spark 2.0分布式集群环境搭建(Python版)](https://dblab.xmu.edu.cn/blog/1714/#more-1714)

## 二、使用Docker来部署spark集群

参考方法：[使用 Docker 快速部署 Spark + Hadoop 大数据集群](https://zhuanlan.zhihu.com/p/421375012)

### 2.1 Spark Standalone集群

[docker.io/bitnami/spark:3 Dockerfile](https://github.com/bitnami/containers/blob/main/bitnami/spark/3.2/debian-11/Dockerfile)

docker-compose.yml文件

```yaml
 version: '2'

services:
  spark:
    image: docker.io/bitnami/spark:3
    hostname: master
    environment:
      - SPARK_MODE=master
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/docker/spark/share:/opt/share
    ports:
      - '8080:8080'
      - '4040:4040'
  spark-worker-1:
    image: docker.io/bitnami/spark:3
    hostname: worker1
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/docker/spark/share:/opt/share
    ports:
      - '8081:8081'
  spark-worker-2:
    image: docker.io/bitnami/spark:3
    hostname: worker2
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/docker/spark/share:/opt/share
    ports:
      - '8082:8081'
```

### 2.2 S park+Hadoop集群

Hadoop 由分布式文件系统 HDFS、分布式计算框架 MapReduce 和资源管理框架 YARN 组成。MapReduce 是面向磁盘的，运行效率受到磁盘读写性能的约束，Spark 延续了 MapReduce 编程模型的设计思路，提出了面向内存的分布式计算框架，性能较之 MapReduce 有了 10～100 倍的提升。与此同时，Spark 框架还对 HDFS 做了很好的支持，并支持运行在 YARN 集群上。

由于 Spark 使用了 Hadoop 的客户端依赖库，所以 Spark 安装包会指定依赖的 Hadoop 特定版本，如 spark-3.1.2-bin-hadoop3.2.tgz。而 bitnami/spark 镜像中只包含 Hadoop 客户端，并不包含服务器端。因此，如果需要使用 HDFS 和 YARN 功能，还需要部署 Hadoop 集群。

将 Hadoop 部署在 Spark 集群上，可以避免不必要的网络通信，并且面向磁盘的 HDFS 与面向内存的 Spark 天生互补。因此，考虑在 bitnami/spark 镜像基础上构建安装有 Hadoop 的新镜像。

docker-compose.yaml

```yaml
version: '2'

services:
  spark:
    image: s1mplecc/spark-hadoop:3
    hostname: master
    environment:
      - SPARK_MODE=master
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/docker/spark/share:/opt/share
    ports:
      - '8080:8080'
      - '4040:4040'
      - '8088:8088'
      - '8042:8042'
      - '9870:9870'
      - '19888:19888'
  spark-worker-1:
    image: s1mplecc/spark-hadoop:3
    hostname: worker1
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/docker/spark/share:/opt/share
    ports:
      - '8081:8081'
  spark-worker-2:
    image: s1mplecc/spark-hadoop:3
    hostname: worker2
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://master:7077
      - SPARK_WORKER_MEMORY=1G
      - SPARK_WORKER_CORES=1
      - SPARK_RPC_AUTHENTICATION_ENABLED=no
      - SPARK_RPC_ENCRYPTION_ENABLED=no
      - SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
      - SPARK_SSL_ENABLED=no
    volumes:
      - ~/docker/spark/share:/opt/share
    ports:
      - '8082:8081'
```



## 三、问题：

spark能否结合PyTorch进行分布式学习
