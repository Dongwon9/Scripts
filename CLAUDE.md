# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 개요

Linux 환경을 위한 개인 dotfiles 및 설치 스크립트 모음. 두 개의 메인 스크립트로 구성된다:

- `install_collection.sh` — 개발 도구(nvm, antigen, VS Code, D2Coding 폰트, Claude Code)를 설치. 실행 시 항목 목록을 한 번에 보여주고 선택 후 설치
- `dotfile_setup.sh` — `dotfiles/` 디렉터리 내 dotfile을 `$HOME`에 심볼릭 링크로 연결

## 스크립트 실행

```bash
# 개발 도구 설치 (메뉴에서 항목 선택 후 일괄 설치)
./install_collection.sh

# 자동 전체 설치 (-y: 전체 항목 선택 후 자동 설치)
./install_collection.sh -y

# dotfile 심볼릭 링크 설정
./dotfile_setup.sh

# dotfile 전체 덮어쓰기 (-y: 기존 파일 확인 없이 덮어씀)
./dotfile_setup.sh -y
```

## 아키텍처

### install_collection.sh

- `detect_pkg_manager()` — dnf / apt / pacman 순서로 감지, `$PKG_MGR` 변수에 저장
- `show_menu()` — 번호 목록으로 전체 항목 출력
- `parse_selection()` — 공백/쉼표 구분 숫자 또는 `all` 입력 파싱 → `SELECTED` 배열에 인덱스 저장
- `run_install <표시명> <함수명>` — 설치 함수 실행 후 성공/실패 출력
- `ITEM_NAMES` / `ITEM_FUNCS` 배열 — 항목 이름과 함수명을 인덱스로 대응
- 각 `install_*` 함수는 `$PKG_MGR`에 따라 분기하여 패키지 설치

새 설치 항목 추가 시: `install_<이름>()` 함수를 작성하고, `ITEM_NAMES`와 `ITEM_FUNCS` 배열 끝에 각각 이름과 함수명을 추가한다.

### dotfile_setup.sh

`dotfiles/` 디렉터리 내 숨김 파일(`.`으로 시작)을 `$HOME`에 심볼릭 링크로 연결한다. `.`, `..`, `.git`, `.gitignore`는 건너뛴다. 대상이 이미 존재하면 삭제 후 링크 생성(대화형 확인 또는 `-y`로 강제).

### dotfiles/

| 파일 | 역할 |
|------|------|
| `.zshrc` | zsh 설정 (antigen, p10k, pnpm, nvm, fzf, zoxide) |
| `.antigenrc` | antigen 플러그인 목록 + powerlevel10k 테마 |
| `.p10k.zsh` | powerlevel10k 프롬프트 설정 |
| `.vimrc` | vim 설정 |

`.zshrc`는 머신별 설정을 위해 `~/.zshrc_local`과 `~/.zsh_aliases`가 있으면 자동으로 소스한다. `.antigenrc`도 `~/.antigenrc_local`을 소스한다.

## 코딩 관례

- 스크립트 상단에 `set -uo pipefail` (install) / `set -euo pipefail` (dotfile_setup) 적용
- 한국어 주석과 사용자 메시지 사용
- 패키지 설치 함수는 멱등성을 고려하여 작성 (`command -v` 등으로 사전 확인 가능)
- install_collection은 `detect_pkg_manager()`를 활용하거나 배포판에 관계없는 설치 방법을 사용한다
