# Office iMac Setup (hestia)

Runbook for bringing up the work iMac from this repo. Assumes a fresh macOS
install and that you are *not* migrating from a Time Machine backup.

janus and hestia are both on Tailscale, so every migration step below is either
a `git clone` or an `scp` — nothing needs a USB stick.

Companion files:

- `Brewfile.work` — the package set for this machine
- `docs/software-setup.md` — cross-platform app decisions
- `docs/unified-keybinding-design.md` — why the Hyper key is wired the way it is
- `docs/raycast-hotkeys.md` — Raycast hotkeys to configure by hand
- `docs/sioyek-synctex-setup.md` — SyncTeX wiring for Quarto/LaTeX

---

## 0. Prerequisites

You have admin rights on this machine, so nothing here is gated on IT. Two
grants still need a trip through System Settings later (§7), and the Karabiner
driver extension needs a reboot:

| Grant | Needed by | Where |
|-------|-----------|-------|
| Driver system extension | Karabiner-Elements | Privacy & Security (reboot) |
| Input Monitoring | Karabiner-Elements | Privacy & Security |
| Accessibility | Aerospace | Privacy & Security |

## What comes from where

| Thing | How it gets to hestia |
|-------|-----------------------|
| dotfiles | `git clone` (§3) |
| password store | `git clone` of `Pass-Store` (§9) |
| wiki (`~/Documents/wiki`) | `git clone git@github.com:soffiafdz/wiki.git ~/Documents/wiki` |
| GPG secret key + ownertrust | export on janus, `scp` over Tailscale (§9) |
| machine-local git excludes | `scp` from janus (§7) |
| shell history | optional `scp`, or let atuin carry it |
| everything else | reinstalled by `Brewfile.work` — nothing to migrate |

Zotero, Zen and Thunderbird each sync through their own accounts; don't copy
their profile directories.

## 1. Xcode Command Line Tools

```sh
xcode-select --install
```

Needed for Homebrew and for nvim-treesitter to compile parsers.

## 2. Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then, for this shell only (`shell/profile` handles it from the next login on,
on both Apple Silicon and Intel):

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"   # /usr/local/bin/brew on Intel
```

**Do not run the `>> ~/.zprofile` snippet the installer prints at the end.** It
would create a real `~/.zprofile`, and `stow zprofile` then refuses to place the
repo's copy over it ("existing target is not a symlink"). `shell/profile` already
runs `brew shellenv` on both prefixes. If you ran it already, `rm ~/.zprofile`
before stowing.

## 3. SSH key, then clone

Generate a *new* key for this machine rather than copying your personal one —
you want to be able to revoke it independently when you leave.

```sh
ssh-keygen -t ed25519 -C "imac-work"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub    # paste into GitHub → Settings → SSH keys
```

```sh
mkdir -p ~/Developer
git clone git@github.com:soffiafdz/dotfiles.git ~/Developer/dotfiles
```

`~/Developer/dotfiles` is the path the Brewfiles assume (the Linux boxes use
`~/Repos/dotfiles`).

## 4. Packages

```sh
brew bundle --file=~/Developer/dotfiles/Brewfile.work
```

`Brewfile.work` is the main `Brewfile` minus the personal/media apps, plus three
dependencies the configs need that the original list was missing: `visidata`
(R.nvim opens data frames with `vd`), `sd`, and `pipx` (for radian).

**If you already installed kitty by hand**, `brew bundle` will fail on
`cask "kitty"` because an app is already at `/Applications/kitty.app`. Move the
manual copy to the Trash first and let Homebrew own it — that way `brewup`
updates it with everything else. (`brew install --cask kitty --adopt` takes over
the existing app instead, if you'd rather not re-download.)

Read the commented-out block at the bottom before running it — it holds the
decisions about personal data on an employer-owned machine (§11).

## 5. Stow the configs

**Stow karabiner before launching Karabiner-Elements for the first time.**
Karabiner writes a default `karabiner.json` on first run, which then collides
with the one in this repo.

```sh
cd ~/Developer/dotfiles

