if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" | lolcat
fi

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git node npm autojump history-substring-search zsh-syntax-highlighting zsh-autosuggestions colored-man-pages web-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# For a full list of active aliases, run `alias`.
alias ls='lsd'
alias l='ls -l'
alias ll='ls -al'
alias lt='ls --tree'

alias lg='lazygit'

alias c='colorls'
alias cc='colorls -lA --sd'
alias ccc='colorls --tree'
alias lc='lolcat'
# alias f='fuck'
alias k='clear'
alias n='npx git-cz'
alias s='npm run start'
alias d='npm run dev'
alias b='npm run build'
alias p='npm run prettier'

alias chordie='cd ~/Documents/chordie && code . && npm run dev'
alias shif='cd ~/Documents/shift && code . && npm run ios'

alias e='cd ~/Documents/WorkWise && code . && npm run dev'
alias m='cd ~/Documents/mobile && code . && d' 
alias play='cd ~/Documents && cd PlayJS && code . && nodemon app.js'
alias rm='rm -i'
alias v='nvim'
alias t='tmux'
alias ta='tmux attach'

# alias cp="ls main.cpp | entr -s 'g++ -std=c++17 main.cpp -o main && ./main'"
alias cp="ls *.cpp src/*.cpp | entr -s 'g++ -std=c++17 -I./include *.cpp src/*.cpp -o main && ./main'"

bindkey "^X\x7f" backward-kill-line
bindkey "^X\x7f" backward-kill-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# anaconda
export PATH="/opt/homebrew/anaconda3/bin:$PATH"

# bun completions
[ -s "/Users/mike/.bun/_bun" ] && source "/Users/mike/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator 
export PATH=$PATH:$ANDROID_HOME/platform-tools

# JAVA 
javahome() {
  unset JAVA_HOME 
  export JAVA_HOME=$(/usr/libexec/java_home -v "$1");
  java -version
}

alias j11='javahome 11'
alias j17='javahome 17'

# neofetch | lolcat
figlet -f isometric1 -c 'ETC' | lolcat
figlet -f small -c 'is there a better way?' | lolcat

# set -o vi

source ~/.private_keys
