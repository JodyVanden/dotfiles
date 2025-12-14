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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew recipes
echo "update homebrew"
brew update

# Install all our dependencies with bundle (See Brewfile)
echo "install all dependencies from the BrewFile"
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
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
fi
cd "$CURRENT_DIR"


# Update these to the visual studio code path
git config --global core.editor "code -w"
# bundler_editor="code"
# echo "export BUNDLER_EDITOR=\"${bundler_editor}\"" >> zshrc

# Install global NPM packages
echo "NPM Install"
npm install --global yarn

echo "install mise"
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# Ensure python is available (some build scripts need it)
# Add Homebrew's Python to PATH if not already there
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if ! command -v python &> /dev/null && command -v python3 &> /dev/null; then
  # Create a local symlink in a user-writable location
  mkdir -p ~/.local/bin
  PYTHON3_PATH=$(which python3)
  if [ -n "$PYTHON3_PATH" ]; then
    ln -sf "$PYTHON3_PATH" ~/.local/bin/python 2>/dev/null || true
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

zsh<<CONFIG
  # Ensure python is available (some build scripts need it)
  export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
  if ! command -v python &> /dev/null && command -v python3 &> /dev/null; then
    mkdir -p ~/.local/bin
    PYTHON3_PATH=$(which python3)
    if [ -n "$PYTHON3_PATH" ]; then
      ln -sf "$PYTHON3_PATH" ~/.local/bin/python 2>/dev/null || true
    fi
  fi
  
  source ~/.zshrc

  # Install useful plugins (at least for me :D)
  echo "[INFO] Installing mise plugins...";

  mise plugin install ruby
  mise plugin install nodejs
  # mise plugin install packer

  #install differents tools
  mise install ruby@latest
  mise install nodejs@8.14.0
  mise install postgres@10.5
CONFIG

## install vs code
echo "install vscode and extensions"
sh './vscode/install.sh'

echo "👌  Carry on with git setup!"
