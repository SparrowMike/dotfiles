#!/usr/bin/env zsh
# Enhanced .zshrc configuration

# =============================================================================
# CONFIGURATION FLAGS
# =============================================================================
USE_STARSHIP=false

# =============================================================================
# THEME SETUP
# =============================================================================
if [[ "$USE_STARSHIP" == true ]]; then
    # Starship prompt (faster startup)
    if command -v starship >/dev/null 2>&1; then
        eval "$(starship init zsh)"
    fi
else
    # Powerlevel10k instant prompt
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
fi

# =============================================================================
# ZINIT SETUP
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
# THEME (P10K only if not using Starship)
# =============================================================================
if [[ "$USE_STARSHIP" != true ]]; then
    zinit ice depth=1
    zinit light romkatv/powerlevel10k
fi

# =============================================================================
# CORE PLUGINS
# =============================================================================
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::node \
    OMZP::npm \
    OMZP::colored-man-pages

# History substring search
zinit ice wait lucid
zinit load zsh-users/zsh-history-substring-search

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# =============================================================================
# NAVIGATION
# =============================================================================
# Autojump - prefer homebrew version if available
if command -v brew >/dev/null 2>&1 && [[ -s "$(brew --prefix)/etc/profile.d/autojump.sh" ]]; then
    source "$(brew --prefix)/etc/profile.d/autojump.sh"
else
    zinit ice wait lucid
    zinit light wting/autojump
fi

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================
export LANG=en_US.UTF-8

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

PROMPT_BENCHMARK=false

if [[ "$PROMPT_BENCHMARK" == true ]]; then
    autoload -Uz add-zsh-hook
    
    prompt_benchmark_preexec() {
        PROMPT_START_TIME=$EPOCHREALTIME
    }
    
    prompt_benchmark_precmd() {
        if [[ -n $PROMPT_START_TIME ]]; then
            local elapsed=$(( EPOCHREALTIME - PROMPT_START_TIME ))
            if (( elapsed > 0.5 )); then
                echo "⚠️  Slow prompt: ${elapsed}s"
            fi
            unset PROMPT_START_TIME
        fi
    }
    
    add-zsh-hook preexec prompt_benchmark_preexec
    add-zsh-hook precmd prompt_benchmark_precmd
fi

# Path management function to prevent duplicates
#
path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

# Node.js (Volta)
if [[ -d "$HOME/.volta" ]]; then
    export VOLTA_HOME="$HOME/.volta"
    path_prepend "$VOLTA_HOME/bin"
fi

# Anaconda
if [[ -d "/opt/homebrew/anaconda3/bin" ]]; then
    path_prepend "/opt/homebrew/anaconda3/bin"
fi

# Android development
if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_HOME/emulator"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

# =============================================================================
# ALIASES
# =============================================================================
# System
alias ls='lsd'
alias l='ls -l'
alias ll='ls -al'
alias lt='ls --tree'
alias lg='lazygit'
alias k='clear'
alias v='nvim'
alias t='tmux'
alias ta='tmux attach'

# NPM aliases
alias n='npx git-cz'
alias s='npm run start'
alias d='npm run dev'
alias b='npm run build'
alias p='npm run prettier'

# Project aliases
alias chordie='cd ~/Documents/chordie && code . && npm run dev'
alias shif='cd ~/Documents/shift && code . && npm run ios'
alias e='cd ~/Documents/WorkWise && code . && npm run dev'
alias m='cd ~/Documents/mobile && code . && d'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222'
alias kv='clear && nvim'

# =============================================================================
# FUNCTIONS
# =============================================================================
# Java version switching
javahome() {
    unset JAVA_HOME 
    export JAVA_HOME=$(/usr/libexec/java_home -v "$1")
    java -version
}
alias j11='javahome 11'
alias j17='javahome 17'

# =============================================================================
# KEY BINDINGS
# =============================================================================
bindkey "^X\x7f" backward-kill-line
bindkey '^[[Z' reverse-menu-complete 
bindkey '^I' menu-complete 

# History substring search bindings (set after plugin loads)
if [[ -n "${functions[history-substring-search-up]}" ]]; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

# =============================================================================
# SOURCE CONFIGS
# =============================================================================
# Load P10k config (only if using P10k)
if [[ "$USE_STARSHIP" != true && -f ~/.p10k.zsh ]]; then
    source ~/.p10k.zsh
fi

# Load FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Interactive shell setup
if [[ -o interactive ]]; then
    # Load private environment variables
    [[ -f ~/.env.local ]] && source ~/.env.local
    
    # Optional startup visuals (uncomment if desired)
    # neofetch | lolcat
    # figlet -f isometric1 -c 'ETC' | lolcat
    # figlet -f small -c 'is there a better way?' | lolcat
fi

# Uncomment to enable vi mode
# set -o vi
