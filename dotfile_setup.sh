#!/usr/bin/env bash

# 스크립트가 있는 디렉터리
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

echo "Source directory: $SCRIPT_DIR"
echo "Home directory:   $HOME"
echo

shopt -s dotglob

for entry in "$SCRIPT_DIR"/.[!.]* "$SCRIPT_DIR"/..?*; do
    [ -e "$entry" ] || continue

    name="$(basename "$entry")"

    # 필요 없는 항목 제외
    case "$name" in
        .|..|.git|.gitignore) continue ;;
    esac

    target="$HOME/$name"

    # 기존 파일(혹은 링크)이 있을 경우
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "이미 존재합니다: $target"

        while true; do
            read -r -p "삭제하고 새 링크를 만들까요? [y/n]: " ans
            case "$ans" in
                y|Y)
                    rm -rf -- "$target"
                    echo "삭제 완료."
                    break
                    ;;
                n|N)
                    echo "건너뜀: $name"
                    continue 2
                    ;;
                *)
                    echo "y 또는 n 입력 필요"
                    ;;
            esac
        done
    fi

    ln -s "$entry" "$target"
    echo "링크 생성: $target -> $entry"
done

echo
echo "완료."


