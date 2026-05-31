#!/usr/bin/env zsh

# Default environment configurations
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="ansible,bash,bin,ssh,tmux,vim"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/code/.dotfiles
fi

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

case "$1" in
    -i|--install)
        pushd "$DOTFILES"
        for folder in $(echo "$STOW_FOLDERS" | sed "s/,/ /g")
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
        for folder in $(echo "$STOW_FOLDERS" | sed "s/,/ /g")
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

# #!/usr/bin/env zsh
# 
# if [[ -z $STOW_FOLDERS ]]; then
#     STOW_FOLDERS="ansible,bash,bin,ssh,tmux,vim"
# fi
# 
# if [[ -z $DOTFILES ]]; then
#     DOTFILES=$HOME/code/.dotfiles
# fi
# 
# pushd $DOTFILES
# for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
# do
#     echo "stow $folder"
#     stow -D $folder
#     stow $folder
# done
# popd
# 
# 
