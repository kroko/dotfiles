#!/usr/bin/env bash

echo "================"
echo "file limits"

echo "fs.file-max = 65535" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
echo "root soft     nproc          65535" | sudo tee -a /etc/security/limits.conf && \
echo "root hard     nproc          65535" | sudo tee -a /etc/security/limits.conf && \
echo "root soft     nofile         65535" | sudo tee -a /etc/security/limits.conf && \
echo "root hard     nofile         65535" | sudo tee -a /etc/security/limits.conf
echo "session required pam_limits.so" | sudo tee -a /etc/pam.d/common-session
sudo sysctl -p
echo "DefaultLimitNOFILE=65535" | sudo tee -a /etc/systemd/system.conf
echo "DefaultLimitNOFILE=65535" | sudo tee -a /etc/systemd/user.conf
sudo systemctl daemon-reexec
ulimit -n


echo "================"
echo "add PPAs"

sudo apt-add-repository -y ppa:git-core/ppa

echo "================"
echo "update"

sudo apt update


echo "================"
echo "install"

# quick basics
sudo apt install -y \
  build-essential \
  git \
  libssl-dev \
  openssh-server \
  screen \
  tmux \
  curl \
  wget \
  unzip \
  bzip2

# zsh
sudo apt install -y \
  zsh

# stow
sudo apt install -y \
  stow \
  figlet

# gpg
sudo apt install -y \
  gpa \
  seahorse \
  pinentry-curses

# openvpn
sudo apt install -y \
  openvpn

# if desktop version then add ovpn in network manager gui
dpkg -l network-manager > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  sudo apt install -y \
    network-manager-openvpn
fi

# virt mounts
sudo apt install -y \
  bindfs

# install oh my zsh, if not
if [ -d ~/.oh-my-zsh ]; then
  echo "oh-my-zsh is installed"
else
  echo "oh-my-zsh is not installed, installing"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# install oh my zsh plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions && \
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
git clone https://github.com/lukechilds/zsh-better-npm-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion && \
git clone https://github.com/matthiasha/zsh-uv-env ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-uv-env

chsh -s $(which zsh)

exit 0
# source ~/.zshrc

# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# if qemu mount share (probably needs checking if virtio disk is there)
if sudo dmesg | grep -q qemu; then

  echo "this is QEMU"

  sudo apt install -y \
    spice-vdagent \
    qemu-guest-agent \
    spice-webdavd

  sudo apt install -y \
    mesa-utils \
    libgl1-mesa-dri \
    libgles2-mesa-dev

  glxinfo -B
  echo $XDG_SESSION_TYPE

  if ! grep -q '/mnt/utm' /etc/fstab ; then
    mkdir -p $HOME/utm
    sudo mkdir -p /mnt/utm
    echo "# qemu mounts /mnt/utm" | sudo tee -a /etc/fstab
    echo "share /mnt/utm 9p trans=virtio,version=9p2000.L,rw,_netdev,nofail,auto 0 0" | sudo tee -a /etc/fstab
    echo "/mnt/utm $HOME/utm fuse.bindfs map=501/1000:@20/@1000,x-systemd.requires=/mnt/utm,_netdev,nofail,auto 0 0" | sudo tee -a /etc/fstab
    systemctl daemon-reload
    # systemctl restart network-fs.target
    systemctl restart remote-fs.target
    # systemctl list-units --type=mount
  fi
fi

if sudo dmesg | grep -q vboxguest; then

  echo "this is Virtualbox"

  if ! grep -q '/media/sf_vbox' /etc/fstab ; then
    mkdir -p $HOME/sf_vbox
    echo "# vbox mounts /media/sf_vbox assuming folder name is se to vbox" | sudo tee -a /etc/fstab
    echo "/media/sf_vbox $HOME/sf_vbox fuse.bindfs map=0/1000:@984/@1000,x-systemd.requires=/media/sf_vbox,_netdev,nofail,auto 0 0" | sudo tee -a /etc/fstab
    systemctl daemon-reload
    systemctl restart remote-fs.target
  fi
fi


# read -p "Enter email for SSH and GPG: " promt_email
# read -p "Enter GPG signing key for git: " promt_gpg_signingkey

# ssh-keygen -t ed25519 -C "$promt_email"

chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519

# gpg --import private-key.asc
# gpg --import public-key.asc
# gpg --full-generate-key
# git config --global user.signingkey $promt_gpg_signingkey
# git config --global user.email "$promt_email"

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash


# /etc/default/grub
# GRUB_CMDLINE_LINUX="apparmor=0"
# sudo update-grub

# sudo systemctl stop apparmor
# sudo systemctl disable apparmor
aa-status