# -t "$HOME" is required: stow defaults to the parent dir, which here
# would be ~/Developer, not ~
stow -nv -t "$HOME" kitty aerospace karabiner zsh zprofile shell fzf \
  git ssh tmux nvim yazi sioyek radian mpv atuin bin     # dry run
stow -v -t "$HOME" kitty aerospace karabiner zsh zprofile shell fzf \
  git ssh tmux nvim yazi sioyek radian mpv atuin bin
```

Deliberately not stowed on macOS:

| Package | Why |
|---------|-----|
| `x11`, `picom`, `dunst`, `redshift`, `foot`, `mimeapps` | X11/Wayland only |
| `mpd`, `ncmpcpp`, `castero`, `jellyfin` | Personal media stack |
| `nvim_micro`, `vim` | Alternate editor configs |
| `gnupg` | See §9 — only tracked file is a Linux-specific `gpg-agent.conf` |
| `bpytop`, `zathura` | Harmless, but the tools aren't in `Brewfile.work` |

`bin` is worth stowing for `init_tmux` and `pinentry-auto`, even though most of
the scripts in it are dwm/X11 helpers that will never run here.

Stow folds whole directories into a single symlink, so `~/.config/kitty` becomes
a link to the repo. Anything you drop in that directory lands *inside the repo* —
which is why `local.conf` and `config.local` are gitignored (§6, §8).

## 6. Shell

The chain is `~/.zprofile` → `shell/profile` (sets `ZDOTDIR`) → `$ZDOTDIR/.zshrc`.

That only works in a **login shell**. kitty is configured with `shell zsh -l`,
and Terminal.app and VS Code both use login shells on macOS, so this is fine in
practice.

**Do not create `~/.zshenv` with `ZDOTDIR` in it.** zsh would then look for
`$ZDOTDIR/.zprofile`, which does not exist in this repo, and `shell/profile`
would never be sourced.

Per-machine kitty settings (font size on a 24"/27" panel differs from the
MacBook) go in an untracked local override:

```sh
printf 'font_size 13.0\n' > ~/.config/kitty/local.conf
```

The repo's `host-${HOSTNAME}.conf` mechanism does **not** work on macOS —
`$HOSTNAME` is unset for GUI apps launched by launchd — so `kitty.conf` now also
does `globinclude local.conf`. `macos.conf` loads automatically via kitty's own
`KITTY_OS` variable.

## 7. Permissions and per-app setup

### Karabiner-Elements

1. Launch it. Grant **Input Monitoring** and approve the **driver system
   extension** in System Settings → Privacy & Security (needs a reboot).
2. Leave Caps Lock alone in System Settings → Keyboard → Modifier Keys.
   Karabiner does the Esc/Ctrl dual role; remapping it twice breaks it.
3. Verify: right Cmd is Hyper, Caps tapped is Escape, Caps held is Control.

Karabiner rewrites `karabiner.json` whenever you change something in its GUI.
Because of the folded symlink, those writes land in the repo — so `git diff`
after touching the GUI, and commit or discard deliberately.

### Aerospace

1. Launch it, grant **Accessibility**.
2. System Settings → Desktop & Dock → Mission Control:
   - turn **off** "Automatically rearrange Spaces based on most recent use"
   - turn **off** "Displays have separate Spaces" if you run more than one monitor
3. `start-at-login = true` is already in the config.
4. Verify: `Hyper + Enter` opens kitty, `Hyper + 1..9` switches workspaces.

### Raycast

1. System Settings → Keyboard → Keyboard Shortcuts → Spotlight: uncheck
   "Show Spotlight search" to free `Cmd + Space`.
2. Set Raycast's own hotkey (it is launched by `Hyper + D` from Aerospace).
3. Configure the rest from `docs/raycast-hotkeys.md`.

### Neovim

First launch installs the LazyVim plugin set. Then:

```sh
nvim +checkhealth
```

`node` and the Xcode CLT compiler cover Mason and treesitter.

### R / radian / Quarto

```sh
pipx install radian                 # aliasrc has r="radian"; R.nvim uses it
mkdir -p ~/.local/share/radian      # radian's history file lives here
quarto install tinytex              # provides latexmk for vimtex
```

`quarto install tinytex` is the small option. Use `brew install --cask
mactex-no-gui` instead only if you need a full TeX Live.

### Homebrew caveats

Several formulae print "add this line to your `~/.zshrc`". **Ignore all of them.**
`~/.config/zsh/.zshrc` is a symlink into this repo, so hand-editing it dirties
the repo, and in most cases the integration is already there:

| Caveat says | Do |
|-------------|-----|
| powerlevel10k, zsh-syntax-highlighting, fzf, direnv, micromamba | ignore — `.zshrc` already sources/hooks these |
| `pipx ensurepath` | **don't run it** — it rewrites shell rc files, and `shell/profile` already puts `~/.local/bin` on `$PATH` |
| `git lfs install` | skip — the `[filter "lfs"]` block is already in the tracked `git/config` |
| atuin, zoxide | neither is wired into `.zshrc` yet — a repo change, not a local edit |

### atuin

`.zshrc` initialises it automatically once the binary exists. One manual step —
seed it from the history you already have, otherwise it starts empty:

```sh
atuin import auto
atuin stats
```

`Ctrl+R` is atuin's from then on (it initialises after fzf, so it takes over
fzf's history widget). Up-arrow stays vanilla zsh, and `Ctrl+X Ctrl+R` gives you
zsh's pattern search.

History stays on this machine. If you later decide you want it synced across
janus/noctua, that is `atuin login` — a separate, reversible step.

### git

The tracked `git/config` still carries your McGill address. It now ends with an
`[include] path = config.local`, so set the work identity in an untracked file
rather than editing the shared config:

```sh
cat > ~/.config/git/config.local <<'EOF'
[user]
	email = your.name@newinstitution.example
