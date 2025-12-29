#!/bin/bash
set -u
IFS=$'\n\t'

# 함수: 설치 여부 묻기
ask_yes_no() {
  local prompt="$1"
  if [ "$AUTO_YES" = true ]; then
    return 0
  fi

  while true; do
    read -r -p "$prompt [y/N]: " ans
    case "$ans" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo]|"") return 1 ;;
      *) echo "y 또는 n을 입력하세요." ;;
    esac
  done
}

# 자동 승인 플래그 (true면 묻지 않고 설치)
AUTO_YES=false
while getopts "y" opt; do
  case "$opt" in
    y) AUTO_YES=true ;;
    *) ;;
  esac
done
shift $((OPTIND-1))

# 설치할 항목을 여기서 정의: 키=검사명, 값=실행할 설치 명령(완전한 쉘 명령)
declare -A installs=(
  ["nvm"]="curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"
  ["code"]="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e \"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null &&
sudo dnf check-update; sudo dnf install -y code"
  ["antigen"]="curl -L git.io/antigen >\"$HOME\"/antigen.zsh"
  ["D2Coding"]="curl -L -o /tmp/d2coding.zip https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip && unzip /tmp/d2coding.zip -d /tmp/D2Coding && rm /tmp/d2coding.zip && sudo mv /tmp/D2Coding /usr/share/fonts/D2Coding && fc-cache -fv"
)
# zsh를 기본 셸로 설정 (설치되어 있고 기본 셸이 아닌 경우)
if command -v zsh &> /dev/null && [ "$SHELL" != "$(command -v zsh)" ]; then
  if ask_yes_no "zsh를 기본 셸로 설정하시겠습니까?"; then
    chsh -s "$(command -v zsh)"
    echo "  ✓ zsh를 기본 셸로 설정했습니다."
  fi
fi


# 반복해서 항목 처리
for check_cmd in "${!installs[@]}"; do
  install_cmd="${installs[$check_cmd]}"

  printf "항목: %s\n" "$check_cmd"
  echo "설치 명령: $install_cmd"
  if ask_yes_no "설치하시겠습니까?"; then
    if bash -c "$install_cmd"; then
      echo "  ✓ 설치 성공: $check_cmd"
    else
      echo "  ✗ 설치 실패: $check_cmd (exit code: $?)"
    fi
  else
    echo "  건너뜀."
  fi
done

