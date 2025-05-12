" init.vim – Vim 9.0 configuration

" ===============================
" Plugin management (vim-plug)
" ===============================
call plug#begin('~/.vim/plugged')

" Color schemes
Plug 'rafi/awesome-vim-colorschemes'

" Linting & formatting
 Plug 'dense-analysis/ale'

" Python & R support
Plug 'jalvesaq/Nvim-R'
Plug 'Vimjas/vim-python-pep8-indent'

" Comments, Git, CSV
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mechatroner/rainbow_csv'

" Statusline/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" FZF fuzzy finder + Vim wrapper
 Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
 Plug 'junegunn/fzf.vim'

" Distraction-free writing
Plug 'junegunn/goyo.vim'

" Markdown support
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

" Vimwiki
Plug 'vimwiki/vimwiki'

call plug#end()

" ===============================
" Core settings
" ===============================
syntax on
filetype plugin indent on
let mapleader = " "

" Appearance
set t_Co=256
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

" Performance & usability
set lazyredraw
set synmaxcol=200
set updatetime=300
set timeoutlen=500
set hidden
set scrolloff=5 sidescrolloff=5
set signcolumn=yes

" Display
set number relativenumber
set noshowmode
set showcmd
set ruler
set laststatus=2

" Clipboard & mouse
set clipboard+=unnamedplus
set mouse=a
"
" Backup, swap & undo
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile
set undodir=~/.vim/undo//
autocmd FocusLost * :wa

" Trim trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Wrapping & textwidth
set nowrap
set textwidth=80
"
"" Completion
set wildmenu
set wildmode=list:longest
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" ===============================
" Filetype-specific overrides
" ===============================
augroup FiletypeSettings
  autocmd!
  " Bash/sh: 2-space soft tabs, converted to spaces
  autocmd FileType sh,bash    setl ts=2 sw=2 sts=2 et
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

" Markdown-preview settings
let g:mkdp_auto_start = 0
let g:mkdp_open_to_the_world = 0

" VimTeX settings
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'

"" ===============================
" FZF mappings
" ===============================
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :GFiles?<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fh :Helptags<CR>

" ===============================
" Vimwiki configuration
" ===============================
let g:vimwiki_list = [{
    \ 'path': '~/Documents/palimpsest/wiki',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'name': 'Palimpsest',
    \}]
let g:vimwiki_ext2syntax = {'.md': 'markdown'}

" ===============================
" ALE settings
" ===============================
let g:ale_linters_explicit = 1
let g:ale_fix_on_save     = 1
let g:ale_linters = {
    \  'python'     : ['flake8','mypy','pylint'],
    \  'javascript' : ['eslint'],
    \  'html'       : ['tidy','htmlhint'],
    \  'css'        : ['stylelint'],
    \  'sh'         : ['shellcheck'],
    \  'markdown'   : ['markdownlint','mdl'],
    \  'r'          : ['lintr'],
    \}
let g:ale_fixers = {
    \  '*'          : ['remove_trailing_lines','trim_whitespace'],
    \  'python'     : ['black','isort'],
    \  'javascript' : ['prettier'],
    \  'css'        : ['prettier'],
    \  'markdown'   : ['prettier'],
    \  'r'          : ['styler'],
    \}

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

