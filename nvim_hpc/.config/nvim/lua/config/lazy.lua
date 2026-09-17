-- nvim_hpc: a thin layer over the main nvim config in this repo, for Alliance
-- clusters (Rorqual, Trillium). The main config supplies options, keymaps,
-- autocmds, plugin specs and spell files; lua/hpc/ disables what needs a
-- package manager, a browser or a GUI.
--
-- Compute nodes have no internet: run :Lazy sync and :TSUpdate on a LOGIN
-- node, never inside a job.

-- Locate the main config through this file's real path in the repo, so it
-- works wherever the dotfiles are checked out and however they are stowed.
local here = vim.fn.fnamemodify(vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)), ":h")
local main = vim.fn.simplify(vim.fn.fnamemodify(here .. "/../../../../../nvim/.config/nvim", ":p")):gsub("/$", "")
if vim.fn.isdirectory(main) == 0 then
  vim.api.nvim_echo({ { "nvim_hpc: main config not found at " .. main, "ErrorMsg" } }, true, {})
end

-- Share the main config's word list so zg/zw edits land in the repo.
vim.opt.spellfile = main .. "/spell/en.utf-8.add"

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
    -- Extras that work without mason-installed binaries
    { import = "lazyvim.plugins.extras.coding.mini-comment" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
    { import = "lazyvim.plugins.extras.editor.fzf" },
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.r" },
    -- The main config's plugin specs, found through the runtime path below
    { import = "plugins" },
    -- Cluster-only overrides, applied last so they win
    { import = "hpc" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "gruvbox" } },
  checker = {
    -- Compute nodes have no network; update deliberately on a login node.
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      -- The main config joins the runtime path: config.options/keymaps/
      -- autocmds, lua/plugins and spell/ all come from there.
      paths = { main },
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
