backup() {
  target=$1
  if [ -e "$target" ]; then           # Does the config file already exist?
    if [ ! -L "$target" ]; then       # as a pure file?
      mv "$target" "$target.backup"   # Then backup it
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

#!/bin/zsh
for name in *; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    if [[ ! "$name" =~ '\.sh$' ]] && [ "$name" != 'README.md' ]; then
      backup $target

      if [ ! -e "$target" ]; then
        echo "-----> Symlinking your new $target"
        ln -s "$PWD/$name" "$target"
      fi
    fi
  fi
done

REGULAR="\\033[0;39m"
YELLOW="\\033[1;33m"
GREEN="\\033[1;32m"

# zsh plugins
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugin 'zsh-syntax-highlighting'..."
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
fi
cd "$CURRENT_DIR"

setopt nocasematch
if [[ ! `uname` =~ "darwin" ]]; then
  git config --global core.editor "subl -n -w $@ >/dev/null 2>&1"
  echo 'export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1"' >> zshrc
else
  git config --global core.editor "'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' -n -w"
  bundler_editor="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
  echo "export BUNDLER_EDITOR=\"${bundler_editor}\"" >> zshrc
fi

# Sublime Text
if [[ ! `uname` =~ "darwin" ]]; then
  SUBL_PATH=~/.config/sublime-text-3
else
  SUBL_PATH=~/Library/Application\ Support/Sublime\ Text\ 3
fi
mkdir -p $SUBL_PATH/Packages/User $SUBL_PATH/Installed\ Packages
backup "$SUBL_PATH/Packages/User/Preferences.sublime-settings"
curl -k https://sublime.wbond.net/Package%20Control.sublime-package > $SUBL_PATH/Installed\ Packages/Package\ Control.sublime-package
ln -s $PWD/Preferences.sublime-settings $SUBL_PATH/Packages/User/Preferences.sublime-settings
ln -s $PWD/Package\ Control.sublime-settings $SUBL_PATH/Packages/User/Package\ Control.sublime-settings

zsh ~/.zshrc

# Install global NPM packages
npm install --global yarn

installAsdf() {
	# Clone repository
	# echo "[INFO] Cloning asdf repository...";
	# git clone https://github.com/asdf-vm/asdf.git ~/.asdf;

	echo '. $HOME/.asdf/asdf.sh' >> ~/.zshrc
	echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
	source ~/.zshrc

	# Install useful plugins (at least for me :D)
	echo "[INFO] Installing asdf plugins...";
	source $HOME/.asdf/asdf.sh;

	asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git;
	asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git;
	asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git;
  asdf plugin-add elm
  asdf plugin-add java
  asdf plugin-add maven
  asdf plugin-add mongodb
  asdf plugin-add nodejs
  asdf plugin-add postgres
	bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring;
	# asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git;
	# asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git;
	# asdf plugin-add packer https://github.com/Banno/asdf-hashicorp.git;

  #install differents tools
  asdf install ruby 2.6.2
  asdf install ruby 2.5.1
  asdf install maven 3.6.0
  asdf install mongodb 3.4.15
  asdf install nodejs 8.14.0
  asdf install postgres 10.5
}

doIt() {
	installAsdf;
}

echo "👌  Carry on with git setup!"
