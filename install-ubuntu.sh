#!/usr/bin/env bash

sudo apt-add-repository -y ppa:git-core/ppa

sudo apt update

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
  unzip

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

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash

# install oh my zsh, if not
if [ -d ~/.oh-my-zsh ]; then
  echo "oh-my-zsh is installed"
else
  echo "oh-my-zsh is not installed, installing"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# install oh my zsh plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-better-npm-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion

chsh -s $(which zsh)
# source ~/.zshrc

read -p "Enter email for SSH and GPG: " promt_email
read -p "Enter GPG signing key for git: " promt_gpg_signingkey

ssh-keygen -t ed25519 -C "$promt_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

gpg --full-generate-key

git config --global user.signingkey $promt_gpg_signingkey
git config --global user.email "$promt_email"
