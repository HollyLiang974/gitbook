# Spark中ml和mllib的区别

https://www.bbsmax.com/A/QW5YqWPY5m/

- ml和mllib都是Spark中的机器学习库，目前常用的机器学习功能2个库都能满足需求。
- spark官方推荐使用ml, 因为ml功能更全面更灵活，未来会主要支持ml，mllib很有可能会被废弃(据说可能是在spark3.0中deprecated）。
- ml主要操作的是DataFrame, 而mllib操作的是RDD，也就是说二者面向的数据集不一样。相比于mllib在RDD提供的基础操作，ml在DataFrame上的抽象级别更高，数据和操作耦合度更低。
  - DataFrame和RDD什么关系？DataFrame是Dataset的子集，也就是Dataset[Row], 而DataSet是对RDD的封装，对SQL之类的操作做了很多优化。
- 相比于mllib在RDD提供的基础操作，ml在DataFrame上的抽象级别更高，数据和操作耦合度更低。
- ml中的操作可以使用pipeline, 跟sklearn一样，可以把很多操作(算法/特征提取/特征转换)以管道的形式串起来，然后让数据在这个管道中流动。大家可以脑补一下Linux管道在做任务组合时有多么方便。
- ml中无论是什么模型，都提供了统一的算法操作接口，比如模型训练都是`fit`；不像mllib中不同模型会有各种各样的`trainXXX`。
- mllib在spark2.0之后进入`维护状态`, 这个状态通常只修复BUG不增加新功能。

## 为什么我们还需要Data Frame

在Spark中，DataFrame是一种以RDD为基础的分布式数据集，类似于传统数据库中的二维表格。DataFrame与RDD的主要区别在于，前者带有schema元信息，即DataFrame所表示的二维表数据集的每一列都带有名称和类型。这使得Spark SQL得以洞察更多的结构信息，从而对藏于DataFrame背后的数据源以及作用于DataFrame之上的变换进行了针对性的优化，最终达到大幅提升运行时效率的目标。反观RDD，由于无从得知所存数据元素的具体内部结构，Spark Core只能在stage层面进行简单、通用的流水线优化。
