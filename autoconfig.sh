if ! rpm -qa | grep -i "virtualbox" > /dev/null; then
    sudo timedatectl set-timezone Asia/Shanghai

    # repo
    sudo mv /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora.repo.backup
    sudo mv /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-updates.repo.backup
    sudo curl -o /etc/yum.repos.d/fedora.repo http://mirrors.aliyun.com/repo/fedora.repo
    sudo curl -o /etc/yum.repos.d/fedora-updates.repo http://mirrors.aliyun.com/repo/fedora-updates.repo
    # sudo yum makecache

    #curl -O https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    #curl -O https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y ./rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y ./rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # === wubi
    sudo dnf install -y ibus-table-chinese-wubi-jidian

    # === dependency
    sudo dnf install -y gcc gcc-c++ kernel-{headers,devel}-`uname -r`

    # === virtualbox
    # aria2c https://download.virtualbox.org/virtualbox/5.2.8/VirtualBox-5.2-5.2.8_121009_fedora26-1.x86_64.rpm
    sudo dnf install -y ./VirtualBox-5.2-5.2.8_121009_fedora26-1.x86_64.rpm

    # aria2c https://download.virtualbox.org/virtualbox/5.2.8/Oracle_VM_VirtualBox_Extension_Pack-5.2.8.vbox-extpack
    sudo VBoxManage extpack install ./Oracle_VM_VirtualBox_Extension_Pack-5.2.8.vbox-extpack
    sudo usermod -a -G vboxusers kylin

    echo "reboot and rerun this script"
    exit
fi

sudo dnf install -y npm

# = vim
# sudo oh-my-vim/install # vim

# = pomodoro
#sudo dnf install -y gnome-shell-extension-pomodoro

sudo dnf install -y aria2
sudo dnf install -y axel
sudo dnf install -y tmux

sudo dnf install -y python3-shadowsocks
# sudo sslocal -c /etc/shadowsocks-jdb.json -d start
# google-chrome --proxy-server="socks://localhost:1080"

sudo dnf install -y ack

# = chrome
#curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install -y ./google-chrome-stable_current_x86_64.rpm

# = teamviewer
#https://www.teamviewer.com/en/download/linux/
#https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

# sudo dnf install -y vlc # hung...
sudo dnf install -y gimp

sudo dnf install -y gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base gstreamer1 gstreamer1-plugins-base-tools gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly
# totem is ok
# could play mp3, no need installing more plugins
# no need installing flashplayer for music online and video online

# gitbook zim
sudo npm install gitbook-cli -g -registry=https://registry.npm.taobao.org
sudo dnf install -y Zim

sudo dnf install -y gnome-tweak-tool

_USER_HOME=/home/kylin
mkdir $_USER_HOME/.local/share/gnome-shell/extensions
#git clone https://github.com/mlutfy/hidetopbar.git hidetopbar@mathieu.bidon.ca
cp -r hidetopbar@mathieu.bidon.ca $_USER_HOME/.local/share/gnome-shell/extensions/
cd $_USER_HOME/.local/share/gnome-shell/extensions/hidetopbar@mathieu.bidon.ca
make schemas
gnome-shell-extension-tool -e hidetopbar@mathieu.bidon.ca
cd -


# === develope
sudo dnf install -y python3-devel
sudo dnf install -y cmake
sudo dnf install -y nmap
sudo dnf install -y sysstat
sudo dnf install -y wireshark-gnome
sudo usermod -aG wireshark kylin
# = dbeaver
#aria2c https://github.com/dbeaver/dbeaver/releases/download/5.0.2/dbeaver-ce-5.0.2-stable.x86_64.rpm
#aria2c https://github.com/dbeaver/dbeaver/releases/download/5.0.2/dbeaver-ce-5.0.2-linux.gtk.x86_64.tar.gz
sudo tar zxf ./dbeaver-ce-*.tar.gz -C /opt/
sudo ln -s /opt/dbeaver/dbeaver /usr/local/bin/dbeaver
sudo chmod a+x /opt/dbeaver/dbeaver
# vs code
#https://code.visualstudio.com/docs/?dv=linux64_rpm
sudo dnf install -y ./code-*.rpm
# jdk/jre
#http://www.oracle.com/technetwork/java/javase/downloads/index.html
sudo tar zxf ./jdk* -C /opt/

# config
sed -i '$aexport JAVA_HOME=/opt/jdk-10\nexport PATH=\$JAVA_HOME/bin:$PATH' /etc/profile

# with system
# git unzip wget


exit

# === note

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
