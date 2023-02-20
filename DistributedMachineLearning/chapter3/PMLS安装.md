# PMLS安装

## 1. 系统环境

[官方文档](https://pmls.readthedocs.io/en/latest/installation.html)

### 1.1 系统版本

文档使用的是 **64-bit Ubuntu Desktop 14.04**

本次安装使用的是 **64-bit Ubuntu Desktop 16.04，18.04和20.04**在安装过程会出现Python版本和编译错误

### 1.2 Python版本

Python 2.7.12

### 1.3 GCC版本

gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.12) 

## 2. Obtaining PMLS

The best way to download PMLS is via the `git` command. Install `git` by running

```
sudo apt-get -y update
sudo apt-get -y install git
```

Then, run the following commands to download PMLS Bösen and Strads:

```
git clone -b stable https://github.com/sailing-pmls/bosen.git
git clone https://github.com/sailing-pmls/strads.git
cd bosen
git clone https://github.com/sailing-pmls/third_party.git third_party
cd ..
```

Next, **for each machine that PMLS will be running on**, execute the following commands to install dependencies:

```
sudo apt-get -y update
sudo apt-get -y install g++ make autoconf git libtool uuid-dev openssh-server cmake libopenmpi-dev openmpi-bin libssl-dev libnuma-dev python-dev python-numpy python-scipy python-yaml protobuf-compiler subversion libxml2-dev libxslt-dev zlibc zlib1g zlib1g-dev libbz2-1.0 libbz2-dev
```

**Warning:** Some parts of PMLS require openmpi, but are incompatible with mpich2 (e.g. in the Anaconda scientific toolkit for Python). If you have both openmpi and mpich2 installed, make sure `mpirun` points to openmpi’s executable.



## 3. Compiling PMLS

You’re now ready to compile PMLS. From the directory in which you started, run

```
cd strads
make
cd ../bosen/third_party
make
cd ../../bosen
cp defns.mk.template defns.mk
make
cd ..
```

If you are installing PMLS to a shared filesystem, **the above steps only need to be done from one machine**.

The first make builds Strads, and the second and third makes build Bösen and its dependencies. All commands will take between 5-30 minutes each, depending on your machine. We’ll explain how to compile and run PMLS’s built-in apps later in this manual.

## 4. Very important: Setting up password-less SSH authentication

PMLS uses `ssh` (and `mpirun`, which invokes `ssh`) to coordinate tasks on different machines, **even if you are only using a single machine**. This requires password-less key-based authentication on all machines you are going to use (PMLS will fail if a password prompt appears).

If you don’t already have an SSH key, generate one via

```
ssh-keygen
```

You’ll then need to add your public key to each machine, by appending your public key file `~/.ssh/id_rsa.pub` to `~/.ssh/authorized_keys` on each machine. If your home directory is on a shared filesystem visible to all machines, then simply run

```
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

If the machines do not have a shared filesystem, you need to upload your public key to each machine, and the append it as described above.

**Note:** Password-less authentication can fail if `~/.ssh/authorized_keys` does not have the correct permissions. To fix this, run `chmod 600 ~/.ssh/authorized_keys`.