# dotfiles

Configuration for every machine I use, deployed with GNU Stow. One package per
program, one repo for all hosts, host differences handled inside the configs
rather than by branches.

Which packages a machine gets is its *profile*: a list in `profiles/`, applied
by `./bootstrap`. Profiles are `linux`, `workstation`, `macos`, `writerdeck`
and `hpc`, each stowed on top of `profiles/common`. `$DOTFILES_TYPE` is the
coarser environment split the shell uses — `linux`, `macos` or `hpc` — and
picks `shell/profile.d/<type>.sh`.

Hosts:

| Host | What it is | Notes |
|---|---|---|
| janus | Artix Linux desktop, dwm, NVIDIA | Main machine. X started from tty1 by `shell/profile`. |
| lettera | Artix Linux laptop | Has `kitty/host-lettera.conf` and `x11/host-lettera.xresources`. |
| tango | Artix Linux laptop | Same set as lettera, no host files. |
| hestia | Office iMac, macOS | See `docs/imac-setup.md`; installs from `Brewfile.work`. |
| writerdeck | Raspberry Pi Zero 2W | Stows `nvim_micro` instead of `nvim`. |
| mcgill workstations | BIC Linux hosts, used remotely | Profile `workstation`: no X11, no dwm glue. `shell/profile` skips the desktop parts on `*mcgill*`. |
| rorqual, trillium | Alliance clusters (Slurm) | Type `hpc`: `nvim_hpc` instead of `nvim`, no GUI packages. `$CC_CLUSTER` gates the shell. |

The window manager is a separate repo at `~/Repos/dwm`; its `config.h` is
where every desktop keybinding lives, and `docs/keybindings.txt` mirrors it.

## Layout and conventions

Every top-level directory is a stow package whose contents mirror the target
tree. Almost all of them target the home directory:

- `<pkg>/.config/<pkg>/...` for XDG configs (`kitty`, `nvim`, `zsh`, ...).
- `<pkg>/.<dotfile>` for the few programs that want a dotfile in `$HOME`
  (`vim/.vimrc`, `zsh/.zshenv`).
- `bin/.local/bin/` for scripts, `ssh/.ssh/config` for ssh.
- `jellyfin/etc/...` is the one package that targets `/`, see its README.

Always give stow both the package directory and the target, whatever the
current directory is:

    stow -d ~/Repos/dotfiles -t ~ <package>...
    stow -n -v -d ~/Repos/dotfiles -t ~ <package>   # dry run first

Two stow behaviours matter here:

- **Folding.** When the target directory does not exist yet, stow links the
  whole directory as one symlink into the repo. Anything the program writes
  there afterwards lands inside the checkout. That is fine for `nvim`
  (the lockfile is meant to be tracked) and harmless for most packages, but it
  is how the gnupg keyring once ended up inside the repo, and later how
  `~/.local` became a symlink to `bin/.local`, pulling 1.4G of nvim plugins,
  pipx venvs and the plaintext atuin key into the checkout. **`gnupg` and
  `bin` must both be stowed with `--no-folding`**; the `.gitignore` allowlist
  and the `bin/.local/{share,state,cache}` entries keep the fallout out
  regardless. Verify with:

      for p in ~/.local ~/.local/bin ~/.local/share ~/.local/state; do
        [ -L "$p" ] && echo "FOLDED: $p" || echo "ok: $p"
      done

  The trade-off: a `--no-folding` package is symlinked file by file, so a pull
  that adds or removes files there needs `stow -R --no-folding -t ~ <pkg>` to
  sync. Folded packages pick those up for free. The same applies to any package
  whose target directory holds an untracked local file, which is why
  `~/.config/kitty` is unfolded too.
- **Package READMEs are not stowed.** Stow ignores `README*` at the top of a
  package, so `jellyfin/README.md` and `nvim_micro/README.md` stay in the
  repo only.

Machine-local files live next to the tracked ones and are never committed:

| Tracked file | Local companion | Mechanism |
|---|---|---|
| `ssh/.ssh/config` | `~/.ssh/config.local` | `Include config.local` at the top; home hosts go here. |
| `git/.config/git/config` | `~/.config/git/config.local` | `[include]`; per-host identity or credentials. |
| `kitty/.config/kitty/kitty.conf` | `host-<name>.conf`, `local.conf` | `globinclude` and `include`; `local.conf` is gitignored. |
| `x11/.config/x11/xresources` | `host-<name>.xresources` | Merged by `xprofile` when present. |
| none | `~/.config/mimeapps.list` | Not tracked: desktop apps rewrite it constantly. |

