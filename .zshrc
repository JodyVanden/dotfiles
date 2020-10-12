ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one:
#   https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful plugins for Rails development with Sublime Text
plugins=(
    git
    gitfast
    brew
    last-working-dir
    common-aliases
    zsh-syntax-highlighting
    gradle-completion
    terraform
    node
    npm
    docker)

# Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
export PATH="./bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="$(which code)"

export PROMPT_COMMAND=prompt_command

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# mysql alias
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
# source /usr/local/opt/asdf/asdf.sh
. $HOME/.asdf/asdf.sh

# setup intellij terminal
POWERLEVEL9K_MODE="awesome-fontconfig"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status ram load time)

export HOST_IP=`ifconfig | grep 'inet .*br' | sed -E 's/.*inet (.*) netmask.*/\1/'`