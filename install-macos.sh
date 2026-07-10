#!/usr/bin/env bash

echo "================"
echo "devtools xcode-select"

xcode-select --install

echo "================"
echo "brew"

if ! command -v brew; then
  echo "no brew, installing"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "brew found"
fi

echo "brew update"
brew update

echo "================"
echo "install basics"

brew install \
  stow \
  gnupg \
  pinentry-mac \
  tmux \
  figlet

echo "================"
echo "oh-my-zsh"

# install oh my zsh, if not
if [ -d ~/.oh-my-zsh ]; then
  echo "oh-my-zsh is installed"
else
  echo "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# chsh -s $(which zsh)

# install oh my zsh plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-better-npm-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion
git clone https://github.com/matthiasha/zsh-uv-env ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-uv-env


source $HOME/.zshenv
source $HOME/.zprofile
source $HOME/.zshrc
source $HOME/.zlogin
omz reload

echo "================"
echo "rust via rustup"

if ! command -v rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
  rustc --version
  cargo --version
  mkdir -p $HOME/.zfunc
  rustup completions zsh > ~/.zfunc/_rustup
else
  echo "already setup"
fi

echo "================"
echo "python via uv"

curl -LsSf https://astral.sh/uv/install.sh | sh

echo "================"
echo "go via govm"

if ! command -v govm; then
  curl -s "https://raw.githubusercontent.com/sbonaiva/govm/refs/heads/main/scripts/install.sh" | bash
else
  echo "already setup"
fi

echo "================"
echo "node via nvm"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash

source $HOME/.zshenv
source $HOME/.zprofile
source $HOME/.zshrc
source $HOME/.zlogin
omz reload

echo "================"
echo "php"
curl -o- https://raw.githubusercontent.com/Thavarshan/phpvm/main/install.sh | bash
phpvm install latest-remote
phpvm use

echo "================"
echo "composer"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=$HOME/.local/bin --filename=composer
php -r "unlink('composer-setup.php');"
