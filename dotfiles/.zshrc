export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' verbosity silent
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git z sudo history-substring-search colored-man-pages command-not-found aliases extract)
HIST_STAMPS="yyyy-mm-dd"
source $ZSH/oh-my-zsh.sh
