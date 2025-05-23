" init.vim - Neovim configuration by Soffiafdz

" ===============================
" Plugin management (vim-plug)
" ===============================

call plug#begin('~/.local/share/nvim/plugged')

" Color schemes
Plug 'rafi/awesome-vim-colorschemes'

" Linting & formatting
Plug 'dense-analysis/ale'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Python & R support
Plug 'jalvesaq/Nvim-R'
Plug 'Vimjas/vim-python-pep8-indent'
"Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

" Comments, Git, CSV
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mechatroner/rainbow_csv'

" Statusline/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Distraction-free writing
Plug 'junegunn/goyo.vim'

" Fzf
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"lug 'junegunn/fzf.vim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'ElPiloto/telescope-vimwiki.nvim'

" Vimwiki
Plug 'vimwiki/vimwiki'
Plug 'michal-h21/vimwiki-sync'

" Markdown support
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown', { 'for': ['markdown'] }
Plug 'iamcco/markdown-preview.nvim', {
  \ 'do': 'mkdp#util#install()',
  \ 'for': ['markdown']
  \ }

" LaTeX
Plug 'lervag/vimtex', { 'for': 'tex' }

" Helpers & enhancements
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

" ===============================
" Core settings
" ===============================

syntax on                             " Enable syntax highlighting
filetype plugin indent on             " Enable filetype detection and indent
let mapleader = " "

" General
set lazyredraw                        " Redraw only when needed
set synmaxcol=200                     " Limit syntax scan length
set textwidth=80                      " Text width is 80 characters
set nowrap                            " No wrap by default
set number relativenumber             " Combined line number settings
set noshowmode                        " Airline displays mode
set showcmd                           " Show incomplete commands
set ruler                             " Show cursor position
set laststatus=2                      " Always display statusline
set wildmode=list:longest             " Command-line completion
set hidden                            " Allow background buffers
set scrolloff=5 sidescrolloff=5       " Keep context around cursor
set signcolumn=yes                    " Always show signcolumn

" Appearance
set termguicolors
set background=dark
colorscheme gruvbox
"
" Transparent backgrounds
hi! Normal       ctermbg=NONE guibg=NONE
hi! LineNr       ctermbg=NONE guibg=NONE
hi! CursorLineNr ctermbg=NONE guibg=NONE
hi! NonText      ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE

" Invisible chars
set list
set listchars=tab:▸\ ,trail:·,nbsp:␣,eol:¬

" Splits: below/right
set splitbelow splitright

" Window nav
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Mouse & undo
set mouse=a
set undofile

" Search
set ignorecase smartcase incsearch hlsearch
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><tab> :noh<CR>

" Netrw
let g:netrw_banner = 0

" Trim trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Auto-save on focus lost
autocmd FocusLost * :wa

" Backup & swap in central dirs
set backupdir=~/.local/state/nvim/backup//
set directory=~/.local/state/nvim/swap//
set nobackup
set nowritebackup

" Security
set nomodeline

" Completion settings (ncm2)
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" ===============================
" Filetype-specific overrides
" ===============================

augroup FiletypeSettings
  autocmd!
  " Bash/sh: 2-space soft tabs, converted to spaces
  autocmd FileType sh,bash    setl ts=2 sw=2 sts=2 et ci cc=+1,+2,+3
  " Python: PEP8 indent
  autocmd FileType python     setl ts=4 sw=4 sts=4 et ci cc=+1,+2,+3
  " C/C++: indent
  autocmd FileType c,cpp      setl ts=4 sw=4 sts=4 et ci cc=+1,+2,+3
  " R, RMarkdown: 2-space
  autocmd FileType r          setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  autocmd FileType rmd        setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  " Text:
  autocmd FileType markdown   setl ts=2 sw=2 sts=2 et wrap fo=tcqrn1
  autocmd FileType tex        setl ts=2 sw=2 sts=2 et wrap fo=tcqrn1
  autocmd FileType text,txt   setl noai nosi nowrap fo=tcqrn1
  " Makefiles
  autocmd FileType make       setl ts=4 sw=4 sts=4 noet cc=+1,+2,+3
  " Web: HTML, JS, YAML
  autocmd FileType html       setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  autocmd FileType yaml       setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  autocmd FileType javascript setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  " Vim
  autocmd FileType vim        setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  " Colorizer
  autocmd FileType css,html,markdown lua require('colorizer').setup()
augroup END

" ===============================
" Plugin-specific settings
" ===============================

" Airline configuration
let g:airline_powerline_fonts = 1
let g:airline_theme = 'distinguished'
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep          = ''
let g:airline_left_alt_sep      = '|'
let g:airline_right_sep         = ''
let g:airline_right_alt_sep     = '|'

