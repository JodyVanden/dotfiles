#!/bin/bash
echo "Installing VSCode"
# _install code

while read EXTENSION
do
    echo "Install VSCode Extension: $EXTENSION"
    code --install-extension $EXTENSION
done < ./vs_code_extensions_list.txt

# ln -sf $HOME/.dotfiles/vscode/settings.json $HOME/.config/Code\ -\ OSS/User/settings.json
# ln -sf $HOME/.dotfiles/vscode/keybindings.json $HOME/.config/Code\ -\ OSS/User/keybindings.json
