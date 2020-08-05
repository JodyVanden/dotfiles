#!/bin/bash
set -eo pipefail

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
echo "Check for Homebrew and install if we don't have it"
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
echo "update homebrew"
brew update

# Install all our dependencies with bundle (See Brewfile)
echo "install all dependencies from the BrewFile"
brew tap homebrew/bundle
brew bundle
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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


# Update these to the visual studio code path
git config --global core.editor "code -w"
# bundler_editor="code"
# echo "export BUNDLER_EDITOR=\"${bundler_editor}\"" >> zshrc

# Install global NPM packages
echo "NPM Install"
npm install --global yarn

echo "install ASDF"
echo 'source /usr/local/opt/asdf/asdf.sh' >> ~/.zshrc
echo '. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash' >> ~/.zshrc

zsh<<CONFIG
  source ~/.zshrc

  # Install useful plugins (at least for me :D)
  echo "[INFO] Installing asdf plugins...";

  asdf plugin-add ruby
  asdf plugin-add nodejs
  asdf plugin-add elixir
  asdf plugin-add elm
  asdf plugin-add java
  asdf plugin-add maven
  asdf plugin-add nodejs
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring;
  # asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git;
  # asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git;
  # asdf plugin-add packer https://github.com/Banno/asdf-hashicorp.git;

  #install differents tools
  asdf install ruby 2.6.2
  # asdf install ruby 2.5.1
  asdf install maven 3.6.0
  #asdf install mongodb 3.4.15
  asdf install nodejs 8.14.0
  asdf install postgres 10.5
  asdf install elixir 1.8.2
CONFIG

## install vs code
echo "install vscode and extensions"
sh './vscode/install.sh'

echo "👌  Carry on with git setup!"
