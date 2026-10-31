# DevelopmentServer

Sets up my development VM: a headless Ubuntu Server on Proxmox that I use over SSH.
`install.sh` runs my [dotfiles](https://github.com/Shourai/dotfiles)' install and then adds what
only this VM needs. Run it again to update.

## Before you run it

1. **Proxmox**: create the VM and turn on Options, QEMU Guest Agent.
2. **Install Ubuntu Server** from the ISO (<https://ubuntu.com/download/server>): the latest LTS,
   or a newer non-LTS release. In the installer:
   - pick **Ubuntu Server** (not the minimized variant);
   - create your own user (it gets `sudo`);
   - tick **Install OpenSSH server** and import your SSH key from GitHub;
   - leave the featured snaps unticked, `docker` in particular: Docker comes from Docker's own
     apt repo (see below).
3. Log in over SSH with agent forwarding (`ssh -A`, or `ForwardAgent yes`), so git can push to
   GitHub with your workstation's key. No keys live on the VM.

## Install or update

```sh
curl -fsSL https://raw.githubusercontent.com/Shourai/DevelopmentServer/master/install.sh | bash
~/Documents/github/DevelopmentServer/install.sh   # later runs
```

Run it as your own user, not as root; it asks for your sudo password. It stops at the first error,
with that error last on screen: fix it and run the script again (safe to rerun). Log out and back
in afterwards (login shell zsh, docker group).

| Step | What |
|------|------|
| dotfiles | the dotfiles' `install`: apt and Homebrew packages, configs, zsh as login shell, nvim config. On a machine without a desktop it skips the desktop parts (see the dotfiles' [Ubuntu README](https://github.com/Shourai/dotfiles/blob/main/ubuntu/README.md)). |
| this repo | cloned to `~/Documents/github/DevelopmentServer` if it isn't there yet, next to the dotfiles (whose git config sets my name and email there); pushes over SSH. Later: `git pull` it yourself |
| `qemu-guest-agent` | Proxmox shows the VM's IP, shuts it down cleanly and freezes the filesystem for backups |
| Docker CE | installed once with Docker's own script (<https://get.docker.com>), which sets up Docker's apt repo, so apt upgrades it from then on; your user in the `docker` group (as good as root on the VM) |
| motd-news | turned off (no Canonical news in the login banner) |

Everything else (Python with `uv`, node/npm, tmux, nvim, lazygit, ...) comes from the dotfiles.

Not installed, add by hand on a VM that needs it: opentofu (`brew install opentofu`; the
dotfiles' install upgrades it from then on, like the other formulae).

## Connect

In `~/.ssh/config` on your workstation (the IP is on the VM's Summary page in Proxmox):

```
Host devvm
    HostName <IP of the VM>
    User <your user>
    ForwardAgent yes
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Docker's script fails on `apt-get update` (a 404 for `download.docker.com`), and from then on every `apt update` fails | a new release (mostly non-LTS) that Docker doesn't support yet. `sudo rm /etc/apt/sources.list.d/docker.list`, comment out the Docker lines in `install.sh` and rerun; put them back in a few weeks |
| `docker: permission denied` | log out and back in (the `docker` group applies from the next login) |
| Proxmox shows no IP for the VM | turn on Options, QEMU Guest Agent, then shut the VM down and start it again from Proxmox (the option takes effect on a fresh start) |
| `git push`: permission denied (publickey) | connect with agent forwarding (`ssh -A`) and check `ssh-add -L` on the VM |
| It stops in the dotfiles part ("finished with errors in: ...") | see the dotfiles' [Troubleshooting](https://github.com/Shourai/dotfiles#troubleshooting); rerun when fixed (the VM steps after it run only then) |

## Testing changes

Test in a Docker container, not on a real machine: a non-root user with `sudo`, and
`apt-get install ubuntu-server` to come close to the ISO install. Services (Docker,
qemu-guest-agent) don't start in a container; check those on a VM. Keep `install.sh`
shellcheck-clean.
