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
set updatetime=200 timeoutlen=1000 ttimeoutlen=10
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
" The es/fr .spl files ship in vim/.vim/spell/; en is built into vim. Ask only
" for the ones actually present, otherwise vim warns once per prose buffer -
" which is what happens on the clusters when only ~/.vimrc has been copied.
let s:langs = ['en']
for s:lang in ['es', 'fr']
  if !empty(globpath(&runtimepath, 'spell/' . s:lang . '.utf-8.spl'))
    call add(s:langs, s:lang)
  endif
endfor
let &spelllang = join(s:langs, ',')
unlet s:langs s:lang

" Cursor shape per mode: bar in insert, underline in replace, block otherwise.
" Vim only does this on its own for terminals whose terminfo carries Ss/Se, and
" tmux-256color does not, so inside tmux the cursor stays a block. Send the
" DECSCUSR codes by hand; tmux forwards them once the outer terminal declares
" the cstyle feature (see tmux.conf.local). The linux console has no DECSCUSR.
if $TERM !=# 'linux'
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
  " Leave a block behind on exit rather than whatever mode vim quit from.
  let &t_te = &t_te . "\<Esc>[2 q"
endif

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
  " Delimited data; recent vims detect these already
  autocmd BufRead,BufNewFile *.csv setf csv
  autocmd BufRead,BufNewFile *.tsv setf tsv
augroup END

" ===============================
" CSV/TSV columns (rainbow_csv's job)
" ===============================
" Vim 9.1 colours each column itself (syntax/csv.vim). The clusters' vims may
" predate that, so when no runtime syntax claimed the buffer, rebuild it here
" in legacy script: nine groups chained by nextgroup, one per column, cycling;
" the esc* regions keep a quoted field with delimiters inside as one column.
function! s:CsvSyntax(delimiter) abort
  let l:d = get(b:, 'csv_delimiter', a:delimiter)
  for l:col in range(8, 0, -1)
    let l:next = l:col == 8 ? 0 : l:col + 1
    let l:nextgroup = ' nextgroup=escCsvCol' . l:next . ',csvCol' . l:next
    execute 'syntax match csvCol' . l:col . ' /.\{-}\(' . l:d . '\|$\)/' . l:nextgroup
    execute 'syntax region escCsvCol' . l:col
          \ . ' start=/ *"\([^"]*""\)*[^"]*/ end=/" *\(' . l:d . '\|$\)/' . l:nextgroup
  endfor
  let l:links = ['Statement', 'Constant', 'Type', 'PreProc', 'Identifier',
        \ 'Special', 'String', 'Comment']
  for l:i in range(1, 8)
    execute 'highlight default link csvCol' . l:i . ' ' . l:links[l:i - 1]
    execute 'highlight default link escCsvCol' . l:i . ' csvCol' . l:i
  endfor
  let b:current_syntax = &syntax
endfunction

augroup CsvColumns
  autocmd!
  " Runs after the runtime's own Syntax handler, which sets b:current_syntax
  " when it had something for this filetype.
  autocmd Syntax csv if !exists('b:current_syntax') | call s:CsvSyntax(',') | endif
  autocmd Syntax tsv if !exists('b:current_syntax') | call s:CsvSyntax('\t') | endif
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
    echohl WarningMsg | echomsg 'R: not inside tmux' | echohl None
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
    echohl WarningMsg | echomsg 'R: not inside tmux' | echohl None
    return
  endif
  call system('tmux split-window -hf -d ' . shellescape(s:RCommand()))
endfunction

function! s:RSendRange() abort
  call s:RSend(join(getline(line("'<"), line("'>")), "\n"))
endfunction

nnoremap <localleader>rf :call <SID>RStart()<CR>
nnoremap <localleader>rq :call <SID>RSend('quit(save = "no")')<CR>
nnoremap <localleader>l  :call <SID>RSend(getline('.'))<CR>j
vnoremap <localleader>ss :<C-u>call <SID>RSendRange()<CR>
nnoremap <localleader>aa :call <SID>RSend('source("' . expand('%:p') . '", echo = TRUE)')<CR>
nnoremap <localleader>ro :call <SID>RSend('ls.str()')<CR>

" Send the paragraph (blank-line delimited block) around the cursor, and the
" fenced chunk around it in Rmd/qmd.
function! s:RSendParagraph() abort
  let l:start = search('^\s*$', 'bnW') + 1
  let l:end = search('^\s*$', 'nW')
  let l:end = l:end == 0 ? line('$') : l:end - 1
  call s:RSend(join(getline(l:start, l:end), "\n"))
endfunction

function! s:RSendChunk() abort
  let l:start = search('^\s*```\s*{', 'bnW')
  if l:start == 0
    echohl WarningMsg | echomsg 'R: not inside a chunk' | echohl None
    return
  endif
  let l:end = search('^\s*```\s*$', 'nW')
  if l:end == 0 || l:end <= l:start
    echohl WarningMsg | echomsg 'R: chunk is not closed' | echohl None
    return
  endif
  call s:RSend(join(getline(l:start + 1, l:end - 1), "\n"))
endfunction

" Inspect whatever is under the cursor.
function! s:RInspect(fmt) abort
  let l:word = expand('<cword>')
  if empty(l:word)
    return
  endif
  call s:RSend(printf(a:fmt, l:word))
endfunction

nnoremap <localleader>pp :call <SID>RSendParagraph()<CR>
nnoremap <localleader>cc :call <SID>RSendChunk()<CR>

nnoremap <localleader>rt :call <SID>RInspect('str(%s)')<CR>
nnoremap <localleader>rs :call <SID>RInspect('summary(%s)')<CR>
nnoremap <localleader>rn :call <SID>RInspect('names(%s)')<CR>
nnoremap <localleader>rd :call <SID>RInspect('dim(%s)')<CR>
nnoremap <localleader>rv :call <SID>RInspect('head(%s, 20)')<CR>
nnoremap <localleader>rh :call <SID>RInspect('help(%s)')<CR>
nnoremap <localleader>rp :call <SID>RInspect('print(%s)')<CR>

" Interrupt a running command, and point R at this file's directory.
nnoremap <localleader>ri :call system('tmux send-keys -t ' . shellescape(g:r_tmux_target) . ' C-c')<CR>
nnoremap <localleader>rw :call <SID>RSend('setwd("' . expand('%:p:h') . '")')<CR>

" ===============================
" Machine-local overrides
" ===============================
" Never tracked, same idea as git's config.local and kitty's local.conf.
" Useful for g:r_module (the cluster's R version), g:r_tmux_target, or a
" colorscheme this machine happens to have.
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
