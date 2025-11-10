#!/bin/bash

for file in .*; do
    [ "$file" = "." ] && continue
    [ "$file" = ".." ] && continue
    target="$HOME/$file"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi
    ln -s "$(pwd)/$file" "$target"
done
