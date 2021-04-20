#!/usr/bin/env bash

# Clone repo
git clone https://github.com/Shourai/DevelopmentServer.git ~/github/DevelopmentServer

# Install packages
sudo add-apt-repository ppa:lazygit-team/release -y
sudo apt update
sudo apt upgrade -y
sudo apt install fzf git neovim python3-pip lazygit -y

# Install Ansible
pip3 install ansible

# Disable news
sudo sed -i 's/ENABLED=1/ENABLED=0/' /etc/default/motd-news

# Add bashrc aliases
echo "alias lg='lazygit'" > ~/.bash_aliases
echo "alias vim='nvim'" >> ~/.bash_aliases

# Add custom bindings to bashrc
sed -i '$ a  source /usr/share/doc/fzf/examples/key-bindings.bash' ~/.bashrc
sed -i '$ a  source /usr/share/doc/fzf/examples/completion.bash' ~/.bashrc
sed -i '$ a  eval "$(lua $HOME/github/z.lua/z.lua --init bash enhanced once echo fzf)"' ~/.bashrc

# Download tmux conf and apply custom settings
curl https://raw.githubusercontent.com/Shourai/dotfiles/master/tmux/tmux.conf -o ~/.tmux.conf
sed -i '$ a set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"' ~/.tmux.conf
sed -i "$ a set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock" ~/.tmux.conf

# Clone z.lua
git clone https://github.com/skywind3000/z.lua.git ~/github/z.lua

# Neovim config
mkdir ~/.config
ln -s ~/github/DevelopmentServer/nvim/ ~/.config/

# SSH config
ln -s ~/github/DevelopmentServer/ssh/rc ~/.ssh/rc

# Add SSH keys
curl https://github.com/shourai.keys > ~/.ssh/authorized_keys

# Disable PasswordAuthentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Setup gpg agent forwarding
sudo sed -i "$ a StreamLocalBindUnlink yes" /etc/ssh/sshd_config
echo "Please import your gpg public key using 'gpg --import [file]'"
