# pip修改镜像源

## 一、国内常用镜像源汇总

**1 清华镜像**

```text
https://pypi.tuna.tsinghua.edu.cn/simple
```

**2 中科大镜像**

```text
https://pypi.mirrors.ustc.edu.cn/simple
```

**3 豆瓣镜像**

```text
http://pypi.douban.com/simple/
```

**3 阿里镜像**

```python3
https://mirrors.aliyun.com/pypi/simple/
```



**4 华中科大镜像**

```text
http://pypi.hustunique.com/
```



**5 山东理工大学镜像**

```text
http://pypi.hustunique.com/
```



**6 搜狐镜像**

```text
http://mirrors.sohu.com/Python/
```

**7 百度镜像**

```text
https://mirror.baidu.com/pypi/simple
```

## 二、手动切换镜像源

```bash
#全局设置镜像源地址
pip config set global.index-url https://pypi.mirrors.ustc.edu.cn/simple
```



## 三、查看更改后的镜像源

```lua
pip config list
```