## Bootstrap

`./bootstrap` reads a profile and stows exactly those packages. It guesses the
type from `$CC_CLUSTER` and `uname`, dry-runs by default, and falls back to
plain symlinks where GNU Stow is not installed (clusters).

    ./bootstrap            # show what would be stowed, for the guessed type
    ./bootstrap -f         # do it
    ./bootstrap -f macos   # force a type
    ./bootstrap -D -f hpc  # unstow that type

`bin`, `gnupg` and `hpc` are always stowed `--no-folding`, so nothing a program
writes into those directories lands in the repo.

### Linux (Artix, runit)

    git clone git@github.com:soffiafdz/dotfiles.git ~/Repos/dotfiles
    cd ~/Repos/dotfiles
    ./bootstrap -f linux
    chsh -s "$(command -v zsh)"

Then build the window manager: `git clone git@github.com:soffiafdz/dwm.git
~/Repos/dwm && sudo make -C ~/Repos/dwm install`. Logging in on tty1 runs
`startx` automatically from `shell/profile`; the session flow is described
below. `docs/software-setup.md` lists the packages to install and
`docs/dual-boot-install.md` covers the base system.

### macOS

    git clone git@github.com:soffiafdz/dotfiles.git ~/Developer/dotfiles
    brew bundle --file=~/Developer/dotfiles/Brewfile        # or Brewfile.work
    cd ~/Developer/dotfiles
    ./bootstrap -f macos

`gpg-agent.conf` names a Linux pinentry; on macOS point it at
`bin/.local/bin/pinentry-auto` or the Homebrew pinentry-mac. Full walkthrough in
`docs/imac-setup.md`.

### Writerdeck (calliope)

    ./bootstrap -f writerdeck

`nvim_micro` in place of `nvim`, plus ssh, yazi and fzf. No desktop packages,
no `bin`, no `atuin`.

### BIC workstations

    ./bootstrap -f workstation

Remote-only hosts: editor, shell and file tools, nothing graphical. The old
local dwm session on phebe is deprecated; unstow `x11` and `bin` where they
are still linked.

### HPC (Alliance clusters)

Clone into project space, not `$HOME`: `$HOME` is small and has a file-count
quota that plugin trees eat.

    git clone git@github.com:soffiafdz/dotfiles.git ~/projects/def-<pi>/$USER/dotfiles
    cd ~/projects/def-<pi>/$USER/dotfiles
    ./bootstrap -f hpc
    echo def-<pi> > ~/.config/hpc/account     # Slurm account for every job
    ~/.local/bin/hpc-setup                    # login node only: nvim, p10k, plugins

Login nodes have internet; compute nodes do not. Everything that downloads —
`:Lazy sync`, `:TSUpdate`, `pip install` — happens on a login node. `hpc-setup`
installs the static Neovim build into `~/.local/opt/nvim`, since the clusters
ship no nvim. See `hpc/README.md` for the aliases and job templates.

## Packages

