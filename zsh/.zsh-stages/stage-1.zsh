# .zprofile

# ================================
# gpg
if command -v gpgconf > /dev/null ; then
  gpgconf --launch gpg-agent
fi

# ================================
# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ================================
# rustup
# ================================

# # this is only if rustup is installed via brew, which we are not doing, using official script
# if [[ $(uname) == "Darwin" ]] ; then
#   export PATH=$(brew --prefix rustup)/bin:"$PATH"
# fi

# ================================
# uv python

if command -v uv > /dev/null ; then
  # https://docs.astral.sh/uv/getting-started/installation/
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi

# ================================
# phpvm for PHP
if [[ -s "$PHPVM_DIR/phpvm.sh" ]]; then
  source "$PHPVM_DIR/phpvm.sh"
fi

# ================================
# ollama
if [[ $(uname) == "Darwin" ]]; then
  # 16384, 24576, 32768
  launchctl setenv OLLAMA_CONTEXT_LENGTH 24576
  launchctl setenv OLLAMA_KEEP_ALIVE 5m
  launchctl setenv OLLAMA_NUM_PARALLEL 1
  launchctl setenv OLLAMA_MAX_LOADED_MODELS 3
  launchctl setenv OLLAMA_MAX_QUEUE 512
fi
