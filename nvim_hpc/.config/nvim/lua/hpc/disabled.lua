-- Disable what an Alliance cluster cannot support. Applies on top of the main
-- config's specs; see lua/config/lazy.lua.
--
-- Two constraints drive this list:
-- [NET]  compute nodes have no internet, and mason downloads binaries
-- [GUI]  no browser, no PDF viewer, no desktop paths
--
-- Kept on purpose: treesitter (parsers compile on a login node), nvim-cmp,
-- R.nvim, quarto/otter, gitsigns, snacks, render-markdown.

return {
  -- [NET] Mason manages binaries it has to download; on the cluster, install
  -- language servers through modules or R/pip instead.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  -- nvim-lspconfig stays: it picks up servers already on $PATH, e.g. the
  -- R languageserver package.

  -- [NET] Formatters and linters are mason-installed binaries.
  { "stevearc/conform.nvim", enabled = false },
  { "mfussenegger/nvim-lint", enabled = false },

  -- (harper-ls is installed by mason, so it is gone with mason; nvim's own
  -- spell checking and the repo's word list still work.)

  -- [GUI] Markdown preview needs a browser on the same machine.
  { "iamcco/markdown-preview.nvim", enabled = false },

  -- [GUI] LaTeX: no viewer, no forward search. Compile in a job instead.
  { "lervag/vimtex", enabled = false },

  -- [GUI] Wiki and writing deck live on personal machines.
  { "vimwiki/vimwiki", enabled = false },

  -- Python venv picker: on the cluster, venvs come from `loadpy`.
  { "linux-cultists/venv-selector.nvim", enabled = false },
}
