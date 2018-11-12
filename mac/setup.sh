#!/bin/bash

# Include utils
# From: https://stackoverflow.com/a/12694189/771948
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/utils/readarray.sh"

# Setup VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> "$HOME/.vimrc";

# Setup Bash Profile
cat profile aliases >> "$HOME/.bash_profile";

# Install Apple XCode CLI Tools
xcode-select --install;

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

# Install Git and Git-Autocomplete
brew install git && brew install bash-completion;

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash;

# Install Node
nvm install stable; nvm install iojs; nvm alias default stable;

# Install Grunt and Bower
npm install -g grunt-cli; npm install -g bower;

# Install Sass, Compass, and Susy
sudo gem install sass; sudo gem install compass --pre; sudo gem install susy;

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer;

# Install CLI tools via Homebrew
readarray "brew_array" "pkg_brew.txt"
brew install ${brew_array[@]}

# Install Homebrew Cask
brew tap caskroom/cask

# Install GUI tools via Homebrew Cask
readarray "brew_cask_array" "pkg_brew_cask.txt"
brew cask install ${brew_cask_array[@]}

# Fix ctrl-h for navigation mapping in neovim
# https://github.com/christoomey/vim-tmux-navigator/issues/71
OLDDIR=$PWD
cd $HOME
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
cd $OLDDIR

mkdir -p "$HOME/.config/nvim"
cp ../common/neovim.vim "$HOME/.config/nvim/init.vim"

ln -s ./utils/pdiff.sh /usr/local/bin/pdiff
ln -s ./utils/dockspace.sh /usr/local/bin/dockspace
ln -s ./utils/serve.sh /usr/local/serve
ln -s ./utils/title.sh /usr/local/title
ln -s ./utils/stfu.sh /usr/local/stfu

source "$HOME/.bash_profile"