" nvm-R
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_bracketed_paste = 1"

" Markdown general settings
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

" Markdown-preview settings
let g:mkdp_auto_start = 0
let g:mkdp_open_to_the_world = 0

" VimTeX settings
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'

" ===============================
" Telescope
" ===============================

lua << EOF
local telescope = require('telescope')
telescope.setup{
  defaults = {
    prompt_prefix = '❯ ',
    selection_caret = '▶ ',
    file_ignore_patterns = { '%.git/' },
  },
}
telescope.load_extension('fzf')
telescope.load_extension('vimwiki')
EOF

" Mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" ===============================
" Vimwiki configuration
" ===============================

" Vimwiki configuration (use Markdown syntax)
let g:palimpsest_path = '/home/soffiafdz/Documents/palimpsest'
let g:vimwiki_list = [{
  \ 'path': expand(g:palimpsest_path . '/wiki'),
  \ 'syntax': 'markdown',
  \ 'ext': '.md',
  \ 'name': 'Palimpsest',
  \ 'diary_rel_path': 'log',
  \ 'diary_index': 'index'
  \ }]
let g:vimwiki_global_ext = 0
let g:vimwiki_diary_index_header = '# Session Log\n\n'

" VimwikiDiary (log: Palimpsest)
augroup vimwiki_diary
  autocmd!
  " <leader>wd → create/open today’s note
  autocmd FileType vimwiki nnoremap <buffer> <Leader>wd :VimwikiMakeDiaryNote<CR>
  " <leader>wi → open the diary index
  autocmd FileType vimwiki nnoremap <buffer> <Leader>wi :VimwikiDiaryIndex<CR>
  " <leader>ws → rebuild links in the index
  autocmd FileType vimwiki nnoremap <buffer> <Leader>ws :VimwikiDiaryGenerateLinks<CR>
augroup END

