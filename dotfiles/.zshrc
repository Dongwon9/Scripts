source ~/.bashrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' verbosity silent
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git z sudo history-substring-search colored-man-pages command-not-found aliases extract nvm vscode zsh-syntax-highlighting zsh-autosuggestions)

export EDITOR=vim
export VISUAL="$EDITOR"

HIST_STAMPS="yyyy-mm-dd"
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

source $ZSH/oh-my-zsh.sh
