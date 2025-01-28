# → .zshenv, always                 macos YES, Ubuntu YES
# → .zprofile, if login shell       macos YES, Ubuntu NOT
# → .zshrc, if interactive shell    macos YES, Ubuntu YES
# → .zlogin, if login shell         macos YES, Ubuntu NOT
# → .zlogout, if login shell

# ----------------------------------------------------------------
# macOS
# ----------------------------------------------------------------
if [[ $(uname) == "Darwin" ]]; then
source $HOME/.zsh-stage2

# ----------------------------------------------------------------
# Debian Ubuntu
# ----------------------------------------------------------------
elif command -v apt > /dev/null; then
source $HOME/.zsh-stage2
source $HOME/.zsh-stage3

# ----------------------------------------------------------------
# Unknown
# ----------------------------------------------------------------
else
    echo 'Unknown OS!'
fi
