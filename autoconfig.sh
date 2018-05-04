#!/bin/bash

if [ `id -u` -ne 0 ]; then
    echo "only root can run this script..."
    exit
fi

RELCFG="/etc/redhat-release"

if [ ! -f $RELCFG ]; then
    echo -e "this config script is only for Fedora...\nexit..."
    exit
fi

if ! grep -E "Fedora release 2[0-9]" $RELCFG > /dev/null; then
    echo -e "this config script is only for Fedora and CentOS...\nexit..."
    exit
fi

if ! vim --version 2>/dev/null | grep -q +python3; then
    echo run this script, then install vim by https://github.com/shuhm-gh/oh-my-vim.git, gnome of fedora will not work
    echo so, install vim first
    echo exit
    exit
fi

LOG=`date "+%Y-%m-%d_%H:%M:%S"`.log
function dnf_install {
    echo `date "+%Y-%m-%d %H:%M:%S"` dnf install -y $*
    sudo dnf install -y $* > /dev/null 2>>$LOG
}


#if ! rpm -qa | grep -i "virtualbox" > /dev/null; then # for analysing gnome not work
sudo timedatectl set-timezone Asia/Shanghai

# repo
sudo mv /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora.repo.backup
sudo mv /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-updates.repo.backup
sudo curl -o /etc/yum.repos.d/fedora.repo http://mirrors.aliyun.com/repo/fedora.repo
sudo curl -o /etc/yum.repos.d/fedora-updates.repo http://mirrors.aliyun.com/repo/fedora-updates.repo
# sudo yum makecache

#curl -O https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
#curl -O https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf_install ./rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf_install ./rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# === wubi
dnf_install ibus-table-chinese-wubi-jidian

# === dependency
dnf_install gcc gcc-c++ kernel-{headers,devel}-`uname -r`

# === virtualbox
# aria2c https://download.virtualbox.org/virtualbox/5.2.8/VirtualBox-5.2-5.2.8_121009_fedora26-1.x86_64.rpm
# /sbin/vboxconfig  # fedora 28, "Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel".  Stop.
dnf_install elfutils-libelf-devel
dnf_install ./VirtualBox-5.*.x86_64.rpm
#put installation of VirtualBox_Extension_Pack at the end because interactive
sudo usermod -a -G vboxusers kylin

#echo "reboot and rerun this script" # for analysing gnome not work
#exit

dnf_install docker

dnf_install npm

# = vim
# sudo oh-my-vim/install # vim

# = pomodoro
dnf_install gnome-shell-extension-pomodoro

dnf_install aria2
dnf_install axel
dnf_install tmux
dnf_install unrar

dnf_install python3-shadowsocks
# sudo sslocal -c /etc/shadowsocks-jdb.json -d start
# google-chrome --proxy-server="socks://localhost:1080"

dnf_install ack

# = chrome
#curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
dnf_install ./google-chrome-stable_current_x86_64.rpm
dnf_install chromium

# = teamviewer
#https://www.teamviewer.com/en/download/linux/
#https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

# = remote
dnf_install tigervnc
dnf_install freerdp

# dnf_install vlc # hung...
dnf_install gimp

dnf_install gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1 gstreamer1-plugins-base-tools gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly
# totem is ok
# could play mp3, no need installing more plugins
# no need installing flashplayer for music online and video online

# gitbook zim
sudo npm install gitbook-cli -g -registry=https://registry.npm.taobao.org
dnf_install Zim

dnf_install gnome-tweak-tool

_USER_HOME=/home/kylin
mkdir $_USER_HOME/.local/share/gnome-shell/extensions
#git clone https://github.com/mlutfy/hidetopbar.git hidetopbar@mathieu.bidon.ca
cp -r hidetopbar@mathieu.bidon.ca $_USER_HOME/.local/share/gnome-shell/extensions/
cd $_USER_HOME/.local/share/gnome-shell/extensions/hidetopbar@mathieu.bidon.ca
make schemas
gnome-shell-extension-tool -e hidetopbar@mathieu.bidon.ca
cd -


# === develope
dnf_install python3-devel
dnf_install gdb
dnf_install cmake
dnf_install nmap
dnf_install nload
dnf_install iftop
dnf_install sysstat

dnf_install wireshark-gnome
sudo usermod -aG wireshark kylin
# = dbeaver
#aria2c https://github.com/dbeaver/dbeaver/releases/download/5.0.2/dbeaver-ce-5.0.2-stable.x86_64.rpm
#aria2c https://github.com/dbeaver/dbeaver/releases/download/5.0.2/dbeaver-ce-5.0.2-linux.gtk.x86_64.tar.gz
if sudo tar zxf ./dbeaver-ce-*.tar.gz -C /opt/; then
    sudo ln -sf /opt/dbeaver/dbeaver /usr/local/bin/dbeaver
    sudo chmod a+x /opt/dbeaver/dbeaver
fi
# vs code
#aria2c https://code.visualstudio.com/docs/?dv=linux64_rpm
dnf_install ./code-*.rpm
# jdk/jre
#http://www.oracle.com/technetwork/java/javase/downloads/index.html
sudo tar zxf ./jdk* -C /opt/

# config
sed -i '$aexport JAVA_HOME=/opt/jdk-10\nexport PATH=\$JAVA_HOME/bin:$PATH' /etc/profile

# with system
# git unzip wget

# === vbox-extpack
# aria2c https://download.virtualbox.org/virtualbox/5.2.8/Oracle_VM_VirtualBox_Extension_Pack-5.2.8.vbox-extpack
sudo VBoxManage extpack install ./Oracle_VM_VirtualBox_Extension_Pack-5.*.vbox-extpack
echo -e "\nenjoy"

exit

# === note

disable wayland: /etc/gdm/custom.conf

http://www.videolan.org/vlc/download-fedora.html
$> su -
#> dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
#> dnf install vlc
#> dnf install python-vlc npapi-vlc (optionals)

$ rpm -qa | grep gstream
gstreamer1-plugins-good-1.12.3-1.fc27.x86_64
gstreamer1-plugins-bad-free-gtk-1.12.3-1.fc27.x86_64
gstreamer1-1.12.3-1.fc27.x86_64
gstreamer1-plugins-bad-free-1.12.3-1.fc27.x86_64
gstreamer1-plugins-base-1.12.3-1.fc27.x86_64
gstreamer1-plugins-ugly-free-1.12.3-1.fc27.x86_64
PackageKit-gstreamer-plugin-1.1.7-1.fc27.x86_64
# vlc always hung...
