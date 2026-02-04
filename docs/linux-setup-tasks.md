# Deferred Setup Tasks

Tasks to complete after setting up machines / installing software.

## dwm/dmenu

- [x] Move mount/unmount to move mode
  - `Super + M`, then `M` = dmenumount
  - `Super + M`, then `U` = dmenuumount
  - Scripts already in `bin/.local/bin/`

- [ ] Set up clipmenu for Linux clipboard history
  - Install: `pacman -S clipmenu`
  - Bound to `Super + X` in dwm config
  - Start daemon via one of:
    - `.xprofile`: add `clipmenud &`
    - runit user service (see docs)
    - dwm autostart array

## Raycast Hotkeys (macOS)

- [ ] Set up Raycast hotkeys as documented in `docs/raycast-hotkeys.md`

## Application Configuration (either platform)

- [ ] Configure Sioyek as Zotero external PDF reader
  - Install: `brew install --cask sioyek` (Mac) / `pacman -S sioyek` (Linux)
  - Zotero → Preferences → General → Open PDFs with: Sioyek

- [ ] Configure Sioyek SyncTeX for Quarto/nvim workflow
  - Enable inverse search in Sioyek config
  - Set up nvim as editor for SyncTeX jumps
  - Test with a Quarto document

- [ ] Set up Restic + rclone for backups
  - Install: `brew install restic rclone` / `pacman -S restic rclone`
  - Configure rclone with Google Drive
  - Init restic repo
  - See `docs/software-setup.md` for commands

- [ ] Set up Atuin shell history sync
  - Install: `brew install atuin` / `pacman -S atuin`
  - Run `atuin register` or `atuin login`
  - Add to shell config

- [ ] Install browserpass Firefox extension
  - Install extension from Firefox Add-ons: https://addons.mozilla.org/en-US/firefox/addon/browserpass-ce/
  - macOS native host: ✅ installed via `brew install amar1729/formulae/browserpass`
  - Linux native host: `pacman -S browserpass-firefox`

## Post-Install Verification (Linux)

- [ ] Compile and test dwm with keychord patch
- [ ] Verify all keybindings work as expected
- [ ] Test move mode (Super+M, then keys)
- [ ] Test toggleview mode (Super+C, then keys)