| Package | Target | Hosts | What it holds |
|---|---|---|---|
| `aerospace` | `~/.config/aerospace` | macOS | Tiling WM config. Hyper (cmd+ctrl+alt+shift) as the modifier, bindings mirror dwm's. |
| `atuin` | `~/.config/atuin` | all | Shell history search. Sync key lives outside the repo. |
| `bin` | `~/.local/bin` | all | Scripts, see below. |
| `bpytop` | `~/.config/bpytop` | Linux | Process monitor theme and config. |
| `castero` | `~/.config/castero` | Linux | Podcast client config and an OPML export of feeds. |
| `dunst` | `~/.config/dunst` | Linux | Notifications. Keys are bound in dwm via `dunstctl`, not in dunstrc. |
| `foot` | `~/.config/foot` | Wayland hosts | Terminal, unused on janus. |
| `fzf` | `~/.config/fzf` | all | Vendored key bindings and completion, sourced by `.zshrc`. |
| `git` | `~/.config/git` | all | Identity, aliases, safe defaults. Includes `config.local`. |
| `gnupg` | `~/.config/gnupg` | all | Only `gpg-agent.conf`. Stow with `--no-folding`. |
| `hpc` | `~/.config/hpc`, `~/.local/...` | clusters | Slurm aliases, `salloc`/module helpers, sbatch templates, `hpc-setup`. See its README. |
| `jellyfin` | `/etc/runit/sv/jellyfin` | janus | Podman container as a runit service. See its README. |
| `karabiner` | `~/.config/karabiner` | macOS | Key remaps. |
| `kitty` | `~/.config/kitty` | all | Terminal. Asks before closing a window with a running child. |
| `mpd`, `ncmpcpp` | `~/.config/...` | janus | Music daemon and client. mpd is started by `xprofile`. |
| `mpv` | `~/.config/mpv` | Linux | Player with NVDEC and gpu-next; also the image viewer for yazi. |
| `nvim` | `~/.config/nvim` | all but the Pi | LazyVim-based editor config, see Editors. |
| `nvim_hpc` | `~/.config/nvim` | clusters | Thin layer over `nvim`: no mason, no formatters, no GUI. See its README. |
| `nvim_micro` | `~/.config/nvim` | writerdeck | Thin layer over `nvim`, see its README. |
| `picom` | `~/.config/picom` | janus | Compositor. glx backend, sync fence and no damage tracking for NVIDIA. |
| `radian` | `~/.config/radian` | all | R console. |
| `redshift` | `~/.config/redshift` | Linux | Fixed Montreal location, randr method. |
| `shell` | `~/.config/shell` | all | `profile` (environment, PATH, startx) and `aliasrc`, shared by every shell. |
| `sioyek`, `zathura` | `~/.config/...` | all / Linux | PDF readers. Sioyek has the Zotero and SyncTeX setup, see docs. |
| `ssh` | `~/.ssh/config` | all | Workstation hosts and jump config. Home hosts are in `config.local`. |
| `tmux` | `~/.config/tmux` | all | gpakosz's tmux.conf plus `tmux.conf.local` with the actual settings. |
| `vim` | `~/.vimrc` | all | Fallback editor. Autosaves on focus loss. |
| `x11` | `~/.config/x11` | Linux | `xinitrc`, `xprofile`, `xpipewire`, Xresources. |
| `yazi` | `~/.config/yazi` | all | File manager, gruvbox flavor, openers. |
| `zsh` | `~/.zshenv`, `~/.config/zsh` | all | Login and interactive shell, see below. |

`Brewfile` and `Brewfile.work` are not packages; they are the macOS install
lists. `docs/` is documentation.

## Shell startup

    ~/.zshenv          exports ZDOTDIR=~/.config/zsh (every zsh, login or not)
    ~/.config/zsh/.zprofile
                       login shells: sources shell/profile
    shell/profile      environment: XDG dirs, PATH (~/.local/bin first, once),
                       EDITOR/TERMINAL/BROWSER, GNUPGHOME, SUDO_ASKPASS;
                       on Linux tty1 with no X running: exec startx;
                       then sources profile.d/$DOTFILES_TYPE.sh
    shell/profile.d/   type-specific environment: hpc.sh (Slurm account,
                       ~/.config/hpc/env.sh), and linux.sh / darwin.sh if
                       they are ever needed
    ~/.config/zsh/.zshrc
                       p10k instant prompt, completion (cache in ~/.cache/zsh),
                       aliasrc, fzf, atuin (owns Ctrl-R), zoxide, direnv
    ~/.local/state/zsh/history

`EDITOR`, `TERMINAL` and `BROWSER` matter beyond the shell: dwm's keybindings
spawn `$TERMINAL` and `$BROWSER`, and they are inherited by X through
`startx`.

## X session on janus

`startx` runs `x11/.config/x11/xinitrc`, which:

1. Truncates `~/.xsession-errors` when it passes 1 MiB and redirects the whole
   session's output there.
2. Sources `xprofile`: merges Xresources, sets key repeat and `caps:escape`,
   then branches on hostname. janus runs `autorandr`, disables DPMS, starts
   pipewire detached, deskflow, mpd and the Proton Mail bridge.
3. Starts dwm inside `dbus-run-session` in a restart loop: a clean quit
   (exit 0) or a SIGTERM from `sysaction` ends the session; any other exit
   restarts dwm so open windows survive a crash, giving up after three quick
   failures.

dwm's own autostart (in its `config.h`) launches and, on restart, re-launches
`setwp`, `picom`, `dunst`, `unclutter`, `redshift`, `dwmbar` and `clipmenud`.
Nothing else should be started from xinitrc.

Two-key chord bindings were removed from dwm in September 2026 after they
caused input deadlocks; every binding is now a single Super combination.
Destructive ones (kill -9, shutdown, power actions) go through `prompt` or a
dmenu confirmation.

## Scripts

