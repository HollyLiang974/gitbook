#!/usr/bin/env sh
## 将 _book目录推送到git仓库中的 master分支

# 定义仓库地址
Git_Url='git@github.com:HollyLiang974/Cryptography.git'
# 源代码仓库地址
Git_Origin_url = 'git@github.com:HollyLiang974/gitbook.git'

echo '开始执行命令'
# 生成静态文件
echo '执行命令：gitbook build .'
npm run build

# 进入生成的文件夹
echo "执行命令：cd ./_book\n"
cd ./_book

# 初始化一个仓库，仅仅是做了一个初始化的操作，项目里的文件还没有被跟踪
echo "执行命令：git init\n"
git init


# 保存所有的修改
echo "执行命令：git add -A"
git add -A

echo "Enter the your commit message: "  
read message 

# 把修改的文件提交
echo "执行命令：commit -m $message"
git commit -m "$message"

# 如果发布到 https://<USERNAME>.github.io/<REPO>
git remote rm origin 
git remote add origin $Git_Url
echo "执行命令：git push "
# git pull origin master
git push --force origin master

# 返回到上一次的工作目录
echo "回到刚才工作目录"
cd -

# 回到gitbook
cd ../

#当前路径

echo "当前路径是$pwd"

# 拉取gitbook 代码
echo "拉取gitbook代码"

echo "git remote -v"
git remote -v

echo "git pull origin master"
git pull origin master

git add -A

echo "git commit -m $message"
git commit -m "$message"

echo "git push origin master"
git push origin master
