# .zprofile

# ================================
# gpg
if command -v gpgconf > /dev/null ; then
  gpgconf --launch gpg-agent
fi

# ================================
# ssh-agent
# ================================
if [[ $KROKO_OS == linux ]]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# ================================
# ollama
if [[ $KROKO_OS == darwin ]]; then
  # 16384, 24576, 32768
  launchctl setenv OLLAMA_CONTEXT_LENGTH 24576
  launchctl setenv OLLAMA_KEEP_ALIVE 5m
  launchctl setenv OLLAMA_NUM_PARALLEL 1
  launchctl setenv OLLAMA_MAX_LOADED_MODELS 3
  launchctl setenv OLLAMA_MAX_QUEUE 512
fi
