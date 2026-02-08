# Janus (Homestation) Setup Status

**Date:** 2026-02-08
**System:** Artix Linux (runit) + Windows 11 Pro (AtlasOS) dual-boot
**Hostname:** janus
**User:** [username]

## ✅ Completed

### Dual-Boot Setup
- [x] Fresh Windows 11 Pro install (300 GB partition)
- [x] Applied AtlasOS playbook
- [x] Disabled Fast Startup, hibernation, BitLocker
- [x] Set hardware clock to UTC (RealTimeIsUniversal registry key)
- [x] Disabled Secure Boot in UEFI
- [x] Installed Artix Linux (runit) with custom partitions:
  - 1 GB ESP (shared with Windows)
  - 120 GB root (/)
  - 8 GB swap
  - ~500 GB home (/home)
- [x] GRUB installed with Windows chainloader
- [x] Vault HDD (1.8 TB NTFS) mounted at `/mnt/vault`

### Base System
- [x] Base Artix packages installed (base, base-devel, runit, elogind-runit, linux, linux-firmware)
- [x] NetworkManager + networkmanager-runit
- [x] User created with wheel group, sudo configured
- [x] Shell set to zsh
- [x] SSH keys generated and added to GitHub
- [x] Git configured

### Display & Window Manager
- [x] Xorg installed (xorg-server, xorg-xinit, xorg-xrandr, xorg-xsetroot)
- [x] X11 libraries (libx11, libxft, libxinerama)
- [x] dwm compiled and installed from ~/Repos/dwm
- [x] dwm autostart array configured (setwp, xcompmgr, dunst, unclutter, redshift, dwmbar)
- [x] dmenu scripts: dmenumount, dmenuumount, dmenupass

### Dotfiles
- [x] Cloned to ~/Repos/dotfiles
- [x] Stowed packages: bin, dunst, fzf, gnupg, mpv, redshift, sioyek, ssh, yazi, zathura, zsh, shell, zprofile, x11, nvim, kitty, tmux, git
- [x] xinitrc, xprofile, xresources configured
- [x] PipeWire configured for janus (xpipewire script)
- [x] Hostname-specific settings applied

### Core Software
- [x] Terminal: Kitty
- [x] Editor: Neovim
- [x] Shell: Zsh (powerlevel10k pending)
- [x] File manager: Yazi
- [x] Browser: Firefox
- [x] Email: Thunderbird
- [x] Passwords: pass
- [x] PDF readers: Zathura
- [x] Video: mpv
- [x] Image editor: GIMP
- [x] E-book manager: Calibre

### CLI Tools (Rust)
- [x] ripgrep (rg)
- [x] fd
- [x] eza
- [x] bat
- [x] zoxide
- [x] tealdeer (tldr)

### Compositor & Utilities
- [x] xcompmgr (compositor)
- [x] dunst (notifications)
- [x] flameshot (screenshots)
- [x] redshift (night mode)

### System Utilities
- [x] fuse3
- [x] ntfs-3g (for Windows/Vault partition access)
- [x] tmux
- [x] wget, curl, unzip

## ⏳ Pending

### Audio
- [ ] PipeWire packages: `sudo pacman -S pipewire pipewire-pulse wireplumber`

### Fonts
- [ ] Nerd Fonts: `sudo pacman -S nerd-fonts` or specific:
  - ttf-cascadia-code-nerd (primary)
  - ttf-firacode-nerd
  - ttf-meslo-nerd
  - ttf-iosevka-nerd

### Shell Enhancements
- [ ] Powerlevel10k: `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k`
- [ ] direnv: `sudo pacman -S direnv`
- [ ] micromamba: Manual install to `~/.local/bin/micromamba` or via pacman

### Package Management
- [ ] artix-archlinux-support: `sudo pacman -S artix-archlinux-support`
- [ ] Edit `/etc/pacman.conf` to add Arch repos (extra, community)
- [ ] yay (AUR helper): `git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`

### CLI Tools (AUR/Arch repos)
- [ ] bottom (btm) - system monitor
- [ ] dust - disk usage
- [ ] procs - process viewer
- [ ] sd - sed replacement
- [ ] just - command runner
- [ ] hyperfine - benchmarking
- [ ] ouch - compression tool

### Applications (AUR/Arch repos/Flatpak)
- [ ] foliate - EPUB reader
- [ ] sioyek - Academic PDF reader (might be in AUR)
- [ ] zotero - Reference manager
- [ ] digikam - Photo management
- [ ] browserpass-firefox - pass browser integration
- [ ] clipmenu - Clipboard manager (already stowed, needs install + daemon)
- [ ] Todoist - Task manager (Flatpak or AUR)
- [ ] Ferdium - Multi-messenger (Flatpak or AUR)
- [ ] Feishin - Music client (Flatpak or AUR)
- [ ] Steam - Gaming
- [ ] RustDesk - Remote desktop

### Configuration Tasks
- [ ] Configure Sioyek as Zotero external PDF reader
- [ ] Configure Sioyek SyncTeX for Quarto/nvim
- [ ] Set up clipmenud (runit service or dwm autostart)
- [ ] Set up Restic + rclone for backups (Google Drive)
- [ ] Set up Atuin shell history sync
- [ ] Test all dwm keybindings (move mode, toggleview mode, layouts)
- [ ] Configure Jellyfin media server (if needed)
- [ ] Import GPG keys for pass

### Windows Side
- [x] Steam installed
- [x] Firefox installed
- [ ] Any other gaming-specific software

## 📋 Notes

### Hostname Setup
- **janus**: Homestation (Artix Linux)
- **noctua**: MacBook Pro (macOS)
- **lettera**: WriterDeck (Raspberry Pi)
- **phebe**, **tango**: Other Linux machines (unknown current status)

### Key Paths
- Dotfiles: `~/Repos/dotfiles`
- dwm source: `~/Repos/dwm`
- Vault (shared HDD): `/mnt/vault`
- Micromamba root: `~/.local/share/micromamba`
- Password store: `~/.local/share/password-store`

### Important Commands
- Stow: `cd ~/Repos/dotfiles && stow -t ~ <package>`
- Compile dwm: `cd ~/Repos/dwm && sudo make clean install`
- Start X: `startx` (auto-runs on tty1 via shell profile)

### Keybinding System
- Linux: Super (Mod4) key via dwm
- macOS: Hyper (Cmd+Ctrl+Alt+Shift via Right Command) → Aerospace
- See: `docs/unified-keybinding-design.md` and `docs/keybindings.txt`

## 🔧 Troubleshooting

### GRUB Doesn't Show Windows
- Windows entry added manually to `/etc/grub.d/40_custom`
- ESP UUID: 31C3-F66C
- If issues, regenerate: `grub-mkconfig -o /boot/grub/grub.cfg`

### Audio Not Working
- Install PipeWire packages
- xpipewire script should auto-run from xprofile for janus hostname

### dwm Keybindings Not Working
- Verify keychord patch applied in dwm source
- Recompile: `cd ~/Repos/dwm && sudo make clean install`
