# Software Setup Guide

Reference for setting up machines after formatting.

## Cross-Platform Software

| Category | App | Linux (Artix) | macOS | Notes |
|----------|-----|---------------|-------|-------|
| **Terminal** | Kitty | `pacman -S kitty` | `brew install --cask kitty` | Wezterm on Windows |
| **Editor** | Neovim | `pacman -S neovim` | `brew install neovim` | |
| **Shell** | Zsh + p10k | `pacman -S zsh` | included | + zsh-syntax-highlighting |
| **File Manager** | Yazi | `pacman -S yazi` | `brew install yazi` | |
| **Browser** | Firefox | `pacman -S firefox` | `brew install --cask firefox` | + browserpass extension |
| **Email/Calendar** | Thunderbird | `pacman -S thunderbird` | `brew install --cask thunderbird` | |
| **Tasks** | Todoist | Flatpak or AUR | `brew install --cask todoist` | |
| **Chat** | Ferdium | Flatpak or AUR | `brew install --cask ferdium` | WhatsApp, Telegram, Signal, Slack, Discord |
| **References** | Zotero | `pacman -S zotero` | `brew install --cask zotero` | + Better BibTeX |
| **E-books** | Calibre | `pacman -S calibre` | `brew install --cask calibre` | E-book mgmt + reader |
| **EPUB Reader** | Foliate | `pacman -S foliate` | Books.app (built-in) | Linux: dedicated reader; macOS: use Books or Calibre |
| **PDF Reader** | Sioyek | AUR | `brew install --cask sioyek` | Academic PDFs, SyncTeX |
| **PDF Simple** | Zathura | `pacman -S zathura` | `brew install zathura` | Vim-like, fast |
| **Photo Mgmt** | DigiKam | `pacman -S digikam` | `brew install --cask digikam` | |
| **Photo Edit** | ART | AUR (rawtherapee fork) | build from source | |
| **Image Edit** | GIMP | `pacman -S gimp` | `brew install --cask gimp` | |
| **Video** | mpv | `pacman -S mpv` | `brew install mpv` | |
| **Gaming** | Steam | `pacman -S steam` | `brew install --cask steam` | |
| **Passwords** | pass | `pacman -S pass` | `brew install pass` | + browserpass, dmenupass |
| **Remote Desktop** | RustDesk | AUR: `rustdesk-bin` | `brew install --cask rustdesk` | Access homestation remotely |

## Linux-Only (Homestation)

| Category | App | Install | Notes |
|----------|-----|---------|-------|
| **WM** | dwm | build from source | ~/Developer/dwm |
| **Launcher** | dmenu | `pacman -S dmenu` | + dmenupass, dmenumount |
| **Clipboard** | clipmenu | AUR | Super+X |
| **Screenshots** | flameshot | `pacman -S flameshot` | |
| **Media Server** | Jellyfin | `pacman -S jellyfin` | Access from Fire TV, other devices |
| **Music Client** | Feishin | Flatpak or AUR | Jellyfin frontend |
| **Compositor** | xcompmgr | `pacman -S xcompmgr` | For transparency |
| **Notifications** | dunst | `pacman -S dunst` | |
| **Redshift** | redshift | `pacman -S redshift` | Night mode |

## macOS-Only

| Category | App | Install | Notes |
|----------|-----|---------|-------|
| **WM** | Aerospace | `brew install --cask aerospace` | Tiling WM |
| **Launcher** | Raycast | `brew install --cask raycast` | Spotlight replacement |
| **Key Remap** | Karabiner | `brew install --cask karabiner-elements` | Right Cmd → Hyper |
| **PDF Signatures** | Preview | included | For signing documents |

## CLI Tools (Rust-based)

| Tool | Replaces | Install (both) | Command |
|------|----------|----------------|---------|
| ripgrep | grep | `pacman/brew install ripgrep` | `rg` |
| fd | find | `pacman/brew install fd` | `fd` |
| eza | ls | `pacman/brew install eza` | `eza` |
| bat | cat | `pacman/brew install bat` | `bat` |
| bottom | htop | `pacman/brew install bottom` | `btm` |
| zoxide | cd | `pacman/brew install zoxide` | `z` |
| atuin | history | `pacman/brew install atuin` | synced history |
| dust | du | `pacman/brew install dust` | `dust` |
| procs | ps | `pacman/brew install procs` | `procs` |
| sd | sed | `pacman/brew install sd` | `sd` |
| tealdeer | man | `pacman/brew install tealdeer` | `tldr` |
| gitui | — | `pacman/brew install gitui` | git TUI |
| just | make | `pacman/brew install just` | `just` |
| hyperfine | time | `pacman/brew install hyperfine` | benchmarking |
| ouch | tar/zip | `pacman/brew install ouch` | compression |

