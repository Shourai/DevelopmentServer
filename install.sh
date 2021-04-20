#!/usr/bin/env bash

# Clone repo
git clone https://github.com/Shourai/DevelopmentServer.git ~/github/DevelopmentServer
git -C ~/github/DevelopmentServer remote set-url origin git@github.com:shourai/DevelopmentServer.git
git -C ~/github/DevelopmentServer config user.name "Shourai"
git -C ~/github/DevelopmentServer config user.email "10200748+Shourai@users.noreply.github.com"

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
grep -q "source /usr/share/doc/fzf/examples/key-bindings.bash" ~/.bashrc || sed -i '$ a  source /usr/share/doc/fzf/examples/key-bindings.bash' ~/.bashrc
grep -q "source /usr/share/doc/fzf/examples/completion.bash" ~/.bashrc || sed -i '$ a  source /usr/share/doc/fzf/examples/completion.bash' ~/.bashrc
grep -q 'eval "$(lua $HOME/github/z.lua/z.lua --init bash enhanced once echo fzf)"' ~/.bashrc || sed -i '$ a  eval "$(lua $HOME/github/z.lua/z.lua --init bash enhanced once echo fzf)"' ~/.bashrc

# Download tmux conf and apply custom settings
curl https://raw.githubusercontent.com/Shourai/dotfiles/master/tmux/tmux.conf -o ~/.tmux.conf
sed -i '$ a set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"' ~/.tmux.conf
sed -i "$ a set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock" ~/.tmux.conf

# Clone z.lua
git clone https://github.com/skywind3000/z.lua.git ~/github/z.lua

# Neovim config
mkdir ~/.config
ln -sf ~/github/DevelopmentServer/nvim/ ~/.config/

# SSH config
ln -sf ~/github/DevelopmentServer/ssh/rc ~/.ssh/rc

# Add SSH keys
curl https://github.com/shourai.keys > ~/.ssh/authorized_keys

# Disable PasswordAuthentication
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Setup gpg agent forwarding
grep -q "StreamLocalBindUnlink yes" /etc/ssh/sshd_config || sudo sed -i "$ a StreamLocalBindUnlink yes" /etc/ssh/sshd_config

# Print info
echo -e "Setup complete\n"
echo -e "
For GPG forwarding to work: 
import your gpg public key using \e[32m'gpg --import [file]'\e[0m
"

echo -e "
For quick access:
put the following in your \e[32m~/.ssh/config\e[0m file

Host <host>
    HostName $(ip -f inet address | awk '/inet / { print $2 }' | tail -n 1 | cut -d / -f 1)
    User $(whoami)
    ForwardAgent yes
    ForwardX11 yes
    ForwardX11Trusted yes
    RemoteForward $(gpgconf --list-dir agent-socket) /Users/<local user>/.gnupg/S.gpg-agent.extra
"

