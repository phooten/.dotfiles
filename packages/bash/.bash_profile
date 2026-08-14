###############################################################################
# .bash_profile templat
###############################################################################

# This came from: 
#   https://treehouse.github.io/installation-guides/mac/homebrew
#   running: 
#       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#       echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/phoot/.bash_profile
#       echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/phoot/.bash_profile
#       eval "$(/opt/homebrew/bin/brew shellenv)"
# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"


if [ -f ~/.bashrc ]; then 
        . ~/.bashrc; 
fi 

