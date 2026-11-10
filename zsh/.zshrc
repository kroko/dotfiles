# Login + Interactive:
# .zshenv → .zprofile → .zshrc → .zlogin → EXIT → .zlogout
# Login + Non-interactive:
# .zshenv → .zprofile → .zlogin → EXIT → .zlogout
# Non-login + Interactive:
# .zshenv → .zshrc → EXIT
# Non-login + Non-interactive:
# .zshenv → EXIT

KROKO_ZSH_STAGE=2

typeset -ga KROKO_ZSH_SOURCING

# if we are on BSD desktop that runs DE terminal not as a login shell
# bring in stuff manually (whatever the terminal settings)
if [[ ! -o login ]]; then
  # but extra check, this is why KROKO_ZSH_SOURCING flag guard is here
  # for stages 1 to 3, meaning .zprofile → .zshrc → .zlogin
  for ((stage = 1; stage <= 3; stage++)); do
    if [[ ${KROKO_ZSH_SOURCING[$((stage + 1))]} != true ]]; then
      source "$HOME/.zsh-stages/stage-$stage.zsh"
      KROKO_ZSH_SOURCING[$((stage + 1))]=true
    fi
  done

# else if login shell all cool
# .zprofile (stage 1) was sourced and .zlogin (stage 3) will be sourced
else
  source "$HOME/.zsh-stages/stage-$KROKO_ZSH_STAGE.zsh"
  KROKO_ZSH_SOURCING[$((KROKO_ZSH_STAGE + 1))]=true
fi

return
