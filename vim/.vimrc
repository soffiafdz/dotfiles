" ~/.vimrc — the editor on Alliance clusters, the fallback everywhere else.
"
" Derived from the nvim config in this repo (nvim/.config/nvim): same leader,
" same trilingual spell setup, same prose autosave, same R-in-tmux workflow.
" Deliberately plugin-free — cluster compute nodes have no network and $HOME
" has a file-count quota — so anything LazyVim gets from a plugin is either
" rebuilt here in plain vim or left out.

set nocompatible
filetype plugin indent on
syntax enable

" LazyVim's leaders
let mapleader = " "
let maplocalleader = "\\"

" ===============================
" Options (LazyVim defaults, ported)
" ===============================
set number relativenumber
set expandtab shiftwidth=2 tabstop=2 softtabstop=2 shiftround smarttab
set autoindent smartindent
set ignorecase smartcase incsearch hlsearch
set splitbelow splitright
set scrolloff=4 sidescrolloff=8
set signcolumn=yes
set nowrap linebreak breakindent
set cursorline
set confirm hidden autoread
set updatetime=200 timeoutlen=300 ttimeoutlen=10
set completeopt=menu,menuone,noselect
set shortmess+=c
set wildmenu wildmode=longest:full,full
set wildignore+=*.o,*.pyc,*.so,.git/*,node_modules/*
set list listchars=tab:▸\ ,trail:·,nbsp:␣,extends:›,precedes:‹
set laststatus=2 showcmd noshowmode ruler
set encoding=utf-8
set fileformats=unix,dos
set history=1000
set nojoinspaces
set virtualedit=block
set formatoptions=jcroqlnt
set textwidth=80
set synmaxcol=300 lazyredraw
set mouse=a

" Trilingual prose: a word valid in any of these is accepted, which is what
" makes spell checking usable across en/es/fr. Matches nvim's spelllang.
set spelllang=en,es,fr

if has('termguicolors') && $TERM !=# 'linux'
  set termguicolors
endif
set background=dark

" gruvbox is a plugin here; fall back to whatever this vim ships.
for s:scheme in ['gruvbox', 'habamax', 'desert']
  silent! execute 'colorscheme' s:scheme
  if exists('g:colors_name') | break | endif
endfor

if has('clipboard')
  set clipboard^=unnamed,unnamedplus
endif

" ===============================
" Backup, swap, undo
" ===============================
for s:dir in ['backup', 'swap', 'undo']
  silent! call mkdir(expand('~/.vim/' . s:dir), 'p', 0700)
endfor
set backup backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile undodir=~/.vim/undo//

" ===============================
" Statusline (lualine's job, in one line)
" ===============================
set statusline=%<%f\ %h%m%r%=%{&spelllang}\ \ %{&filetype}\ \ %-12.(%l:%c%V%)\ %P

" ===============================
" Keymaps (LazyVim parity)
" ===============================
" Windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>- <C-w>s
nnoremap <leader><bar> <C-w>v

" Buffers
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bb :buffer #<CR>

" Save and quit
nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>
nnoremap <leader>qq :qall<CR>

" Clear search with <esc>, keep matches centred
nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap n nzzzv
nnoremap N Nzzzv

" Move lines, as LazyVim's <A-j>/<A-k>
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Keep the selection when indenting
vnoremap < <gv
vnoremap > >gv

" Toggles, LazyVim's <leader>u prefix
nnoremap <leader>us :setlocal spell!<CR>:setlocal spell?<CR>
nnoremap <leader>uw :setlocal wrap!<CR>:setlocal wrap?<CR>
nnoremap <leader>ul :setlocal list!<CR>:setlocal list?<CR>
nnoremap <leader>un :setlocal relativenumber!<CR>

" Finding things (fzf-lua's job): :find walks path+=**, wildmenu completes
set path+=**
nnoremap <leader>ff :find<space>
nnoremap <leader>fb :buffers<CR>:buffer<space>
nnoremap <leader>fg :grep! -rn --exclude-dir=.git<space>
nnoremap <leader>fr :browse oldfiles<CR>

" Comment toggle (mini.comment's job) using each filetype's commentstring
function! s:ToggleComment(line1, line2) abort
  if empty(&commentstring) || &commentstring !~# '%s'
    echohl WarningMsg | echo 'no commentstring for ' . &filetype | echohl None
    return
  endif
  " Split "# %s" or "<!--%s-->" into a leader and (for paired syntaxes) a
  " tail, each without surrounding whitespace of its own.
  let l:lead = substitute(matchstr(&commentstring, '^.\{-}\ze%s'), '\s*$', '', '')
  let l:tail = substitute(matchstr(&commentstring, '%s\zs.*$'), '^\s*', '', '')
  " \1 keeps the line's indent, which must survive uncommenting.
  let l:lpat = '^\(\s*\)' . escape(l:lead, '\/*.$^~[]') . '\s\?'
  let l:tpat = empty(l:tail) ? '' : '\s\?' . escape(l:tail, '\/*.$^~[]') . '\s*$'

  " Commented only if every non-blank line in the range is.
  let l:commented = 1
  for l:n in range(a:line1, a:line2)
    let l:t = getline(l:n)
    if l:t =~# '\S' && l:t !~# l:lpat
      let l:commented = 0
      break
    endif
  endfor

  for l:n in range(a:line1, a:line2)
    let l:t = getline(l:n)
    if l:t !~# '\S' | continue | endif
    if l:commented
      let l:t = substitute(l:t, l:lpat, '\1', '')
      if !empty(l:tpat) | let l:t = substitute(l:t, l:tpat, '', '') | endif
    else
      let l:indent = matchstr(l:t, '^\s*')
      let l:t = l:indent . l:lead . ' ' . strpart(l:t, len(l:indent))
            \ . (empty(l:tail) ? '' : ' ' . l:tail)
    endif
    call setline(l:n, l:t)
  endfor
endfunction
command! -range Comment call s:ToggleComment(<line1>, <line2>)
nnoremap <silent> gcc :Comment<CR>
vnoremap <silent> gc :Comment<CR>

" ===============================
" Filetypes
" ===============================
augroup FiletypeSettings
  autocmd!
  autocmd FileType sh,bash,zsh    setl ts=2 sw=2 sts=2 et
  autocmd FileType python         setl ts=4 sw=4 sts=4 et cc=+1
  autocmd FileType c,cpp          setl ts=4 sw=4 sts=4 et cc=+1
  autocmd FileType r,rmd,quarto   setl ts=2 sw=2 sts=2 et cc=+1
  autocmd FileType make           setl ts=4 sw=4 sts=4 noet
  autocmd FileType yaml,json,toml setl ts=2 sw=2 sts=2 et
  autocmd FileType vim,lua        setl ts=2 sw=2 sts=2 et
  " Prose: wrap, spell, no column ruler
  autocmd FileType markdown,tex,text,mail setl wrap spell cc= fo=tcqrn1 tw=0
  " Slurm scripts are shell
  autocmd BufRead,BufNewFile *.sbatch,*.slurm setf sh
  " Quarto/Rmd
  autocmd BufRead,BufNewFile *.qmd setf markdown
augroup END

" Jump back to the last position, and trim trailing whitespace on write
augroup Editing
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \ | execute "normal! g`\"" | endif
  autocmd BufWritePre * let b:winview = winsaveview() |
        \ keeppatterns %s/\s\+$//e |
        \ call winrestview(b:winview)
augroup END

" ===============================
" Prose autosave (from nvim's autocmds.lua)
" ===============================
" Long writing sessions should never lose work. Real, writable files only.
augroup ProseAutosave
  autocmd!
  autocmd FocusLost,BufLeave,InsertLeave,CursorHold *
        \ if &modified && &buftype ==# '' && !&readonly
        \     && filereadable(expand('%:p'))
        \     && index(['markdown', 'text', 'tex', 'quarto', 'vimwiki'], &filetype) >= 0
        \ | silent! noautocmd update | endif
augroup END

" ===============================
" R in a tmux pane (R.nvim's job)
" ===============================
" R.nvim runs radian in `tmux split-window -hf`; same here, with the same
" localleader mappings, so the muscle memory carries over. On a cluster, load
" the R module first (`loadr`) or let the split do it.
" Which R to run is decided inside the new pane, not here: a tmux pane starts
" from the tmux server's environment, so a module loaded in this shell is not
" there, and radian may live in a venv that is not active yet.
" $STDENV/$R_MODULE come from ~/.config/hpc/modules via the shell; the
" fallback loads the cluster's default R. Override with g:r_module in
" ~/.vimrc.local if needed.
let g:r_module = get(g:, 'r_module',
      \ (empty($STDENV) ? 'StdEnv/2023' : $STDENV) . ' '
      \ . (empty($R_MODULE) ? 'r' : $R_MODULE))
let g:r_tmux_target = get(g:, 'r_tmux_target', '.+')

function! s:RSend(text) abort
  if empty($TMUX)
    echohl WarningMsg | echo 'R: not inside tmux' | echohl None
    return
  endif
  let l:t = shellescape(g:r_tmux_target)
  call system('tmux send-keys -t ' . l:t . ' -l ' . shellescape(a:text))
  call system('tmux send-keys -t ' . l:t . ' Enter')
endfunction

" The command the R pane runs: load the module on a cluster, then prefer
" radian over plain R, whichever is on $PATH by then.
function! s:RCommand() abort
  let l:run = 'if command -v radian >/dev/null 2>&1; then exec radian; '
        \ . 'else exec R --no-save; fi'
  if !empty($CC_CLUSTER)
    let l:run = 'module load ' . g:r_module . ' >/dev/null 2>&1; ' . l:run
  endif
  let l:sh = empty($SHELL) ? '/bin/sh' : $SHELL
  return shellescape(l:sh) . ' -lc ' . shellescape(l:run)
endfunction
command! Rcmd echo s:RCommand()

function! s:RStart() abort
  if empty($TMUX)
    echohl WarningMsg | echo 'R: not inside tmux' | echohl None
    return
  endif
  call system('tmux split-window -hf -d ' . shellescape(s:RCommand()))
endfunction

function! s:RSendRange() abort
  call s:RSend(join(getline(line("'<"), line("'>")), "\n"))
endfunction

nnoremap <silent> <localleader>rf :call <SID>RStart()<CR>
nnoremap <silent> <localleader>rq :call <SID>RSend('quit(save = "no")')<CR>
nnoremap <silent> <localleader>l  :call <SID>RSend(getline('.'))<CR>j
vnoremap <silent> <localleader>ss :<C-u>call <SID>RSendRange()<CR>
nnoremap <silent> <localleader>aa :call <SID>RSend('source("' . expand('%:p') . '", echo = TRUE)')<CR>
nnoremap <silent> <localleader>ro :call <SID>RSend('ls.str()')<CR>

" ===============================
" Machine-local overrides
" ===============================
" Never tracked, same idea as git's config.local and kitty's local.conf.
" Useful for g:r_module (the cluster's R version), g:r_tmux_target, or a
" colorscheme this machine happens to have.
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