EOF
```

If you'd rather keep the McGill identity for research repos and use the work one
only under a work tree, use a conditional include instead:

```ini
[includeIf "gitdir:~/Work/"]
	path = config.work
```

Also bring over the machine-local excludes file that `core.excludesFile` points
at. It is machine-local by design and not tracked in this repo, so copy janus's:

```sh
mkdir -p ~/.local/state/git
scp janus:.local/state/git/ignore ~/.local/state/git/ignore
```

Make sure `.DS_Store` and `._*` are in it — they matter a lot more here than they
did on Linux.

### Sioyek

Not installable via Homebrew — the cask is disabled because it points at the
x64-only v2.0.0 tag from December 2022. The project itself is alive (commits
through August 2026); it just hasn't cut a tagged release since.

The best prebuilt option is the `sioyek3-alpha0` preview, which does ship a
native Apple Silicon binary. Check your architecture first:

```sh
uname -m        # arm64 = Apple Silicon, x86_64 = Intel
```

On Apple Silicon:

```sh
cd ~/Downloads
curl -LO https://github.com/ahrm/sioyek/releases/download/sioyek3-alpha0/sioyek-release-mac-arm.zip
unzip sioyek-release-mac-arm.zip
ls                                    # confirm the .app name and case
mv sioyek.app /Applications/          # adjust if it unpacks as Sioyek.app
xattr -dr com.apple.quarantine /Applications/sioyek.app
open /Applications/sioyek.app
```

The `xattr` line matters: the build is unsigned, so Gatekeeper blocks it
otherwise.

On Intel, use `sioyek-release-mac.zip` from the `v2.0.0` release instead — same
steps.

Two caveats on the alpha: its bookmark/highlight database format is incompatible
with sioyek 2.x, so don't copy a database over from janus; and confirm the
installed app's name and case, because `docs/sioyek-synctex-setup.md` assumes
`/Applications/Sioyek.app/Contents/MacOS/sioyek` for
`vimtex_view_sioyek_exe`. Fix that path if the alpha unpacks lowercase.

If the alpha misbehaves, building current master natively is the fallback.

Then follow `docs/sioyek-synctex-setup.md`. If inverse search does nothing, it's
because `prefs_user.config` calls `kitty` by bare name and GUI apps don't inherit
your shell `$PATH` — use the absolute path:

```
inverse_search_command /Applications/kitty.app/Contents/MacOS/kitty nvim --headless -c "VimtexInverseSearch %2 '%1'"
```

## 8. macOS system settings

```sh
defaults write -g KeyRepeat -int 2            # fastest repeat
defaults write -g InitialKeyRepeat -int 15    # short delay before repeat
defaults write com.apple.dock autohide -bool true && killall Dock
```

Key repeat needs a logout to take effect.

Optional, and a real trade-off: `defaults write -g ApplePressAndHoldEnabled
-bool false` gives you key repeat on letters (nice in nvim) but kills the
accent popup. You mostly type accents with left Option (kitty sets
`macos_option_as_alt right`, so left Option stays as macOS compose), so this is
probably safe — but check `á é í ó ú ñ ¿ ¡` before committing to it.

Consider turning off Mission Control's `Ctrl + arrow` shortcuts in
System Settings → Keyboard → Keyboard Shortcuts if they collide with anything.

## 9. GPG and pass

`gnupg` is **not** in the stow list, and that is deliberate: `gpg-agent.conf` is
the only tracked file in that package, and its `pinentry-program` needs an
*absolute* path to a binary that lives in a different place on each platform
(`/usr/bin/pinentry-qt` on Artix, the Homebrew prefix here). gpg-agent does not
search `$PATH` for it — a bare name fails with `No pinentry`. So there is nothing
worth sharing in that package; write the file locally instead.

`GNUPGHOME` is already set to `~/.config/gnupg` by `shell/profile`, so a plain
directory is all it needs.

```sh
mkdir -p -m 700 ~/.config/gnupg

