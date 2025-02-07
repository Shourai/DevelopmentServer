#!/usr/bin/env bash

# Install git
sudo apt install git

# Clone repo
git clone https://github.com/Shourai/DevelopmentServer.git ~/github/DevelopmentServer
git -C ~/github/DevelopmentServer remote set-url origin git@github.com:shourai/DevelopmentServer.git
git -C ~/github/DevelopmentServer config user.name "Shourai"
git -C ~/github/DevelopmentServer config user.email "10200748+Shourai@users.noreply.github.com"

# Create local bin directory
mkdir -p ~/.local/bin

# Install packages
sudo apt update
sudo apt upgrade -y
sudo apt install tmux python3-pip python3-venv npm unzip -y

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install neovim
curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar -xzf - -C $HOME
ln -fs $HOME/nvim-linux64/bin/nvim ~/.local/bin/

# Install lazygit
MY_FLAVOR=Linux_x86_64
curl -s -L $(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
	grep browser_download_url |
	cut -d '"' -f 4 |
	grep -i "$MY_FLAVOR") |
	tar xzf - -C ~/.local/bin/ lazygit

# Add path to bashrc
STRING="export PATH=\"\$PATH:~/.local/bin\""
FILE="$HOME/.bashrc"
if  grep -q "$STRING" "$FILE" ; then
         echo 'the string exists' ;
else
         echo 'Added $STRING to bashrc' ;
         echo $STRING >> $FILE ;
fi

# Disable news
if [ -f /etc/default/motd-news ]; then
  sudo sed -i 's/ENABLED=1/ENABLED=0/' /etc/default/motd-news
fi

# Add bashrc aliases
echo "alias lg='lazygit'" > ~/.bash_aliases
echo "alias vim='nvim'" >> ~/.bash_aliases

# Check if eval "$(zoxide init bash)" is already in .bashrc
if ! grep -Fxq 'eval "$(zoxide init bash)"' ~/.bashrc
then
    # Use sed to append the line to the end of .bashrc
    sed -i -e '$a eval "$(zoxide init bash)"' ~/.bashrc
    echo "zoxide initialization added to .bashrc"
else
    echo "zoxide initialization already present in .bashrc"
fi

# Download tmux conf and apply custom settings
curl https://raw.githubusercontent.com/Shourai/dotfiles/master/tmux/tmux.conf -o ~/.tmux.conf

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Neovim config
mkdir ~/.config
git clone https://github.com/Shourai/nvim.git ~/.config/nvim

# Print info
echo -e "Setup complete\n"

echo -e "
For quick access:
put the following in your \e[32m~/.ssh/config\e[0m file

Host <host>
    HostName $(ip -f inet address | awk '/inet / { print $2 }' | tail -n 1 | cut -d / -f 1)
    User $(whoami)
    ForwardAgent yes
    ForwardX11 yes
    ForwardX11Trusted yes
"

