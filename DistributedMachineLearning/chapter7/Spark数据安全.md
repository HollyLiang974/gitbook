# Spark数据安全

[Data-at-rest security for spark](https://ieeexplore.ieee.org/abstract/document/7840754/)

ApacheSpark 通过有效利用主内存和缓存数据来实现快速计算并极大地加速分析应用程序以供以后使用。ApacheSpark 的核心使用称为 RDD (Resilient 分布式数据集)的数据结构为分布式数据提供统一的视图。然而，RDD 中的数据仍然没有加密，这可能导致应用程序生成或处理的机密数据泄露。Apache Spark 在各种情况下将(未加密的) RDD 持久化到磁盘存储，包括但不限于缓存、 RDD 检查点和数据洗牌操作期间的数据溢出等。这种安全性的缺乏使得 ApacheSpark 不适合处理任何时候都应该保护的敏感信息。此外，存储在主存中的 RDD 容易受到主存攻击，比如 RAM 抢占。在本文中，我们提出并开发了一些解决方案来弥补当前 ApacheSpark 框架中的这些安全缺陷。我们提出了三种不同的方法来将安全性合并到 ApacheSpark 框架中。这些方法旨在限制在数据处理、缓存和数据溢出到磁盘期间暴露未加密数据。我们结合使用加密分解和加密来保护 Apache Spark 存储和溢出的数据，这些数据既存储在磁盘上，也存储在主存中。我们的方法结合了信息传播算法(IDA)和沙米尔完美秘密共享(PSS) ，提供了强大的安全性。大量的实验表明，通过适当选择参数，我们的安全方法提供了高度的安全性，性能损失在10% -25% 之间。

[Designing a cryptosystem for data at rest encryption in mobile payments](https://gigvvy.com/journals/ijase/articles/ijase-202012-17-4-373)







[GuardSpark++: Fine-grained purpose-aware access control for secure data sharing and analysis in Spark](https://dl.acm.org/doi/abs/10.1145/3427228.3427640)

随着计算和通信技术的发展，大量的数据被收集、存储、利用和共享，同时也带来了新的安全和隐私挑战。现有平台没有为大数据分析应用提供灵活实用的访问控制机制。在本文中，我们提出了一种在Spark中用于安全数据共享和分析的细粒度访问控制机制GuardSpark++。特别地，我们首先提出了一个基于目的的访问控制(PAAC)模型，它在传统的基于目的的访问控制中引入了数据处理/操作目的的新概念。开发了一种自动目的分析算法，用于从数据分析操作和查询中识别目的，因此可以相应地实施访问控制。此外，我们在Spark Catalyst中开发了一种访问控制机制，为异构数据源和上层应用提供统一的PAAC实施。我们使用Spark中的五个数据源和四个结构化数据分析引擎来评估GuardSpark++。实验结果表明，GuardSpark++以非常小的性能开销(平均3.97%)提供了有效的访问控制功能。 

[SparkAC: Fine-Grained Access Control in Spark for Secure Data Sharing and Analytics](https://ieeexplore.ieee.org/abstract/document/9707647/)



[ENCRYPTION OF SATELLITE IMAGES WITH AES ALGORITHM ON APACHE SPARK](http://acikerisim.karabuk.edu.tr:8080/xmlui/handle/123456789/1047)



[Using trusted execution environments for secure stream processing of medical data](https://arxiv.org/abs/1906.07072)

在第三方不可信云上处理敏感数据(如身体传感器产生的数据)尤其具有挑战性，同时又不损害生成这些数据的用户的隐私。通常，这些传感器以流方式生成大量连续数据。即使在强大的对抗性模型下，也必须有效和安全地处理如此大量的数据。最近在大众市场上推出的带有可信执行环境的消费级处理器(例如英特尔 SGX) ，为克服不太灵活的方法(例如顶部同态加密)的解决方案铺平了道路。我们提出了一个安全的流处理系统建立在英特尔新交所的顶部，以展示这种方法的可行性与系统专门适合医疗数据。我们设计并充分实现了一个原型系统，我们评估了几个现实的数据集。我们的实验结果表明，与普通的 Spark 系统相比，该系统实现了适度的开销，同时在强大的攻击者和威胁模型下提供了额外的保护保证。

