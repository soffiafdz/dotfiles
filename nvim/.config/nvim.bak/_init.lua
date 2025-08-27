-- Options/Keymaps
-- Home directory
HOME = os.getenv("HOME")

-- Legacy(?)
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- mapleaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General
vim.opt.autowrite = true -- Enable auto write
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.foldlevel = 99
vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hidden = true                       -- Allow background buffers
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 2                      -- Always display statusline
vim.opt.lazyredraw = true                   -- Redraw only when needed
--vim.opt.linebreak = true -- Wrap lines at convenient points
--vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative numbers
vim.opt.ruler = true -- Show cursor position
vim.opt.scrolloff = 5 -- Keep context around cursor
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showcmd = true -- Show incomplete commands
vim.opt.showmode = false -- Airline displays mode
vim.opt.sidescrolloff = 5 -- Keep context around cursor
vim.opt.signcolumn = yes -- Always show signcolumn
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.spelllang = { "en_ca", "sp", "fr" }
vim.opt.splitbelow = true -- Put new windows below current
--vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
--vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.opt.synmaxcol = 200 -- Limit syntax scan length
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.textwidth = 80 -- Text width is 80 characters
--vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
--vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
--vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- No wrap by default

-- Invisible characters
vim.opt.showbreak = "↳"
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.listchars = {
  eol = "⏎",
  tab = "› ",
  trail = "·",
  lead = "·",
  nbsp = "␣",
  extends = "…",
  precedes = "…",
}
vim.opt.list = false

--
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0






-- Plugins: Lazy
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath
  })
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
--require("lazy").setup("plugins")
--[[
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
--]]
