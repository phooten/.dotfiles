################################################################################
# .bashrc template
################################################################################

# ==============================================================================
# ALIAS
# ==============================================================================
# Utility:
alias ls="ls --color=auto"
alias la="ls -la"
alias ll="ls -l"
alias lt="ls -ltra"

# ==============================================================================
# Aesthetics
# ==============================================================================
# Terminal Colors:
#   RESOURCES:
#       - https://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LSCOLORS=DxFxCxFxBxegedabagacad
export GREP_OPTIONS='--color=auto'

# ==============================================================================
# Setting Environment Variables
# ==============================================================================

# Need $HOME/bin in path for local scripts
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# XDG Base Directories:
if [ -z XDG_CONFIG_HOME ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z XDG_DATA_HOME ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z XDG_CACHE_HOME ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi

# ==============================================================================
# PROMPTS:
# ==============================================================================
#   TIME: \[\e[31m\]\D{%c}\[\e[0m\]
#   USER: [\[\e[1;43m\]\u\[\e[0m\]@\H]
#   DEFAULT: PS1="\[\e[36m\]\w\n\[\e[0m\]$ "
# Bold Yellow:     1;93
# Bold Cyan:     1;36
export PS1="\[\033[1;93m\]\u@\H: \w\n\[\033[1;36m\]\t Line:\#$ \[\033[0;37m\]"



