#/bin/bash

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

git config --add oh-my-zsh.hide-status 1
git config --add oh-my-zsh.hide-dirty 1

git config --global oh-my-zsh.hide-status 1 
git config --global oh-my-zsh.hide-dirty 1


# plugins=(
#     zsh-syntax-highlighting
#     zsh-autosuggestions
#     git
#     autojump
#     extract
#     vi-mode
#     rsync
#     sudo
# )