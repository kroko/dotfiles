# .zshenv

# ================================
# COMMON
# ================================

# ================================
# Editor
# export EDITOR=vi

# ================================
# locale
# ================================

# /etc/ssh/ssh_config.d/100-macos.conf has SendEnv LANG LC_*
# thus user level unsets (e.g. ~/.ssh/config.d/100-locale.conf) will not work
if [[ $(uname) == "Darwin" ]]; then
  export LC_CTYPE=en_US.UTF-8
fi
# ================================
# homebrew bins
# ================================

if [[ $(uname) == "Darwin" ]]; then
  # ----------------
  # Some extra stuff
  export PATH="/usr/local/sbin:$PATH"
  # ----------------
  # Homebrew
  # x64
  export PATH="/usr/local/bin:$PATH"
  # arm
  export PATH="/opt/homebrew/bin:$PATH"
  # export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"
  export DYLD_FALLBACK_LIBRARY_PATH="/opt/homebrew/bin/lib:$DYLD_FALLBACK_LIBRARY_PATH"
fi

# ================================
# local bins
# ================================
export PATH="$HOME/.local/bin:$PATH"

# ================================
# gpg
export GPG_TTY=`tty`

# ================================
# NVM
export NVM_DIR="$HOME/.nvm"

# ================================
# Composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# ================================
# rustup
# ================================
. "$HOME/.cargo/env" 2>/dev/null

# ================================
# uv python

# startup file for interactive python interpreter
export PYTHONSTARTUP=$HOME/.python-startup

# ================================
# govm for Golang
# https://github.com/sbonaiva/govm
export PATH=$PATH:$HOME/.govm/bin
export GOROOT=$HOME/.govm/go
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/.govm/go/bin

# ================================
# g for Golang
# https://github.com/stefanmaric/g
# export GOPATH="$HOME/.go/go"; export GOROOT="$HOME/.go/root"; export PATH="$GOPATH/bin:$PATH";
# alias govm="$GOPATH/bin/g";

# ================================
# phpvm for PHP
export PHPVM_DIR=$HOME/.phpvm
export PATH="$PHPVM_DIR/bin:$PATH"

# # ================================
# # Ruby
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"


# ================================
# lms LM Studio
if [[ $(uname) == "Darwin" ]]; then
  export PATH=$HOME/.lmstudio/bin:$PATH
fi

# ================================
# ollama
# 16384, 24576, 32768
export OLLAMA_CONTEXT_LENGTH=24576
export OLLAMA_KEEP_ALIVE=5m
export OLLAMA_NUM_PARALLEL=1
export OLLAMA_MAX_LOADED_MODELS=3
export OLLAMA_MAX_QUEUE=512

# ================================
# opencode
export PATH=$HOME/.opencode/bin:$PATH

# ================================
# macOS
# ================================
if [[ $(uname) == "Darwin" ]]; then


  # ----------------
  # VS Code
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

  # ----------------
  # Docker Desktop
  export PATH="$HOME/.docker/bin:$PATH"

  # # ----------------
  # # Qt
  # export PATH="/usr/local/sbin:$PATH"
  # export PATH="/usr/local/opt/qt/bin:$PATH"

  # # ----------------
  # Setting PATH for Python 2.7
  # The original version is saved in .zprofile.pysave
  export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

  # ----------------
  # STM32
  export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources

# ================================
# Debian Ubuntu
# ================================
elif command -v apt > /dev/null; then

  # ----------------

  export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

fi
