# miner_scripts
helper scripts to run miners

### How to install nvidia driver

	sudo apt-get purge nvidia*
	sudo apt-get autoremove
	sudo apt-get install build-essential gcc-multilib dkms
	echo 'blacklist nouveau' | sudo tee --append /etc/modprobe.d/blacklist-nouveau.conf
	echo 'options nouveau modeset=0' | sudo tee --append /etc/modprobe.d/blacklist-nouveau.conf
	sudo update-initramfs -u
	reboot

--> then log in in console mode (type Ctrl+Alt+F1)

	sudo systemctl stop lightdm
	sudo add-apt-repository ppa:graphics-drivers/ppa 
	sudo apt-get update 
	ubuntu-drivers devices
	sudo apt-get install nvidia-387 nvidia-387-dev
	reboot

Notice: 
- I do not know what "ubuntu-drivers devices" is doing but this is a command to type ! (is at least showing the driver version available)
- I pick up version 387 for ubuntu16.04 , version 390 did not work for me.

### How to install nvidia cuda lib
Go to their website choose the deb local version, and do what they say ! 
https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=deblocal

--> Log in in console mode (type Ctrl+Alt+F1) might be useless, but i do so.

	sudo systemctl stop lightdm
	sudo dpkg -i cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64.deb
	sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub
	sudo apt-get update
	sudo apt-get install cuda

There is somes patchs which could be installed: i did not risk it.

### How to get ethminer (GPU Miner for Ethereum / ubiq)

	git clone https://github.com/ethereum-mining/ethminer
	cd ethminer
	git submodule update --init --recursive
	mkdir build; cd build
	cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF
	make

### How to get minerd (CPU Miner for Monero)
no longer a public repo  : git clone https://github.com/OhGodAPet/cpuminer-multi
Alternative (not tested) : git clone https://github.com/tpruvot/cpuminer-multi

	sudo apt-get install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++
	cd cpuminer-multi/
	./autogen.sh 
	CFLAGS="-march=native" ./configure

be aware: Monero changed for CryptoNightV7 (fork for asic resistance)
as many people, I have huge doubt on minig monero on Minergate 
--> low efficiency and I have a 4€ balance that I cannot withdraw from the site (minimum is 0.1 XMR)


### How to get ccminer
Warning: has to be compile with gcc5 (is the default-one for ubuntu 16.04)

	sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential
	git clone -b linux https://github.com/tpruvot/ccminer.git
	cd ccminer
	./autogen.sh
	./configure | tee configure.log
	./build.sh | tee build.log


### How to get suprminer
same as ccminer:

	sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential
	git clone https://github.com/ocminer/suprminer.git
	cd suprminer
	./autogen.sh
	./configure | tee configure.log
	./build.sh | tee build.log


---------------- Not fully tested below this line draft -----------------
How to get nhminer

Linux (Ubuntu 14.04 / 16.04) Build CUDA_TROMP:
Open terminal and run the following commands:

Ubuntu 14.04:

	wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_8.0.44-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1404_8.0.44-1_amd64.deb

Ubuntu 16.04:

	wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
	sudo apt-get update
	sudo apt-get install cuda
	sudo apt-get install cuda-toolkit-8-0

	sudo apt-get install cmake build-essential libboost-all-dev
	git clone -b Linux https://github.com/nicehash/nheqminer.git
	git clone -b Linux https://github.com/ocminer/nheqminer.git
	cd nheqminer/Linux_cmake/nheqminer_cuda_tromp && cmake . && make -j $(nproc)

or specify your compute version for example 50 like so cd nheqminer/Linux_cmake/nheqminer_cuda_tromp && cmake COMPUTE=50 . && make


