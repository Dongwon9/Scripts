" 기본 예제 로드
source $VIMRUNTIME/vimrc_example.vim
" 백업/스왑/undo 디렉터리 없으면 생성
let s:vim_dirs = [expand('~/.vim/backup'), expand('~/.vim/swap'), expand('~/.vim/undo')]
for dir in s:vim_dirs
    if !isdirectory(dir)
        try
            " 대부분의 Vim/Neovim에서 부모 디렉터리까지 생성하려면 'p' 사용 가능
            call mkdir(dir, 'p')
        catch
            " 실패 시 안전하게 시스템 명령으로 생성 (유닉스 계열)
            call system('mkdir -p ' . shellescape(dir))
        endtry
    endif
endfor
" 백업 및 스왑 파일 설정
set backup              " 파일 편집 시 백업 생성
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile            " undo 정보 파일 저장
set undodir=~/.vim/undo//

" 편집 편의 설정
set number              " 줄 번호 표시
set showcmd             " 입력 중인 명령 표시
set cursorline          " 커서 위치 줄 강조
set wildmenu            " 명령어 자동완성 메뉴
set ignorecase          " 검색 시 대소문자 무시
set smartcase           " 검색에 대문자 포함 시 구체적 검색
set incsearch           " 검색 시 점진적 하이라이트
set hlsearch            " 검색어 하이라이트 유지

" 들여쓰기 설정
set expandtab           " 탭을 스페이스로
set shiftwidth=4        " 자동 들여쓰기 크기
set softtabstop=4       " 탭 입력 시 공간 수
set autoindent          " 자동 들여쓰기 유지
set smartindent         " 코드 스타일 지능적 자동 들여쓰기
    
" 화면 및 편집 최적화
set wrap                " 긴 줄 자동 줄바꿈
set linebreak           " 단어 단위 줄바꿈
set scrolloff=5         " 커서 주변 최소 줄 수
set sidescrolloff=5     " 가로 스크롤 여유
set clipboard=unnamedplus " 시스템 클립보드 공유
" 시각적 편의
set showmatch           " 괄호 짝 표시
set ruler               " 위치 표시
set laststatus=2        " 항상 상태줄 표시
set splitright          " 새 수직 창 오른쪽 열기

" 색상 및 테마
syntax on               " 문법 하이라이트

" 파일 종료 시 저장하지 않은 변경 경고
set confirm
