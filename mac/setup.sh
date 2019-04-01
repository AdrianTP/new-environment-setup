#!/usr/bin/env bash

# Install Apple XCode CLI Tools
xcode-select --install;

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

# Install Homebrew Packages
brew bundle

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

ln -s ./utils/pdiff.sh /usr/local/bin/pdiff
ln -s ./utils/dockspace.sh /usr/local/bin/dockspace
ln -s ./utils/serve.sh /usr/local/bin/serve
ln -s ./utils/title.sh /usr/local/bin/title
ln -s ./utils/stfu.sh /usr/local/bin/stfu