# Unquoted heredoc: $(brew --prefix) resolves to /opt/homebrew or /usr/local
cat > ~/.config/gnupg/gpg-agent.conf <<EOF
# Cache 1 day by default, 30 days max
default-cache-ttl       86400
default-cache-ttl-ssh   86400
max-cache-ttl           2592000
max-cache-ttl-ssh       2592000

pinentry-program $(brew --prefix)/bin/pinentry-mac
EOF

gpgconf --launch gpg-agent
```

(These are the same TTLs as the Linux config; only the pinentry line differs.
`~/.local/bin/pinentry-auto`, stowed with `bin`, would also work if you ever want
one config across several Macs — it now searches both Homebrew prefixes.)

### Move the key over

Your key is `so1.618e@gmail.com`, fingerprint `3078F339B6C8EFE014668B7A034BE9474D7884B3`
(the long key ID `034BE9474D7884B3` is just its last 16 characters; plain `gpg -K`
prints the fingerprint, `gpg -K --keyid-format=long` prints the short form).

Run the export **on janus, sitting at janus** — not over ssh. Exporting a secret
key makes gpg-agent unlock it, and janus's agent is configured for
`pinentry-qt`, which needs janus's own display. Over a plain ssh session that
prompt has nowhere to appear and the export just fails.

```sh
# on janus
gpg --export-secret-keys --armor 3078F339B6C8EFE014668B7A034BE9474D7884B3 > ~/gpg-secret.asc
gpg --export-ownertrust > ~/gpg-ownertrust.txt
```

Then on hestia:

```sh
scp janus:gpg-secret.asc janus:gpg-ownertrust.txt .
gpg --import gpg-secret.asc
gpg --import-ownertrust gpg-ownertrust.txt
gpg -K --keyid-format=long        # expect [ultimate] on the uid
rm gpg-secret.asc gpg-ownertrust.txt
ssh janus 'shred -u ~/gpg-secret.asc ~/gpg-ownertrust.txt'
```

The export is encrypted under your key passphrase, so it crossing the tailnet is
not a disaster — but clean it off both disks anyway, as above. `rm` on hestia's
SSD is not a real scrub; that's fine here because the file only ever held
passphrase-protected material.

Verify decryption works before moving on:

```sh
echo test | gpg --encrypt --armor -r 3078F339B6C8EFE014668B7A034BE9474D7884B3 | gpg --decrypt
```

The first `pinentry-mac` prompt has a "Save in Keychain" checkbox — ticking it
means macOS unlocks the key for you instead of prompting each session.

### Password store

It's a git repo, so this is just a clone. `PASSWORD_STORE_DIR` is already set by
`shell/profile`, so no extra config:

```sh
git clone git@github.com:soffiafdz/Pass-Store.git ~/.local/share/password-store
pass ls | head
```

## 10. Verify

- [ ] `echo $ZDOTDIR` → `~/.config/zsh`, prompt is powerlevel10k
- [ ] `which brew rg fd eza bat nvim yazi` all resolve
- [ ] `alias xclip` → `pbcopy` (the macOS alias branch is active)
- [ ] `alias p` → not defined (the pacman branch is *not* active)
- [ ] `Hyper + Enter` opens kitty; `Hyper + 1..9` switches workspaces
- [ ] Caps tapped → Escape; Caps held → Control
- [ ] kitty font size correct, transparency on, Nerd Font glyphs render
- [ ] `nvim +checkhealth` clean
- [ ] `git config user.email` → the work address
- [ ] `ssh -T git@github.com` authenticates
- [ ] `r` starts radian; `vd` opens visidata
- [ ] `gpg -K` shows the key as `[ultimate]`
- [ ] `pass ls` lists entries and `pass show <entry>` decrypts via pinentry-mac

## 11. Still worth deciding

GPG keys and `pass` are settled (§9). These are open:

| Item | Consideration |
|------|---------------|
| Syncthing | Would sync personal directories onto a work disk |
| Atuin sync | Pushes work shell history to your personal Atuin account, and pulls personal history down |
| Restic/rclone backups | Backing up a work machine to your personal cloud storage |
| `ssh/config` personal hosts | It ships `hyde` (home server) alongside the BIC/LAVIS hosts; the BIC ones are probably still relevant, `hyde` probably isn't |
| Thunderbird / Ferdium | Work mail is likely Outlook or webmail; check IT policy before adding accounts |
| Personal Zotero library | Fine, but note whether new group libraries should be separate |

## Changes made to the repo for this machine

The Mac-specific branches keyed off the hostname `noctua*`, which a second Mac
never matches. These are now `uname -s = Darwin` checks, so any Mac gets them:

| File | Change |
|------|--------|
| `shell/profile` | Homebrew shellenv tries `/opt/homebrew` then `/usr/local` (Intel) |
| `shell/aliasrc` | macOS aliases moved from a `noctua*` case to a Darwin check — without this the iMac fell through to the Arch branch and got `p="sudo pacman"` and friends |
| `zsh/.zshrc` | p10k and syntax-highlighting paths use `$HOMEBREW_PREFIX`; `MAMBA_EXE` falls back to `$PATH` (Homebrew doesn't install micromamba to `~/.local/bin`) |
| `bin/pinentry-auto` | Searches both brew prefixes and falls back through Qt/GTK/curses |
| `kitty/kitty.conf` | Added `globinclude local.conf` for per-machine overrides |
| `git/config` | Added `[include] path = config.local` for a per-machine identity |
| `ssh/config` | Added `UseKeychain yes` guarded by `IgnoreUnknown` so Linux still parses it |
| `.gitignore` | Ignores `local.conf` / `config.local`; `.DS_Store` untracked |

`shell/profile`'s hostname `case` was left alone: an unknown Mac hostname falls
through to the default branch, which sets `TERMINAL=kitty` correctly, and the
`startx` line there can't fire on macOS (`tty` is never `/dev/tty1`).