## Backup Strategy

**Tool:** Restic + rclone

| Machine | What to backup | Where |
|---------|---------------|-------|
| Homestation | ~/Documents, ~/Projects, ~/Photos, ~/.password-store | External HDD + Cloud |
| MacBook | ~/Documents, ~/Projects, ~/.password-store | SSH to homestation or Cloud |

### Cloud Storage Options

| Service | Space | Cost | Notes |
|---------|-------|------|-------|
| Google One | 2TB | Already paid (until Nov) | Use via rclone |
| Backblaze B2 | Pay per use | $5/TB/month | Native Restic support |
| Dropbox | 13GB | Free | Too small for backups, file sync only |

### Local Backup (External HDD)

```bash
# Install
pacman -S restic  # or brew install restic

# Init repo on external drive
restic -r /mnt/backup/repo init

# Backup
restic -r /mnt/backup/repo backup ~/Documents ~/Projects

# Restore
restic -r /mnt/backup/repo restore latest --target ~/restore
```

### Cloud Backup via Google Drive (rclone)

```bash
# Configure rclone with Google Drive
rclone config
# Choose: n (new remote)
# Name: gdrive
# Type: drive (Google Drive)
# Follow OAuth prompts

# Test connection
rclone ls gdrive:

# Init Restic repo on Google Drive
restic -r rclone:gdrive:backups/restic-repo init

# Backup to Google Drive
restic -r rclone:gdrive:backups/restic-repo backup ~/Documents ~/Projects

# List snapshots
restic -r rclone:gdrive:backups/restic-repo snapshots
```

### Backblaze B2 (Alternative after Google One expires)

```bash
# Configure rclone with B2
rclone config
# Choose: n → name: b2 → type: b2 → enter API keys

# Or use Restic native B2 support
export B2_ACCOUNT_ID="your-account-id"
export B2_ACCOUNT_KEY="your-account-key"
restic -r b2:bucket-name:restic-repo init
```

### Future Task: Consolidate Cloud Storage

Files currently scattered across:
- Google Drive (2TB until Nov)
- Dropbox (13GB)
- Local machines

TODO: Audit and consolidate using rclone + Syncthing.

## dwm Tags & Window Rules

| Tag | Icon | Apps |
|-----|------|------|
| 1 |  | kitty, tmux |
| 2 |  | Yazi |
| 3 |  | Todoist, Thunderbird |
| 4 | 﫦 | Zotero, Calibre, Sioyek, LibreOffice |
| 5 |  | Zoom, Teams, Slack, Telegram, Signal, Discord, Ferdium |
| 6 |  | GIMP, ART, Rawtherapee, DigiKam |
| 7 | 󰑈 | mpv, Jellyfin Media Player |
| 8 |  | Feishin |
| 9 | 󰖟 | Firefox |

## Keybinding System

- **Linux:** Super (Mod4) via dwm
- **macOS:** Hyper (Cmd+Ctrl+Alt+Shift) via Karabiner → Aerospace
- **Physical key:** Right Cmd/Super on all keyboards

See: `docs/unified-keybinding-design.md`

## Post-Install Tasks

- [ ] Set up Syncthing between machines
- [ ] Configure Restic backup schedule
- [ ] Import GPG keys for pass
- [ ] Set Sioyek as Zotero external PDF reader
- [ ] Configure Sioyek SyncTeX for Quarto/nvim
- [ ] Install browserpass Firefox extension
- [ ] Set up Jellyfin media library
- [ ] Configure Atuin sync (if using)

## Artix-Specific Notes

- **No systemd** - use runit/OpenRC/s6
- **No Snap** - use Flatpak or AUR instead
- **AUR helper:** `yay` or `paru`

```bash
# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```
