# Janus Homestation Setup Status

Last updated: 2026-02-08

## System Information

- **Hostname:** Janus
- **OS:** Artix Linux (runit)
- **Kernel:** 6.18.6-artix1-1
- **Desktop:** dwm (custom build)

## Installation Progress

### Core System ✓

- [x] Artix Linux base installation
- [x] dwm window manager (compiled)
- [x] dmenu launcher
- [x] kitty terminal
- [x] neovim editor
- [x] yay AUR helper

### Essential Applications

#### Installed ✓
- [x] Firefox browser
- [x] Thunderbird email/calendar
- [x] Calibre e-book management
- [x] Sioyek PDF reader (academic)
- [x] Foliate EPUB reader
- [x] GIMP image editor
- [x] clipmenu (package installed)
- [x] rclone cloud sync

#### Not Installed Yet
- [ ] Zotero reference manager
- [ ] DigiKam photo management
- [ ] Restic backup tool
- [ ] Atuin shell history sync
- [ ] browserpass-firefox (native host)
- [ ] Jellyfin media server
- [ ] Feishin music client
- [ ] flameshot screenshots
- [ ] xcompmgr compositor
- [ ] dunst notifications
- [ ] redshift night mode

### Configuration Tasks

#### Clipboard Management
- [x] clipmenu package installed
- [ ] clipmenud daemon configured
  - Need to either:
    - Add `clipmenud &` to .xprofile
    - Create runit user service
    - Add to dwm autostart array
- [ ] Test Super+X keybinding

#### Password Management
- [ ] Import GPG keys for pass
- [ ] Initialize password store
- [ ] Install browserpass-firefox native host
- [ ] Test dmenupass integration

#### PDF/Reference Workflow
- [ ] Install Zotero
- [ ] Configure Sioyek as Zotero external PDF reader
- [ ] Set up Sioyek SyncTeX for Quarto/nvim
  - See docs/sioyek-synctex-setup.md

#### Backup Setup
- [ ] Install restic
- [ ] Configure rclone with Google Drive
- [ ] Initialize restic repository
- [ ] Set up backup schedule (runit cron alternative)

#### Shell Configuration
- [ ] Install atuin
- [ ] Register/login to atuin sync
- [ ] Configure shell integration

#### Media Server (Homestation-specific)
- [ ] Install Jellyfin
- [ ] Configure media library paths
- [ ] Install Feishin (Jellyfin frontend)
- [ ] Test access from other devices

#### Window Manager
- [ ] Verify all dwm keybindings work
- [ ] Test move mode (Super+M)
- [ ] Test toggleview mode (Super+C)
- [ ] Configure window rules for applications

#### Display/Desktop
- [ ] Install xcompmgr for transparency
- [ ] Install dunst for notifications
- [ ] Install redshift for night mode
- [ ] Install flameshot for screenshots

### dotfiles Stowing

Track which configurations have been stowed:
- [ ] zsh
- [ ] nvim
- [ ] kitty
- [ ] git
- [ ] tmux
- [ ] dwm config (if separate from build)
- [ ] X11 (.xprofile, .xinitrc)

### Next Steps

Priority tasks to work on:

1. Configure clipmenu daemon (Quick win - already installed)
2. Install and configure password management (GPG + pass + browserpass)
3. Install Zotero for reference management
4. Set up backup solution (restic + rclone)
5. Install remaining GUI applications
6. Configure media server

## Notes

- System is dual-boot with Windows (AtlasOS) - see docs/dual-boot-install.md
- Using runit init system (not systemd)
- For AUR packages: use `yay -S package-name`
- For official repos: use `pacman -S package-name`
