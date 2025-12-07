# Antigen 초기화
source ~/antigen.zsh   # 설치 위치에 따라 수정

# Oh My Zsh 불러오기
antigen use oh-my-zsh

# 테마
antigen theme robbyrussell

# 플러그인
antigen bundle git
antigen bundle z
antigen bundle sudo
antigen bundle history-substring-search
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle aliases
antigen bundle extract
antigen bundle nvm
antigen bundle vscode
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# 적용
antigen apply


# 편집기 설정
export EDITOR=vim
export VISUAL="$EDITOR"

# 자동 업데이트
export UPDATE_ZSH_DAYS=13

# 보정 및 자동완성 옵션
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# 히스토리 설정
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


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
