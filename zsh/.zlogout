# → .zshenv, always                 macos YES, Ubuntu YES
# → .zprofile, if login shell       macos YES, Ubuntu NOT
# → .zshrc, if interactive shell    macos YES, Ubuntu YES
# → .zlogin, if login shell         macos YES, Ubuntu NOT
# → .zlogout, if login shell        macos YES

if [[ $(uname) == "Darwin" ]]; then
  source $HOME/.zsh-stage4
else
  echo 'this implementation sources .zlogout, but no scripts set!'
fi

return
