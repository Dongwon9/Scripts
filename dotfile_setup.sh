#!/usr/bin/env bash
set -u  # 미정의 변수 사용 시 에러

# 자동 승인 플래그
AUTO_YES=false
while getopts "y" opt; do
  case "$opt" in
    y) AUTO_YES=true ;;
    *) ;;
  esac
done
shift $((OPTIND-1))

# 스크립트가 있는 디렉터리
SCRIPT_DIR="$(dirname "$(realpath "$0")")/dotfiles"

if [ ! -d "$SCRIPT_DIR" ]; then
    echo "✗ 에러: dotfiles 디렉터리를 찾을 수 없습니다: $SCRIPT_DIR"
    exit 1
fi

cd "$SCRIPT_DIR"

echo "Source directory: $SCRIPT_DIR"
echo "Home directory:   $HOME"
echo

shopt -s dotglob nullglob

for entry in "$SCRIPT_DIR"/.*; do
    [ -e "$entry" ] || continue

    name="$(basename "$entry")"

    # 필요 없는 항목 제외
    case "$name" in
        .|..|.git|.gitignore) continue ;;
    esac

    target="$HOME/$name"

    # 기존 파일(혹은 링크)이 있을 경우
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "⚠ 이미 존재합니다: $target"

        # 자동 승인 모드가 아니면 물어봄
        if [ "$AUTO_YES" = false ]; then
            while true; do
                read -r -p "삭제하고 새 링크를 만들까요? [y/n]: " ans
                case "$ans" in
                    y|Y)
                        break
                        ;;
                    n|N)
                        echo "  건너뜀: $name"
                        continue 2
                        ;;
                    *)
                        echo "  y 또는 n 입력 필요"
                        ;;
                esac
            done
        fi

        if rm -rf -- "$target"; then
            echo "  삭제 완료."
        else
            echo "  ✗ 삭제 실패: $target"
            continue
        fi
    fi

    if ln -s "$entry" "$target"; then
        echo "✓ 링크 생성: $target -> $entry"
    else
        echo "✗ 링크 생성 실패: $target"
    fi
done

echo
echo "✓ 완료."


