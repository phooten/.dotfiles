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
#
#   Actions:
#       ./dotfiles.sh -i | --install    Install all dotfile symlinks to ~/
#       ./dotfiles.sh -u | --uninstall  Remove all dotfile symlinks from ~/
#
#  Options:
#       ./dotfiles.sh -h | --help       Show this help message
#       ./dotfiles.sh -v | --verbose    Enable verbose output
#
################################################################################

VERBOSE=false
ACTION=""
DOTFILES=$(pwd)
PACKAGE_ROOT="$DOTFILES/packages"
# Set files that should be stowed in the home directory
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS=(
        bash
        bin
        docker
        ssh
        tmux
        vim
        vscode
    )
fi

verbose() {
    if [[ "$VERBOSE" == true ]]; then
        printf '%s\n' "$*"
    fi
}

set_action() {
    local new_action="$1"

    if [[ -n "$ACTION" ]]; then
        echo "ERROR:"
        echo "  Only one action flag may be used at a time: $ACTION and $new_action"
        show_help
        exit 1
    fi

    ACTION="$new_action"
}

debug_env() {
    if [[ "$VERBOSE" != true ]]; then
        return
    fi

    echo "============================================="
    echo "Environmental Variables"
    echo "  ACTION: ${ACTION}"
    echo "  DOTFILES: ${DOTFILES}"
    echo "  PACKAGE_ROOT: ${PACKAGE_ROOT}"
    echo "  HOME: ${HOME}"
    echo "  STOW_FOLDERS: ${STOW_FOLDERS[*]}"
    echo "  VERBOSE: ${VERBOSE}"
    echo "============================================="
}

show_help() {
    echo "Usage: $0 [action-flag] [options]"
    echo ""
    echo "Actions:"
    echo "  -i, --install    Install all dotfile symlinks to ~/"
    echo "  -u, --uninstall  Remove all dotfile symlinks from ~/"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -v, --verbose    Enable verbose output"
}

install_dotfiles() {
    pushd "$PACKAGE_ROOT" || exit 1

    verbose "Installing '${PACKAGE_ROOT}/<dir>' dotfiles from home directory '${HOME}'"
    for folder in "${STOW_FOLDERS[@]}"
    do
        verbose "   CMD: 'stow -t $HOME -D $folder 2>/dev/null'"
        stow -t "$HOME" -D "$folder" 2>/dev/null

        verbose "   CMD: 'stow -t $HOME $folder"
        stow -t "$HOME" "$folder"
    done

    popd || exit 1
    echo "Dotfiles successfully installed to home directory!"
}

uninstall_dotfiles() {
    pushd "$PACKAGE_ROOT" || exit 1

    verbose "Uninstalling '${PACKAGE_ROOT}/<dir>' dotfiles from home directory '${HOME}'"
    for folder in "${STOW_FOLDERS[@]}"
    do
        verbose "   CMD: 'stow -t $HOME -D $folder'"
        stow -t "$HOME" -D "$folder"
    done

    popd || exit 1
    echo "Dotfiles cleanly uninstalled from home directory!"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--install)
            set_action "install"
            ;;
        -u|--uninstall)
            set_action "uninstall"
            ;;
        -v|--verbose)
            VERBOSE=true
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
    shift
done

if [[ -z "$ACTION" ]]; then
    show_help
    exit 1
fi

case "$ACTION" in
    install)
        install_dotfiles
        ;;
    uninstall)
        uninstall_dotfiles
        ;;
    *)
        echo "Error: Unknown action '$ACTION'"
        show_help
        exit 1
        ;;
esac

debug_env
