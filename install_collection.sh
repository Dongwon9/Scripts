#!bash
set -u
IFS=$'\n\t'

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
  ["omz"]='sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'
  ["code"]="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e \"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update &&
sudo dnf install code"
  ["zsh-syntax-highlighting"]='git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
  ["zsh-autosuggestions"]='git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
  ["antigen"]='curl -L git.io/antigen >~/antigen.zsh'
)

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

# 반복해서 항목 처리
for check_cmd in "${!installs[@]}"; do
  install_cmd="${installs[$check_cmd]}"

  printf "항목: %s\n" "$check_cmd"
  echo "  -> 설치 명령: $install_cmd"
  if ask_yes_no "  설치하시겠습니까?"; then
    # 설치 명령을 실행. 실패해도 전체 루프는 계속 진행.
    if bash -c "$install_cmd"; then
      echo "  설치 성공: $check_cmd"
    fi
  else
    echo "  건너뜀."
  fi
done

