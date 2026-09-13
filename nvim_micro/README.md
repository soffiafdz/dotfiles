# nvim_micro

The Neovim config for the writerdeck (Raspberry Pi Zero 2W, 512 MB). It stows
to the same `~/.config/nvim` as the `nvim` package, so a machine gets one or
the other, never both:

    stow -d ~/Repos/dotfiles -t ~ nvim_micro

It is a thin layer, not a fork. `lua/config/lazy.lua` finds the main config
through this package's real path in the repo, adds it to the runtime path, and
imports its plugin specs. Options, keymaps, autocmds (including prose
autosave), the trilingual spell setup and the word list all come from
`nvim/.config/nvim`. The lockfile is shared too, so both configs pin the same
plugin commits.

Only `lua/micro/` is Pi-specific:

- `disabled.lua` turns off what the Pi cannot afford: treesitter, LSP and
  mason, completion, linters, formatting, preview and the data-science stack.
- `vimwiki.lua` drops the main config's wiki list; the palimpsest deck
  registers its own.
- `palimpsest.lua` loads the pure-Lua `palimpsest_deck` from `~/Palimpsest`
  instead of the full plugin.

`lazyvim.json` stays separate because it lists this config's extras (only the
mini-comment, mini-surround and git ones).
