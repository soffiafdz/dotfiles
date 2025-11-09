-- Gruvbox colorscheme
return {
  -- colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = { transparent_mode = true },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },
}