All in `bin/.local/bin`, POSIX sh unless noted. The dmenu ones are bound in dwm.

| Script | Purpose |
|---|---|
| `sysaction` | dmenu: display off, lock, leave dwm, sleep, reboot, shutdown. Confirms the destructive ones. |
| `prompt` | `prompt "Question?" "command"`: dmenu Yes/No, runs the command on Yes. |
| `dmenumount`, `dmenuumount` | Mount and unmount drives and Android devices through dmenu. |
| `dmenupass` | Pick a `pass` entry; copy it with clipmenud paused, or type it into the window that was focused. bash. |
| `dmenuask` | `SUDO_ASKPASS` helper built on pinentry. |
| `pinentry-auto` | Chooses the first available pinentry (macOS GUI, Qt/GTK, curses). |
| `dwmbar`, `refbar` | Status bar loop and its refresh signal (`SIGUSR1`). |
| `setwp` | Wallpaper picker and setter. |
| `init_tmux` | Attach to the unattached `LOCAL` session or create the next one. Bound to Super+Shift+Return. |
| `displayoff`, `janus-monitors` | DPMS off; toggle the second monitor on janus. |
| `tpadToggle`, `tpointToggle`, `killKbd`, `tpadfix` | ThinkPad input toggles and the i2c_hid blacklist fix. Laptop-only. |
| `chp`, `chbicws` | Bluetooth headphone toggle; check which BIC workstations are reachable. |
| `rotdir`, `transadd`, `teams_linux` | Helpers for an image viewer, transmission and Teams. Only useful where those are installed. |
| `micromamba` | The binary, gitignored. |

## Editors

`nvim` is LazyVim with the extras listed in `lazyvim.json`. Things worth
knowing:

- Prose buffers (markdown, vimwiki, text, tex, quarto) autosave on focus loss,
  leaving insert mode and idle, without running formatters. Explicit `:w`
  still formats.
- Spelling accepts en, es and fr together; the word list `spell/en.utf-8.add`
  is tracked and shared with `nvim_micro`.
- Grammar comes from harper-ls. ltex-ls-plus is disabled on purpose: it costs
  about a gigabyte per instance.
- `lazy-lock.json` is tracked; update deliberately with `:Lazy update` and
  commit the lockfile.
- Open long writing sessions inside tmux (`init_tmux`). Terminal windows
  outside tmux die with the X session; tmux sessions do not.

`nvim_micro` reuses all of that on the Pi and only disables what the hardware
cannot run; see `nvim_micro/README.md`. `vim/.vimrc` is the fallback for hosts
without Neovim.

## Secrets and what stays out

The repository is public. Never commit keys, tokens or passwords; the
`.gitignore` keeps the gnupg keyring, kitty's `local.conf`, zsh caches and the
micromamba binary out, and the machine-local companions above are never added.
A VPN script with embedded credentials was removed in September 2026; the
credential is retired.

## Docs

| File | Contents |
|---|---|
| `docs/software-setup.md` | What to install on a Linux host and why. |
| `docs/dual-boot-install.md` | Artix plus Windows installation notes. |
| `docs/linux-setup-tasks.md` | Deferred tasks on the Linux hosts. |
| `docs/imac-setup.md` | The office iMac from scratch. |
| `docs/keybindings.txt`, `docs/unified-keybinding-design.md` | The shared dwm and Aerospace keymap and its design. |
| `docs/planck-layout-design.md`, `docs/raycast-hotkeys.md` | Keyboard layout and macOS launcher hotkeys. |
| `docs/sioyek-synctex-setup.md` | Sioyek, Zotero and SyncTeX. |
| `docs/windows-info-commands.md` | Commands for the Windows side of the dual boot. |

## Maintenance

- **Adding a package.** Create `<name>/.config/<name>/` mirroring the target,
  stow it, commit. If the target directory already exists as a real directory
  with files the program generates, stow the package with `--no-folding` so
  those files stay out of the repo.
- **Adding files to a stowed package.** With a folded package they appear
  immediately. Otherwise run `stow -R -d ~/Repos/dotfiles -t ~ <pkg>`.
- **Removing files.** `git rm` them, then `stow -R` the package to drop the
  dangling links.
- **Checking a host.** `stow -n -v -d ~/Repos/dotfiles -t ~ <pkg>` shows what
  would change without touching anything; a conflict means a real file is in
  the way and should be merged by hand, never adopted with `--adopt`.
- **Commits.** One-line imperative messages, no trailers.
