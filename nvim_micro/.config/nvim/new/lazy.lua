-- Modified lazy.lua for writerdeck (Raspberry Pi Zero 2W)
-- Based on your existing config but with unnecessary extras removed

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- ESSENTIAL CODING EXTRAS (from your config)
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    { import = "lazyvim.plugins.extras.coding.mini-comment" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
    
    -- ESSENTIAL EDITOR EXTRAS
    { import = "lazyvim.plugins.extras.editor.telescope" },
    
    -- FORMATTING (keep what you need)
    { import = "lazyvim.plugins.extras.formatting.black" }, -- Python
    { import = "lazyvim.plugins.extras.formatting.prettier" }, -- Markdown/YAML
    
    -- LANGUAGE SUPPORT (ONLY WHAT YOU NEED FOR WRITERDECK)
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" }, -- Essential for writing
    { import = "lazyvim.plugins.extras.lang.python" }, -- Light scripting
    { import = "lazyvim.plugins.extras.lang.yaml" },
    
    -- REMOVED FROM YOUR CONFIG:
    -- { import = "lazyvim.plugins.extras.lang.docker" },  -- Not needed
    -- { import = "lazyvim.plugins.extras.lang.git" },     -- Not needed
    -- { import = "lazyvim.plugins.extras.lang.r" },       -- Not needed on writerdeck
    -- { import = "lazyvim.plugins.extras.lang.tex" },     -- Not needed (unless you write LaTeX?)
    -- { import = "lazyvim.plugins.extras.lang.toml" },    -- Not needed
    -- { import = "lazyvim.plugins.extras.editor.dial" },  -- Not essential
    -- { import = "lazyvim.plugins.extras.editor.snacks_picker" }, -- Redundant with telescope
    -- { import = "lazyvim.plugins.extras.ui.indent-blankline" }, -- Heavy
    -- { import = "lazyvim.plugins.extras.util.dot" },     -- Not needed
    
    -- YOUR CUSTOM PLUGINS
    { import = "plugins" },
  },
  
  defaults = {
    lazy = false,
    version = false,
  },
  
  install = { colorscheme = { "gruvbox", "tokyonight", "habamax" } },
  
  checker = {
    enabled = false, -- Disable on Pi Zero for performance
    notify = false,
  },
  
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",  -- You might want this
        -- "matchparen", -- You might want this
        -- "netrwPlugin", -- You might want this
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