" Boilerplate (log: Palimpsest)
augroup vimwiki_diary_template
  autocmd!
  " When a brand-new file is created in the diary folder, insert our skeleton
  autocmd BufNewFile */wiki/log/*.md call s:InsertDiaryTemplate()
augroup END

function! s:InsertDiaryTemplate()
  " 1) Date heading
  call append(0, '# ' .. strftime('%Y-%m-%d'))
  " 2) Blank line + timestamp fields
  call append(1, '')
  call append(2, 'Started: ' . strftime('%H:%M'))
  call append(3, 'Finished: ')
  call append(4, '')
  call append(5, '---')
  call append(6, '')
  " 3) Tasks section
  call append(7, 'Tasks:')
  call append(8, '- [ ]')
  call append(9, '')
  call append(10, '---')
  call append(11, '')
  " 4) Worked on section
  call append(12, 'Worked on:')
  call append(13, '- ')
  call append(14, '')
  call append(15, '---')
  call append(16, '')
  " 5) Notes
  call append(17, 'Notes:')
  call append(18, '- ')
  call append(19, '')
  " 5) Position cursor on the first task bullet
  exec "normal! 8G"
endfunction


" Telescope
lua << EOF
local builtin  = require('telescope.builtin')
local vimwiki  = require('telescope').extensions.vimwiki

local function wiki_root()
  return vim.fn.expand(vim.g.palimpsest_path .. '/wiki')
end

local function vignette_root()
  return vim.fn.expand(vim.g.palimpsest_path .. '/vignettes')
end

local function source_root()
  return vim.fn.expand(vim.g.palimpsest_path .. '/journal/raw-txt')
end

-- Find any file in wiki
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
function VignetteFiles()
  builtin.find_files({
    prompt_title = 'Vignettes',
    cwd          = vignette_root(),
    find_command = { 'fd', '--type', 'f', '--extension', 'md' },
  })
end

-- Live grep inside raw-txt
function JournalRaw()
  builtin.live_grep({
    prompt_title = 'Search in Raw txts',
    cwd          = source_root(),
    search_dirs  = { source_root() },
  })
end
EOF

" Keymaps
augroup vimwiki_telescope
  autocmd!
  autocmd FileType vimwiki nnoremap <silent><buffer> <Leader>ff :lua WikiFiles()<CR>
  autocmd FileType vimwiki nnoremap <silent><buffer> <Leader>fg :lua WikiGrep()<CR>
  autocmd FileType vimwiki nnoremap <silent><buffer> <Leader>fv :lua VignetteFiles()<CR>
  autocmd FileType vimwiki nnoremap <silent><buffer> <Leader>fj :lua JournalRaw()<CR>
  autocmd FileType vimwiki nnoremap <Leader>gs :Git -C <C-R>=g:palimpsest_path<CR> status<CR>
augroup END

" ===============================
" Linting & formatting
" ===============================

" Ale
let g:ale_linters_explicit = 1        " Only use linters we configure
let g:ale_fix_on_save = 1             " Auto-fix on save

let g:ale_linters = {
  \  'python'    : ['flake8', 'mypy', 'pylint'],
  \  'javascript': ['eslint'],
  \  'typescript': ['eslint'],
  \  'html'      : ['tidy', 'htmlhint'],
  \  'css'       : ['stylelint'],
  \  'sh'        : ['shellcheck'],
  \  'markdown'  : ['markdownlint', 'mdl'],
  \  'r'         : ['lintr'],
  \  'yaml'      : ['yamllint'],
  \}

let g:ale_fixers = {
  \  '*'           : ['remove_trailing_lines', 'trim_whitespace'],
  \  'python'      : ['black', 'isort'],
  \  'javascript'  : ['prettier'],
  \  'typescript'  : ['prettier'],
  \  'css'         : ['prettier'],
  \  'html'        : ['prettier'],
  \  'sh'          : ['shfmt'],
  \  'rust'        : ['rustfmt'],
  \  'go'          : ['gofmt'],
  \  'r'           : ['styler'],
  \  'markdown'    : ['prettier'],
  \}

" Treesitter
lua << EOF
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
EOF

" ===============================
" Goyo implementation
" ===============================

nnoremap <Leader>zz :Goyo<CR>
let g:goyo_width  = 80
let g:goyo_height = '85%'
let g:goyo_linenr = 0

augroup GoyoIntegration
  autocmd!
  autocmd User GoyoEnter nested call s:GoyoEnterSetup()
  autocmd User GoyoLeave nested call s:GoyoLeaveSetup()
augroup END

function! s:GoyoEnterSetup()
  " 1) Hide TMUX, Airline status AND tabline
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  silent! AirlineDisable
  let g:airline#extensions#tabline#enabled = 0
  set showtabline=0

  " 2) Disable linting, indent guides, and colorizer
  let b:ale_enabled        = 0
  let b:indentLine_enabled = 0
  silent! IndentLinesDisable
  exec 'ColorizerDetachFromBuffer'

  " 3) Hide all columns and signs
  setlocal signcolumn=no
  setlocal colorcolumn=

  " 4) Re-apply transparency in all Goyo panes
  hi! Normal       ctermbg=NONE guibg=NONE
  hi! LineNr       ctermbg=NONE guibg=NONE
  hi! CursorLineNr ctermbg=NONE guibg=NONE
  hi! NonText      ctermbg=NONE guibg=NONE ctermfg=NONE

  " 5) Simplify buffer options
  setlocal nowrap textwidth=0 nolist nospell listchars=
  setlocal nocursorline
  setlocal conceallevel=0 concealcursor=
  setlocal foldmethod=manual nofoldenable
endfunction

function! s:GoyoLeaveSetup()
  " 1) Restore TMUX, Airline and tabline
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  silent! AirlineEnable
  let g:airline#extensions#tabline#enabled = 1
  set showtabline=2

  " 2) Re-enable linting, indent guides, and colorizer
  let b:ale_enabled        = 1
  silent! IndentLinesEnable
  let b:indentLine_enabled = 1
  exec 'ColorizerAttachToBuffer'

  " 3) Restore signs and guide
  setlocal signcolumn=yes
  setlocal colorcolumn=80

  " 4) Keep transparency
  hi! Normal       ctermbg=NONE guibg=NONE
  hi! LineNr       ctermbg=NONE guibg=NONE
  hi! CursorLineNr ctermbg=NONE guibg=NONE
  hi! NonText      ctermbg=NONE guibg=NONE ctermfg=NONE

  " 5) Restore prose editing UI
  setlocal wrap textwidth=80 formatoptions=tcqrn1
  setlocal list listchars=tab:▸\ ,trail:·,nbsp:␣,eol:¬
  setlocal spell cursorline
  setlocal foldmethod=indent foldenable
endfunction

" ===============================
" Performance guard (large MD)
" ===============================

function! s:MarkdownPerformance()
  if line('$') > 10000
    let b:ale_enabled = 0                       " Disable ALE linting
    let b:indentLine_enabled = 0                " Disable indent guides
    setlocal laststatus=0                       " Hide statusline/Airline
    setlocal nocursorline                       " Disable cursorline
    setlocal nospell                            " Turn off spell-check
    setlocal conceallevel=0 concealcursor=      " Disable conceal
    setlocal foldmethod=manual nofoldenable     " Disable folding
    setlocal synmaxcol=200                      " Restrict syntax scanning
  endif
endfunction
autocmd BufReadPost *.md call s:MarkdownPerformance()
