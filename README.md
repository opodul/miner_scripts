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
sudo apt-get install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev make g++
no longer a public repo  : git clone https://github.com/OhGodAPet/cpuminer-multi
Alternative (not tested) : git clone https://github.com/tpruvot/cpuminer-multi
cd cpuminer-multi/
./autogen.sh 
CFLAGS="-march=native" ./configure
