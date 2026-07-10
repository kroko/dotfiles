# → .zshenv, always                 macos YES, Ubuntu desktop YES
# → .zprofile, if login shell       macos YES, Ubuntu desktop NOT
# → .zshrc, if interactive shell    macos YES, Ubuntu desktop YES
# → .zlogin, if login shell         macos YES, Ubuntu desktop NOT
# → .zlogout, if login shell        macos YES

if [[ $(uname) == "Darwin" ]]; then
  source $HOME/.zsh-stage2
elif command -v apt > /dev/null; then
  source $HOME/.zsh-stage1
  source $HOME/.zsh-stage2
  source $HOME/.zsh-stage3
else
  echo 'Unknown OS!'
fi

return
