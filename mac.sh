#!/bin/bash

# Setup VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> ~/.vimrc;

# Setup Bash Profile
echo "
# Begin AdrianTP's Custom Profile Edits
alias cpl='clear;pwd;ls -la'
alias cplg='cpl; git status'
PS1=\u\$"
" >> ~/.bash_profile;

# Install Apple XCode CLI Tools
xcode-select --install;

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

# Install Git and Git-Autocomplete
brew install git && brew install bash-completion;

# Add Git-Autocomplete to Bash Profile
echo "
# Git-Autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
" >> ~/.bash_profile;

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash;

# Install Node
nvm install stable; nvm install iojs; nvm alias default stable;

# Install Grunt and Bower
npm install -g grunt-cli; nam install -g bower;

# Install Sass, Compass, and Susy
sudo gem install sass; sudo gem install compass --pre; sudo gem install susy;

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer;

# Install Homebrew Cask
brew tap caskroom/cask

# Download Arduino
# Download Beyond Compare
# Download Cyberduck
# Download Discord
# Download Fluid
# Download Flux
# Download Google Chrome
# Download iTerm
# Download Macs Fan Control
# Download node-webkit
# Download PhpStorm
# Download Quassel Client
# Download Skype
# Download Slack
# Download Spectacle
# Download sqlitebrowser
# Download The Unarchiver
# Download VirtualBox
# Download XAMPP
brew cask install arduino beyond-compare cyberduck discord fluid flux google-chrome iterm2 macs-fan-control nwjs phpstorm quassel-client skype slack spectacle sqlitebrowser the-unarchiver virtualbox xampp
