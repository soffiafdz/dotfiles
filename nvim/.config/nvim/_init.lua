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
vim.opt.hidden = true -- Allow background buffers
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

-- Directories
vim.opt.backupdir = HOME .. "/.local/state/nvim/backup//"
vim.opt.undodir = HOME .. "/.local/state/nvim/undo//"

--
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Trim whitespace
vim.api.nvim_create_autocmd("BufWritePre", { command = [[%s/\s\+$//e]] })

-- Auto-save on lost focus
vim.api.nvim_create_autocmd("FocusLost", { command = ":wa" })

-- Buffers (bufremove)
vim.keymap.set("n", "<Leader>bd", function() require("mini.bufremove").delete() end, { desc = "Delete buffer(s)" })

-- Git (fugitive)
vim.keymap.set("n", "<Leader>gs", "<Cmd>Git<CR>", { desc = "Git status" })
vim.keymap.set("n", "<Leader>gd", "<Cmd>Git diff<CR>", { desc = "Git diff" })
vim.keymap.set("n", "<Leader>gD", "<Cmd>Git diff --staged<CR>", { desc = "Git diff (staged)" })
vim.keymap.set("n", "<Leader>gb", "<Cmd>Git blame<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<Leader>gl", "<Cmd>Git log<CR>", { desc = "Git log" })

--Search remaps
vim.keymap.set({ "n", "v" }, "/", "/\v", { desc = "Sane REGEX" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Keep search match in the middle" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep search match in the middle" })
vim.keymap.set("n", "<leader><tab>", ":noh<CR>", { desc = "Clear searches" })
vim.keymap.set( { 'n', 'x' }, "<Leader>sR", function()
  require("grug-far").grug_far({})
end, { desc = "Grug-far" })
vim.keymap.set( { 'n', 'x' }, "<Leader>sr", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%"), }, transient = true })
end, { desc = "Grug-gar: Current file" })
vim.keymap.set({ 'n', 'x' }, '<leader>ss', function()
  local search = vim.fn.getreg('/')
  -- surround with \b if "word" search (such as when pressing `*`)
  if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
    search = '\\b' .. search:sub(3, -3) .. '\\b'
  end
  require('grug-far').open({ prefills = { search = search, }, transient = true})
end, { desc = "Grug-far: @/ register value / Visual selection" })

-- Window navigation remaps
vim.keymap.set("n", "<leader>w", "<C-w>v", { desc = "Vertical split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window moving (Up)" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window moving (Down)" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window moving (Left)" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window moving (Right)" })

-- Natural movement
vim.keymap.set("n", "H", "^", { desc = "Beginning of line" })
vim.keymap.set("n", "L", "g_", { desc = "End of line" })
vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Movement with wrap (Down)" })
vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Movement with wrap (Up)" })

-- Window resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Transparent background
vim.cmd([[
  hi! Normal       ctermbg=NONE guibg=NONE
  hi! LineNr       ctermbg=NONE guibg=NONE
  hi! CursorLineNr ctermbg=NONE guibg=NONE
  hi! NonText      ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
]])


-- colorscheme ; This will be replaced
-- TODO
vim.cmd("colorscheme gruvbox")

-- File-specific formatting
local au_ftype_settings = vim.api.nvim_create_augroup("FiletypeSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"r", "rmd", "html", "yaml", "javascript", "vim", "lua"},
  group = au_ftype_settings,
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softabstop = 2
    vim.bo.expandtab = true
    vim.bo.copyindent = true
    vim.wo.colorcolumn = "+1,+2,+3"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern ={"c", "cpp", "python", "sh", "bash"},
  group = au_ftype_settings,
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softabstop = 4
    vim.bo.expandtab = true
    vim.bo.copyindent = true
    vim.wo.colorcolumn = "+1,+2,+3"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  group = au_ftype_settings,
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softabstop = 4
    vim.bo.expandtab = false
    vim.bo.copyindent = true
    vim.wo.colorcolumn = "+1,+2,+3"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"markdown", "tex"},
  group = au_ftype_settings,
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softabstop = 2
    vim.bo.expandtab = true
    vim.bo.formatoptions = "tcqrn1"
    vim.wo.wrap = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"text", "txt"},
  group = au_ftype_settings,
  callback = function()
    vim.bo.autoindent = false
    vim.bo.smartindent = false
    vim.bo.formatoptions = "tcqrn1"
    vim.wo.wrap = false
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"html", "r", "rmd", "markdown", "css"},
  group = au_ftype_settings,
  callback = function() require("colorizer").attach_to_buffer(0) end,
  desc = "Activate colorizer plugin",
})

-- Airline configuration
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'distinguished'
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = '|'
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = '|'

-- nvm-R
-- Setup inside lazyvim
--let R_app = "radian"
--let R_cmd = "R"
--let R_hl_term = 0
--let R_bracketed_paste = 1"

-- vim-markdown settings
-- vim.g.vim_markdown_folding_disabled = 1
-- vim.g.vim_markdown_frontmatter = 1

-- Markdown-preview settings
-- vim.g.mkdp_auto_start = 0
-- vim.g.mkdp_open_to_the_world = 0

-- VimTeX settings
-- vim.g.vimtex_view_method = 'zathura'
-- vim.g.vimtex_compiler_method = 'latexmk'

-- Telescope
local telescope = require('telescope')
telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg', '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = '❯ ',
    selection_caret = '▶ ',
    file_ignore_patterns = { '%.git/' },
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
  },
}
telescope.load_extension('fzf')
--telescope.load_extension('vimwiki')

