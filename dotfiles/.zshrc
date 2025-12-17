source ~/antigen.zsh
antigen init ~/.antigenrc
export MY_EMAIL="goodongwon329@gmail.com"
export EDITOR=vim
export VISUAL="$EDITOR"

ENABLE_CORRECTION="true"

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

# nvm lazy loading
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f node npm npx nvm pnpm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

node() { _load_nvm; node "$@"; }
npm() { _load_nvm; npm "$@"; }
npx() { _load_nvm; npx "$@"; }
nvm() { _load_nvm; nvm "$@"; }
pnpm() {_load_nvm; pnpm "$@"; }
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
