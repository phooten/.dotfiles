#!/usr/bin/env zsh

if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="ansible,bash,bin,ssh,tmux,vim"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/code/.dotfiles
fi

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -D $folder
    stow $folder
done
popd
