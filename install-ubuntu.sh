#!/usr/bin/env bash

sudo apt-add-repository ppa:git-core/ppa

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

