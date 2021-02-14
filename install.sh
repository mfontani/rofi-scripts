#!/bin/bash

set -eu

INSTALL_DIR="$HOME/bin"
if [[ ! -d "$INSTALL_DIR" ]]; then
    INSTALL_DIR="$HOME/.local/bin"
    if [[ ! -d "$INSTALL_DIR" ]]; then
        >&2 echo 'Cannot find either ~/bin nor ~/.local/bin. Aborting.'
        exit 1
    fi
fi

set +u
if [[ -n "$2" ]]; then
    >&2 echo 'Too many args.'
    >&2 echo 'Usage: ./install.sh [-f]'
    exit 1
fi
FORCE=0
if [[ -n "$1" ]]; then
    if [[ "-f" == "$1" ]]; then
        FORCE=1
    else
        >&2 echo "Bad option: $1"
        >&2 echo 'Usage: ./install.sh [-f]'
        exit 1
    fi
fi
set -u

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for f in ./rofi-* ; do
    [[ ! -f "$f" ]] && continue
    TARGET="$INSTALL_DIR/$(basename "$f")"
    do_it=0
    if [[ "1" == "$FORCE" ]]; then
        do_it=1
    fi
    if [[ -f "$TARGET" ]]; then
        if [[ "1" == "$do_it" ]]; then
            rm -vf "$TARGET"
        else
            >&2 echo "Already exists. use '-f' to force install: $TARGET"
            continue
        fi
    fi
    ln -svf "$SCRIPT_DIR/$(basename "$f")" "$INSTALL_DIR/$(basename "$f")"
done
