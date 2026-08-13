#!/bin/bash
################################################################################
#
# File: dotfiles.sh
#
# Purpose:
#       Manage dotfiles using GNU Stow. It allows for the installation and
#       uninstallation of dotfile symlinks in the user's home directory.
#
# Usage:
#       ./dotfiles.sh [flag]
#
################################################################################

show_help() {
    echo "Usage: $0 [flag]"
    echo "Flags:"
    echo "  -i, --install    Install all dotfile symlinks to ~/"
    echo "  -u, --uninstall  Remove all dotfile symlinks from ~/"
    echo "  -h, --help       Show this help message"
}

if [[ -z $1 ]]; then
    show_help
    exit 1
fi

# Set files that should be stowed in the home directory
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS=(
        bin
        docker
        ssh
        tmux
        vim
        vscode
    )
fi

# The dotfiles directory is the current working directory if not set
if [[ -z $DOTFILES ]]; then
    DOTFILES=$(pwd)
fi

# Parse arguements and execute the appropriate action
case "$1" in
    -i|--install)
        pushd "$DOTFILES"
        for folder in ${STOW_FOLDERS[@]}
        do
            echo "Installing: stow $folder -> $HOME/"
            # Added -t $HOME to target the home directory explicitly
            stow -t "$HOME" -D "$folder" 2>/dev/null
            stow -t "$HOME" "$folder"
        done
        popd
        echo "Dotfiles successfully installed to home directory!"
        ;;

    -u|--uninstall)
        pushd "$DOTFILES"
        # for folder in $(echo "$STOW_FOLDERS" | sed "s/,/ /g")
        for folder in ${STOW_FOLDERS[@]}
        do
            echo "Uninstalling: stow -D $folder from $HOME/"
            # Added -t $HOME to remove from the home directory explicitly
            stow -t "$HOME" -D "$folder"
        done
        popd
        echo "Dotfiles cleanly uninstalled from home directory!"
        ;;

    -h|--help)
        show_help
        exit 0
        ;;

    *)
        echo "Error: Unknown option '$1'"
        show_help
        exit 1
        ;;
esac

# Print out environmental variables
# echo "============================================="
# echo "Environmental Variables"
# echo "  STOW_FOLDERS: ${STOW_FOLDERS[@]}"
# echo "  DOTFILES: ${DOTFILES}"
# echo "  HOME: ${HOME}"
# echo "============================================="
