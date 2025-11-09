-- Disable unnecessary LazyVim plugins for writerdeck
-- Keep: markdown, python, lua, yaml, grammar checking
-- Remove: R, Quarto, Docker, Git extras, heavy UI

return {
  -- -- DISABLE LANGUAGE SUPPORT YOU WON'T USE ON WRITERDECK
  -- { "R-nvim/R.nvim", enabled = false },
  -- { "quarto-dev/quarto-nvim", enabled = false },
  -- { "jmbuhr/otter.nvim", enabled = false },
  --
  -- -- DISABLE HEAVY UI PLUGINS
  -- { "folke/noice.nvim", enabled = false },
  -- { "rcarriga/nvim-notify", enabled = false },
  -- { "stevearc/dressing.nvim", enabled = false },
  --
  -- -- DISABLE NAVIGATION/MOTION (if too heavy)
  -- { "folke/flash.nvim", enabled = false },
  --
  -- -- DISABLE GIT INTEGRATIONS (optional - re-enable if you need)
  -- { "lewis6991/gitsigns.nvim", enabled = false },
  -- { "tpope/vim-fugitive", enabled = false },
  --
  -- -- DISABLE EXTRAS YOU DON'T NEED
  -- { "folke/trouble.nvim", enabled = false },
  -- { "folke/todo-comments.nvim", enabled = false },
  -- { "folke/persistence.nvim", enabled = false },
}
