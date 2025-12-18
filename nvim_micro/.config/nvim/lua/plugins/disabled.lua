-- Disable unnecessary LazyVim plugins for writerdeck (Raspberry Pi Zero 2W)
-- Last synced: 2025-12-18
--
-- Categories:
-- [HEAVY] CPU/Memory intensive plugins
-- [UNNEEDED] Not required for prose/markdown writing workflow
-- [ENABLED] Lightweight plugins kept enabled: gitsigns, persistence, mini.pairs

return {
  -- [HEAVY] Snippets - not needed for writing
  { "L3MON4D3/LuaSnip", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
  { "saadparwaiz1/cmp_luasnip", enabled = false },

  -- [HEAVY] Completion ecosystem - CPU intensive
  { "hrsh7th/nvim-cmp", enabled = false },
  { "hrsh7th/cmp-buffer", enabled = false },
  { "hrsh7th/cmp-git", enabled = false },
  { "hrsh7th/cmp-nvim-lsp", enabled = false },
  { "hrsh7th/cmp-path", enabled = false },

  -- [HEAVY] Treesitter - CPU intensive parsing
  { "nvim-treesitter/nvim-treesitter", enabled = false },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  { "windwp/nvim-ts-autotag", enabled = false },
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },
  { "folke/ts-comments.nvim", enabled = false },

  -- [HEAVY] Telescope - memory intensive (using fzf-lua instead)
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },

  -- [HEAVY] UI/Rendering overhead
  { "akinsho/bufferline.nvim", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
  { "stevearc/dressing.nvim", enabled = false },

  -- [HEAVY] Formatting daemon
  { "stevearc/conform.nvim", enabled = false },

  -- [UNNEEDED] Navigation/Search
  { "folke/flash.nvim", enabled = false },
  { "MagicDuck/grug-far.nvim", enabled = false },
  { "folke/trouble.nvim", enabled = false },

  -- [UNNEEDED] LaTeX support (prose only)
  { "lervag/vimtex", enabled = false },

  -- [UNNEEDED] Development tools
  { "b0o/SchemaStore.nvim", enabled = false },
  { "linux-cultists/venv-selector.nvim", enabled = false },

  -- [UNNEEDED] Colorschemes (keeping only gruvbox)
  { "catppuccin/nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },

  -- [UNNEEDED] Mini plugins that are heavy or not needed
  { "nvim-mini/mini.ai", enabled = false },
  { "nvim-mini/mini.comment", enabled = false },
  { "nvim-mini/mini.surround", enabled = false },

  -- [UNNEEDED] Markdown preview (requires browser)
  { "iamcco/markdown-preview.nvim", enabled = false },

  -- [ENABLED] Lightweight plugins (removed from disabled list):
  -- gitsigns.nvim - Git indicators (very lightweight)
  -- persistence.nvim - Session management (minimal overhead)
  -- mini.pairs - Auto-pairs (lightweight)
  -- fzf-lua - Fuzzy finder (lighter than telescope, needed for palimpsest)

  -- [HEAVY] Linters - disabled on Pi (too resource intensive)
  { "mfussenegger/nvim-lint", enabled = false },

  -- Ltex-Plus
  -- { "mason-org/mason.nvim", enabled = false },
  -- { "mason-org/mason-lspconfig.nvim", enabled = false },
  -- { "neovim/nvim-lspconfig", enabled = false },

  -- ToDo
  -- { "folke/todo-comments.nvim", enabled = false },

  -- UI required
  -- { "nvim-mini/mini.icons", enabled = false },
  -- { "folke/noice.nvim", enabled = false },
  -- { "MunifTanjim/nui.nvim", enabled = false },
  -- { "nvim-lua/plenary.nvim", enabled = false },
  -- { "folke/snacks.nvim", enabled = false },
}