-- Telescope Mappings
-- Telescope & Vimwiki
local builtin  = require('telescope.builtin')
-- Keymaps (General)
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })

-- Keymaps (VimWiki)
--local vimwiki  = require('telescope').extensions.vimwiki

-- Find any file in wiki
local function wiki_root() return vim.fn.expand(vim.g.palimpsest_path .. '/wiki') end
function WikiFiles()
  builtin.find_files({
    prompt_title = 'Wiki files',
    cwd          = wiki_root(),
    find_command = { 'fd', '--type', 'f', '--extension', 'md' },
  })
end

-- Live grep inside wiki
function WikiGrep()
  builtin.live_grep({
    prompt_title = 'Search in wiki',
    cwd          = wiki_root(),
    search_dirs  = { wiki_root() },
  })
end

-- Find in vignettes only
local function vignette_root() return vim.fn.expand(vim.g.palimpsest_path .. '/vignettes') end
function VignetteFiles()
  builtin.find_files({
    prompt_title = 'Vignettes',
    cwd          = vignette_root(),
    find_command = { 'rg', '--files', '--glob', '*md' },
  })
end

-- Live grep inside raw-txt
local function source_root() return vim.fn.expand(vim.g.palimpsest_path .. '/journal/raw-txt') end
function JournalRaw()
  builtin.live_grep({
    prompt_title = 'Search in Raw txts',
    cwd          = source_root(),
    search_dirs  = { source_root() },
  })
end

local au_palimpsest_telescope = vim.api.nvim_create_augroup("palimpsest_telescope", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vimwiki",
  group = au_palimpsest_telescope,
  callback = function()
    vim.keymap.set("n", "<localleader>ff", WikiFiles, { buffer = true, silent = true, desc = "Find files (Wiki)" })
    vim.keymap.set("n", "<localleader>fg", WikiGrep, { buffer = true, silent = true, desc = "Live grep (Wiki)" })
    vim.keymap.set("n", "<localleader>fv", VignetteFiles, { buffer = true, silent = true, desc = "Find vignettes (Wiki)" })
    vim.keymap.set("n", "<localleader>fj", JournalRaw, { buffer = true, silent = true, desc = "Find source files (Wiki)" })
    vim.keymap.set(
      "n", "<leader>gs",
      function() vim.cmd({ cmd = "Git", args = { "-C", vim.g.palimpsest_path, "status" } }) end,
      { desc = "Git status of Palimpsest Repo" }
    )
  end,
})

local au_palimpsest_log = vim.api.nvim_create_augroup("palimpsest_log", { clear = true })
local function log_root() return vim.fn.expand(vim.g.palimpsest_path .. '/wiki/log') end
local function insert_palimpsest_log_template()
  local lines = {
  -- 1) Date heading
    "# " .. os.date("%Y-%m-%d"),
  -- 2) Blank line + timestamps fields
    "",
  "Started: " .. os.date('%H:%M'),
  "Finished: ",
  "",
  "---",
  "",
  -- 3) Tasks section
  "Tasks:",
  "- [ ]",
  "",
  "---",
  "",
  -- 4) Worked on section
  'Worked on:',
  "- ",
  "",
  "---",
  "",
  -- 5) Notes
  "Notes:",
  "- ",
  "",
  }
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  vim.api.nvim_win_set_cursor(0, {8, 0})  -- position cursor at first task
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vimwiki",
  group = au_palimpsest_log,
  callback = function()
    vim.keymap.set("n", "<leader>wd", "<cmd>VimwikiMakeDiaryNote<CR>", { buffer = true, desc = "Create/Open today's log (Palimpsest)" })
    vim.keymap.set("n", "<leader>wi", "<cmd>VimwikiDiaryIndex<CR>", { buffer = true, desc = "Open log index (Palimpsest)" })
    vim.keymap.set("n", "<leader>ws", "<cmd>VimwikiDiaryGenerateLinks<CR>", { buffer = true, desc = "Rebuild log index (Palimpsest)" })
  end,
})
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = log_root() .. "/*.md",
  group = au_palimpsest_log,
  callback = insert_palimpsest_log_template,
})



vim.g.palimpsest_path = HOME .. "/Documents/palimpsest"
vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_diary_index_header = "# Session Log\\n\\n"
vim.g.vimwiki_list = {
  {
    path = vim.g.palimpsest_path .. "/wiki",
    syntax = "markdown",
    ext = ".md",
    name = "Palimpsest",
    diary_rel_path = "log",
    diary_index = "index",
  }
}


-- Treesitter
require('nvim-treesitter.configs').setup {
  -- pick the parsers you actually use:
  ensure_installed = {
    "bash", "c", "comment", "cpp", "css", "csv", "diff", "dockerfile",
    "gitcommit", "gitignore", "gpg", "html", "javascript", "json", "julia",
    "latex", "lua", "make", "python", "r", "typst", "vim", "yaml"
  },
  highlight      = { enable = true  },  -- syntax via Treesitter
  indent         = { enable = true  },  -- indentation via Treesitter
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}


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

require("lazy").setup("plugins")
