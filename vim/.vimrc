" init.vim – Vim 9.0 configuration
"
" One config everywhere. Plugins and their settings live in
" ~/.vim/rc/plugins.vim, loaded only when vim-plug is installed and this is
" not an Alliance cluster ($CC_CLUSTER): compute nodes have no network and
" $HOME has a file-count quota. Everything in this file is plain vim.

let s:hpc = !empty($CC_CLUSTER)
let s:plugged = 0
let s:has_plug = filereadable(expand('~/.vim/autoload/plug.vim'))
let s:has_cfg = filereadable(expand('~/.vim/rc/plugins.vim'))
if !s:hpc && s:has_plug && s:has_cfg
  let s:plugged = 1
  source ~/.vim/rc/plugins.vim
endif

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
" gruvbox is a plugin; fall back to a built-in scheme without it.
for s:scheme in ['gruvbox', 'habamax', 'desert']
  silent! execute 'colorscheme' s:scheme
  if exists('g:colors_name') | break | endif
endfor
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
silent! call mkdir(expand('~/.vim/backup'), 'p')
silent! call mkdir(expand('~/.vim/swap'), 'p')
silent! call mkdir(expand('~/.vim/undo'), 'p')
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
  autocmd FileType text,txt   setl noai nosi fo=tcqrn1
  " Makefiles
  autocmd FileType make       setl ts=4 sw=4 sts=4 noet cc=+1,+2,+3
  " Web: HTML, JS, YAML
  autocmd FileType html       setl ts=2 sw=2 sts=2 et tw=0 fo-=t
  autocmd FileType yaml       setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  autocmd FileType javascript setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
  " Vim
  autocmd FileType vim        setl ts=2 sw=2 sts=2 et cc=+1,+2,+3
augroup END


" ===============================
" Without plugins: statusline and finder
" ===============================
if !s:plugged
  " airline's job, in one line of built-in vim
  set statusline=%<%f\ %h%m%r%=%{&filetype}\ \ %-14.(%l,%c%V%)\ %P
  " fzf.vim's job: :find over a recursive path, wildmenu does the rest
  set path+=**
  nnoremap <leader>ff :find<space>
  nnoremap <leader>fb :buffers<CR>:buffer<space>
  nnoremap <leader>fg :grep! -rn --exclude-dir=.git<space>
endif

" ===============================
" Send code to a tmux pane (stands in for Nvim-R)
" ===============================
" Open R in a second tmux pane, then send lines to it. g:tmux_target follows
" tmux's target syntax; '.+' is the next pane in the current window.
let g:tmux_target = get(g:, 'tmux_target', '.+')

function! s:TmuxSend(text) abort
  if empty($TMUX)
    echohl WarningMsg | echo 'tmux-send: not inside tmux' | echohl None
    return
  endif
  let l:t = shellescape(g:tmux_target)
  call system('tmux send-keys -t ' . l:t . ' -l ' . shellescape(a:text))
  call system('tmux send-keys -t ' . l:t . ' Enter')
endfunction

function! s:TmuxSendRange() abort
  call s:TmuxSend(join(getline(line("'<"), line("'>")), "\n"))
endfunction

" <leader>rr opens a pane running R; rl sends the line, r the visual
" selection, rf sources the file, rq quits R.
nnoremap <silent> <leader>rr :call system('tmux split-window -h -d "module load StdEnv/2023 r/4.4.0 2>/dev/null; exec R --no-save"')<CR>
nnoremap <silent> <leader>rl :call <SID>TmuxSend(getline('.'))<CR>j
vnoremap <silent> <leader>r  :<C-u>call <SID>TmuxSendRange()<CR>
nnoremap <silent> <leader>rf :call <SID>TmuxSend('source("' . expand('%:p') . '", echo = TRUE)')<CR>
nnoremap <silent> <leader>rq :call <SID>TmuxSend('q()')<CR>
