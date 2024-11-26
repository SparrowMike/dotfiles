if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Core plugins
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
zinit light zsh-users/zsh-history-substring-search

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Autojump
zinit ice wait lucid
zinit light wting/autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Environment
export LANG=en_US.UTF-8
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/opt/homebrew/anaconda3/bin:$PATH"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator 
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Aliases
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

# Java version switching
javahome() {
  unset JAVA_HOME 
  export JAVA_HOME=$(/usr/libexec/java_home -v "$1")
  java -version
}
alias j11='javahome 11'
alias j17='javahome 17'

# Key bindings
bindkey "^X\x7f" backward-kill-line
bindkey '^[[Z' reverse-menu-complete 
bindkey '^I' menu-complete 
#
# Source configs
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -o interactive ]]; then
  source ~/.private_keys
  # neofetch | lolcat
  # figlet -f isometric1 -c 'ETC' | lolcat
  # figlet -f small -c 'is there a better way?' | lolcat
fi

# set -o vi
