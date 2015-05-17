#!/bin/bash

# auto-configure

update() {
  sudo apt-get update
  sudo apt-get upgrade
}

update
# dependency
#
sudo apt-get install git git-core gcc g++ libssl-dev make

# ssh-keygen
read -p 'github用户名': name
read -p 'github邮箱:' email
echo "保持默认值"
ssh-keygen -t rsa -C $email

while true
do
  echo "公钥路径:$HOME/.ssh/id_rsa.pub"
  echo "复制公钥内容, 在github新建SSH-Key并粘贴. 完成这一步后输入y"
  read ok
  if [[ $ok == "y" ]]; then
    break
  fi
done

# test connection
ssh -T git@github.com

# git
git config --global user.name $name
git config --global user.email $email

# iojs
iojs="iojs-v2.0.2"
wget "https://iojs.org/dist/v2.0.2/${iojs}.tar.gz"
tar zxvf "${iojs}.tar.gz"
cd $iojs && ./configure && sudo make && sudo make install && cd - && rm "${iojs}.tar.gz"

# acl
sudo chown -R $USER /usr/local/bin /usr/local/lib /usr/local/include

# CoffeeScript
npm install -g coffee-script
npm install -g js2coffee
npm install -g cson

# node-gyp
npm install -g node-gyp

# loopback & strongloop
npm install -g strongloop

# mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# update all
update

# run mongodb
mongod -f /etc/mongod.conf

# create dir
[[ -e github/ ]] || mkdir github

# install Yinle.me dependency
cd github && git clone git@github.com:Init-6-intel/Yinle.me-architecture.git
cd Yinle.me-architecture && npm install

# compile CoffeeScript
cake compile

echo "稍后手动修改server/datasources.json"
