#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

# ── 패키지 매니저 감지 ────────────────────────────────────────────
detect_pkg_manager() {
  if   command -v dnf     &>/dev/null; then echo "dnf"
  elif command -v apt-get &>/dev/null; then echo "apt"
  elif command -v pacman  &>/dev/null; then echo "pacman"
  else echo "unknown"; fi
}

PKG_MGR="$(detect_pkg_manager)"

# ── 자동 승인 플래그 ──────────────────────────────────────────────
AUTO_YES=false
while getopts "y" opt; do
  case "$opt" in
    y) AUTO_YES=true ;;
    *) ;;
  esac
done
shift $((OPTIND-1))

# ── 유틸 ──────────────────────────────────────────────────────────
ask_yes_no() {
  local prompt="$1"
  [ "$AUTO_YES" = true ] && return 0
  while true; do
    read -r -p "$prompt [y/N]: " ans
    case "$ans" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo]|"")  return 1 ;;
      *) echo "y 또는 n을 입력하세요." ;;
    esac
  done
}

# 이름을 받아 설치 함수를 실행. 설치 여부를 물어보고 결과를 출력.
# 사용: run_install <표시명> <함수명> [인자...]
run_install() {
  local name="$1"; shift
  printf "\n항목: %s\n" "$name"
  if ask_yes_no "설치하시겠습니까?"; then
    if "$@"; then
      echo "  ✓ 설치 성공: $name"
    else
      echo "  ✗ 설치 실패: $name"
    fi
  else
    echo "  건너뜀."
  fi
}

# ── 설치 함수 ─────────────────────────────────────────────────────

install_nvm() {
  local version="v0.40.3"
  curl -fsSo- "https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh" | bash
}

install_antigen() {
  curl -fsSL https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen \
    -o "$HOME/antigen.zsh"
}

install_vscode() {
  case "$PKG_MGR" in
    dnf)
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
      sudo dnf install -y code
      ;;
    apt)
      wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor \
        | sudo tee /etc/apt/keyrings/packages.microsoft.gpg > /dev/null
      sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null <<'EOF'
deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main
EOF
      sudo apt-get update -q
      sudo apt-get install -y code
      ;;
    pacman)
      if   command -v yay  &>/dev/null; then yay  -S --noconfirm visual-studio-code-bin
      elif command -v paru &>/dev/null; then paru -S --noconfirm visual-studio-code-bin
      else
        echo "  AUR 헬퍼(yay/paru) 없음. 수동 설치: https://code.visualstudio.com/download"
        return 1
      fi
      ;;
    *)
      echo "  지원하지 않는 패키지 매니저 ($PKG_MGR). 수동 설치: https://code.visualstudio.com/download"
      return 1
      ;;
  esac
}

install_d2coding() {
  local zip="/tmp/d2coding.zip"
  local tmp_dir="/tmp/D2Coding"
  local font_dir="/usr/share/fonts/D2Coding"

  curl -fsSL -o "$zip" \
    https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip
  unzip -q "$zip" -d "$tmp_dir"
  rm -f "$zip"
  sudo mv "$tmp_dir" "$font_dir"
  fc-cache -fv
}

install_claude_code() {
    curl -fsSL https://claude.ai/install.sh | bash
}

# ── zsh 기본 셸 설정 ──────────────────────────────────────────────
if command -v zsh &>/dev/null && [ "$SHELL" != "$(command -v zsh)" ]; then
  printf "\n항목: zsh 기본 셸\n"
  if ask_yes_no "zsh를 기본 셸로 설정하시겠습니까?"; then
    chsh -s "$(command -v zsh)"
    echo "  ✓ 기본 셸 변경 완료."
  else
    echo "  건너뜀."
  fi
fi

# ── 설치 실행 (순서 중요 시 여기서 조정) ─────────────────────────
run_install "nvm"      install_nvm
run_install "antigen"  install_antigen
run_install "VS Code"  install_vscode
run_install "D2Coding" install_d2coding
run_install "Claude Code" install_claude_code
echo
echo "✓ 완료."
