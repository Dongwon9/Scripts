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
run_install() {
  local name="$1"; shift
  printf "\n항목: %s\n" "$name"
  if "$@"; then
    echo "  ✓ 설치 성공: $name"
  else
    echo "  ✗ 설치 실패: $name"
  fi
}

# ── 설치 함수 ─────────────────────────────────────────────────────

install_zsh() {
  if command -v zsh &>/dev/null; then
    echo "  zsh가 이미 설치되어 있습니다: $(command -v zsh)"
    return 0
  fi
  case "$PKG_MGR" in
    dnf)    sudo dnf install -y zsh ;;
    apt)    sudo apt-get install -y zsh ;;
    pacman) sudo pacman -S --noconfirm zsh ;;
    *)      echo "  지원하지 않는 패키지 매니저 ($PKG_MGR)"; return 1 ;;
  esac
  set_zsh_default
}

install_nvm() {
  local version="v0.40.3"
  curl -fsSo- "https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh" | bash
}

install_antigen() {
  curl -L git.io/antigen > ~/.antigen.zsh
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

install_intellij() {
  local install_dir="/opt/idea"

  if [ -d "$install_dir" ]; then
    echo "  IntelliJ IDEA가 이미 설치되어 있습니다: $install_dir"
    return 0
  fi

  # 최신 Community Edition 버전 조회
  local version
  version=$(curl -fsSL "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release" \
    | grep -oP '"version":"\K[^"]+' | head -1)

  if [ -z "$version" ]; then
    echo "  버전 조회 실패. 버전을 직접 지정하려면 스크립트를 수정하세요."
    return 1
  fi

  local tarball="ideaIC-${version}.tar.gz"
  echo "  버전: $version — 다운로드 중..."
  curl -fsSL -o "/tmp/${tarball}" \
    "https://download.jetbrains.com/idea/${tarball}"

  sudo mkdir -p "$install_dir"
  sudo tar -xzf "/tmp/${tarball}" -C "$install_dir" --strip-components=1
  rm -f "/tmp/${tarball}"

  sudo ln -sf "${install_dir}/bin/idea" /usr/local/bin/idea

  sudo tee /usr/share/applications/idea.desktop > /dev/null <<EOF
[Desktop Entry]
Name=IntelliJ IDEA Community
Exec=${install_dir}/bin/idea %f
Icon=${install_dir}/bin/idea.png
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=jetbrains-idea-ce
EOF
}

set_zsh_default() {
  chsh -s "$(command -v zsh)"
  echo "  ✓ 기본 셸 변경 완료."
}

# ── 항목 정의 ─────────────────────────────────────────────────────
ITEM_NAMES=("zsh" "nvm" "antigen" "VS Code" "D2Coding" "Claude Code" "IntelliJ IDEA")
ITEM_FUNCS=(install_zsh install_nvm install_antigen install_vscode install_d2coding install_claude_code install_intellij)

# ── 메뉴 표시 ─────────────────────────────────────────────────────
show_menu() {
  echo ""
  echo "============================"
  echo " 설치 항목 선택"
  echo "============================"
  for i in "${!ITEM_NAMES[@]}"; do
    printf " [%d] %s\n" "$((i+1))" "${ITEM_NAMES[$i]}"
  done
  echo "============================"
  printf "번호를 공백으로 구분하여 입력하세요 (예: 1 3 5)\n"
  printf "'all' 입력 시 전체 선택, 엔터만 누르면 종료: "
}

# ── 선택 파싱 → SELECTED 배열에 인덱스 저장 ───────────────────────
SELECTED=()

parse_selection() {
  local input="$1"
  local count="${#ITEM_NAMES[@]}"

  if [ -z "$input" ]; then
    return
  fi

  if [ "$input" = "all" ]; then
    for i in "${!ITEM_NAMES[@]}"; do
      SELECTED+=("$i")
    done
    return
  fi

  local token
  local -a tokens
  # 쉼표를 공백으로 치환 후 공백 기준으로 토큰 분리 (IFS=$'\n\t' 우회)
  IFS=' ' read -ra tokens <<< "${input//,/ }"
  for token in "${tokens[@]}"; do
    if [[ "$token" =~ ^[0-9]+$ ]] && [ "$token" -ge 1 ] && [ "$token" -le "$count" ]; then
      SELECTED+=("$((token-1))")
    else
      echo "  경고: '$token'은 유효하지 않은 번호입니다. 무시합니다."
    fi
  done
}

# ── 설치 실행 ─────────────────────────────────────────────────────
if [ "$AUTO_YES" = true ]; then
  for i in "${!ITEM_NAMES[@]}"; do
    SELECTED+=("$i")
  done
else
  show_menu
  read -r user_input
  parse_selection "$user_input"
fi

if [ "${#SELECTED[@]}" -eq 0 ]; then
  echo ""
  echo "선택된 항목이 없습니다. 종료합니다."
  exit 0
fi

echo ""
echo "선택된 항목:"
for idx in "${SELECTED[@]}"; do
  echo "  • ${ITEM_NAMES[$idx]}"
done
echo ""

for idx in "${SELECTED[@]}"; do
  run_install "${ITEM_NAMES[$idx]}" "${ITEM_FUNCS[$idx]}"
done

echo
echo "✓ 완료."
