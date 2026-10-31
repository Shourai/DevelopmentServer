#!/usr/bin/env bash
# Set up my development VM (Ubuntu Server on Proxmox, used over SSH), or update it:
# my dotfiles, then what only this VM needs. Stops at the first error: fix it, run it
# again. See README.md.
#
#   curl -fsSL https://raw.githubusercontent.com/Shourai/DevelopmentServer/master/install.sh | bash

set -euo pipefail

# In a function, so curl | bash reads the whole script before running it
main() {
  # My dotfiles: packages, configs, zsh; also installs git and Homebrew
  curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash

  # This repo, next to the dotfiles (their git config sets my name and email)
  repo=~/Documents/github/DevelopmentServer
  if [ ! -d "$repo" ]; then
    git clone https://github.com/Shourai/DevelopmentServer.git "$repo"
    git -C "$repo" remote set-url origin git@github.com:Shourai/DevelopmentServer.git
  fi

  # Proxmox guest agent (DEBIAN_FRONTEND: no prompts during apt)
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-guest-agent

  # Docker CE, with Docker's own script (sets up Docker's apt repo; apt upgrades it)
  if ! command -v docker >/dev/null; then
    curl -fsSL https://get.docker.com | sh
  fi
  sudo usermod -aG docker "$USER"

  # No Canonical news in the login banner
  sudo sed -i 's/^ENABLED=1/ENABLED=0/' /etc/default/motd-news

  echo "Done. Log out and back in (zsh, docker group)."
}

main
