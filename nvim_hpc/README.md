# nvim_hpc

The Neovim config for Alliance clusters (Rorqual, Trillium). It stows to the
same `~/.config/nvim` as the `nvim` and `nvim_micro` packages, so a machine
gets exactly one of the three:

    ./bootstrap -f hpc

It is a thin layer, not a fork, and works like `nvim_micro`:
`lua/config/lazy.lua` finds the main config through this package's real path in
the repo, adds it to the runtime path, and imports its plugin specs. Options,
keymaps, autocmds, the spell setup and the word list all come from
`nvim/.config/nvim`. The lockfile stays separate, for the same reason it does
on the writerdeck: lazy.nvim rewrites it with only the plugins a config loads.

`lua/hpc/disabled.lua` turns off what a cluster cannot support:

- **mason and mason-lspconfig** download binaries, and compute nodes have no
  internet. `nvim-lspconfig` stays, and picks up any server already on `$PATH`
  — install R's `languageserver` package for R.
- **conform and nvim-lint** drive mason-installed formatters and linters.
  harper-ls goes with mason; nvim's own spell checking still works.
- **markdown-preview** needs a browser, **vimtex** a PDF viewer.
- **vimwiki** and **venv-selector**: the wiki lives on personal machines, and
  cluster virtualenvs come from `loadpy` in the `hpc` package.

Kept: treesitter, nvim-cmp, R.nvim, quarto/otter, gitsigns, snacks,
render-markdown.

## Neovim itself

The clusters ship no nvim. `hpc-setup` installs the static build into
`~/.local/opt/nvim` and links it into `~/.local/bin`.

Plugin work must happen on a **login node**: `:Lazy sync`, `:TSUpdate`, and any
first run that clones. Inside a job there is no network, and a config that
tries to clone will just hang or error.
