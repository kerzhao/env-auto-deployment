#!/bin/bash
current_dir=$(pwd)
echo "Current directory is $current_dir"

echo "update"
update()
{
	sudo apt-get update
	sudo apt-get upgrade
}
update

echo "Install Anaconda"
mkdir Download
cd Download
_install_anaconda() {
	wget https://repo.continuum.io/archive/Anaconda2-4.3.1-Linux-x86_64.sh
	bash Anaconda2-4.3.1-Linux-x86_64.sh
}

while [[ true ]]; do
	#statements
	read -p "安装Anaconda?(y/n):" install_a
	if ($install_a == "y"); then
		_install_anaconda()
		break
	else
		break
	fi
done

cd ..
echo $(pwd)
echo "Install git"
sudo apt-get install git

read -p "github用户名:": name
read -p "github邮箱:": email

git config --global user.name $name
git config --global user.email $email

echo "设置公钥"
ssh-keygen -C "$email" -t rsa
ssh -v git@github.com

while true
do
	cat ~/.ssh/id_rsa.pub
	echo "公钥路径:$HOME/.ssh/id_rsa.pub"
 	echo "复制公钥内容, 在github新建SSH-Key并粘贴. 完成这一步后输入y"
 	read ok
 	if [[ $ok == "y" ]]; then
 		break
 	fi
done

ssh -v git@github.com

echo "安装 CUDA Toolkit 8.0"
cd ~/Download

_install_cuda() {
	wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
	sudo apt-get update
	sudo apt-get install cuda
}

_install_cuda

echo "安装 cuDNN"
cd ~/Download
git clone git@github.com:justttry/gittest.git
mv gittest/cudnn-8.0-linux-x64-v5.1.tgz .
rm -rf gittest
tar zxvf cudnn-8.0-linux-x64-v5.1.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
echo "复制完成"

while [[ true ]]; do
	#statements
	read -p "检查是否复制成功？(y/n)" ok
	if ($ok=="y"); then
		read commond
		$commond
	else
		break
done

sudo apt-get install libcupti-dev
echo "安装libcupti-dev"

echo "安装tensorflow"

conda create -n tensorflow
source activate tensorflow
pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.0.1-cp27-none-linux_x86_64.whl


echo "安装cv2"
read -p "继续？" ok
pip install opencv-python

echo "安装keras"
read -p "继续？" ok
pip install graphviz
sudo apt-get install graphviz
pip install pydot==1.1.0
pip install keras