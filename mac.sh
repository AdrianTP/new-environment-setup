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
cat ~/.bash_profile ./bash_profile;

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

# Install CLI tools via Homebrew
brew install\
  autoconf automake bash bash-completion cmake coreutils cscope dirmngr \
  exercism ffmpeg findutils flac gawk gdbm gettext git gmp gnu-getopt \
  gnu-indent gnu-sed gnu-tar gnupg gnupg2 gnutls gpg-agent grep id3lib \
  id3v2 itermocil jemalloc lame libao libassuan libevent libffi libgcrypt \
  libgpg-error libksba libogg libpng libtasn1 libtermkey libtool libusb \
  libusb-compat libuv libvorbis libvterm libyaml macvim mad mpfr msgpack \
  neovim nettle openssl pcre perl phantomjs pinentry pkg-config postgresql pth \
  python qt55 qt@5.5 readline redis rename ruby ruby-install sox sqlite tig \
  tmux unibilium vim vorbis-tools x264 xvid

# Install Homebrew Cask
brew tap caskroom/cask

brew cask install \
  arduino atom bettertouchtool beyond-compare cyberduck discord electron fluid \
  flux gimp gog-galaxy google-chrome inkscape iterm2 logitech-options macdown \
  macs-fan-control nwjs origin phpstorm quassel-client skype slack spectacle \
  sqlitebrowser steam sublime-text teamviewer the-unarchiver vimr virtualbox \
  vlc xampp xquartz

# Fix ctrl-h for navigation mapping in neovim
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti

mkdir -p ~/.config/nvim
cp ./neovim.vim ~/.config/nvim/init.vim
