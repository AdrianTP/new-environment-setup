#!/data/data/com.termux/files/usr/bin/sh

# Install Termux dependencies
packages install termux-tools neovim git openssh coreutils
#packages intall nodejs ruby php

# Setup VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> ~/.vimrc;

# Setup Bash Profile
profile="~/.bash_profile"

if [[ ! -f $profile ]]; then
  touch $profile
fi

cat $profile ./profile_termux alias_termux;

# Install Grunt and Bower
#npm install -g grunt-cli; npm install -g bower;

# Install Sass, Compass, and Susy
#sudo gem install sass; sudo gem install compass --pre; sudo gem install susy;

# Install Composer
#curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer;

# Fix ctrl-h for navigation mapping in neovim
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti

mkdir -p ~/.config/nvim
cp ./neovim.vim ~/.config/nvim/init.vim
