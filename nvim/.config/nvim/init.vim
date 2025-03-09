" Configuration for Neovim
" Maintained by Soffiafdz <so1.618e@gmail.com>

call plug#begin()

" Color schemes
Plug 'rafi/awesome-vim-colorschemes'

" Linting
Plug 'dense-analysis/ale'
Plug 'neomake/neomake'

" Python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'numirias/semshi'

" R
Plug 'jalvesaq/Nvim-R'

" Completion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'gaalcaras/ncm-R'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-jedi'
Plug 'jiangmiao/auto-pairs'

" Comments
Plug 'scrooloose/nerdcommenter'

" Git
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

" [tc]sv
Plug 'mechatroner/rainbow_csv'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" LaTeX
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'lervag/vimtex', { 'for': 'tex' }

" Misc
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
Plug 'Yggdroot/indentLine'
Plug 'michal-h21/vimwiki-sync'
Plug 'vim-voom/VOoM'
Plug 'mikewest/vimroom'

" CSS colorizer
Plug 'norcalli/nvim-colorizer.lua'

" Markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-rmarkdown'
Plug 'iamcco/markdown-preview.nvim',
    \ {'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
"Plug 'instant-markdown/vim-instant-markdown',
    "\ {'for': 'markdown', 'do': 'yarn install'}

call plug#end()

" Neomake config
function! OnBatt()
    if has('macunix')
        return match(system('pmset -g batt'), "Now drawing from 'Battery Power'") != -1
    elseif has('unix')
        let file = 'sys/class/power_supply/AC/online'
        if filereadable(file)
            return readfile('/sys/class/power_supply/AC/online') == ['0']
        endif
    endif
    return 0
endfunction

if OnBatt()
    call neomake#configure#automake('w')
else
    call neomake#configure#automake('nw', 750)
endif

" ncm2 config
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
set shortmess+=c
inoremap <c-c> <ESC>
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>\")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Netrw
let g:netrw_banner = 0

" NerdTree config
" autocmd StdinReadPre * let s:std_in=1
" autocmd vimenter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" nnoremap <space>n :NERDTreeToggle<CR>
" nnoremap <space>m :NERDTreeFind<CR>
" let NERDTreeShowFiles=1
" let NERDTreeShowHidden=1
" let NERDTreeQuitOnOpen=1
" let NERDTreeHighlightCursorline=1
" let NERDTreeMinimalUI=1
" let NERDTreeDirArrows=1
" let g:NERDSpaceDelims=1
" let g:NERDCompactSexyComs=1
" let g:NERDDefaultAlign='left'
" let g:NERDCommentEmptyLines=1
" let g:NERDTrimTrailingWhitespace=1

" Airline config
let g:airline_powerline_fonts=1
let g:airline_theme='distinguished'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep          = ''
let g:airline_left_alt_sep      = '|'
let g:airline_right_sep         = ''
let g:airline_right_alt_sep     = '|'

" nvm-R
nmap , <Plug>RDSendLine
vmap , <Plug>RDSendSelection
vmap ,e <Plug>RESendSelection
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_bracketed_paste = 1"

" Appearance
set t_Co=256
set termguicolors
" colorscheme happy_hacking
" colorscheme sierra
colorscheme gruvbox
set background=dark termguicolors cursorline
hi! Normal ctermbg=NONE guibg=NONE
hi! LineNr ctermbg=NONE guibg=NONE
hi! CursorLineNr ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE
lua require'colorizer'.setup()

" " Cursor in TMUX
" if exists('$TMUX')
"         let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
"         let &t_SR = "\<Esc>Ptmux;\<Esc>\e[4 q\<Esc>\\"
"         let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
" else
    let &t_SI = "\e[6 q"
    let &t_SR = "\e[4 q"
    let &t_EI = "\e[2 q"
" endif

" Leader Key
let mapleader="\<space>"

" IndentLines
let g:indentLine_setColors = 0

" Tab settings
set cindent
set tabstop=4
set shiftwidth=4
set expandtab

" Security
set nomodeline

" Format
set encoding=utf-8
set copyindent
set showmode
set showcmd
set hidden
set wildmode=list:longest
set nocursorline
set noerrorbells
set title
set ruler
set laststatus=2
set nu rnu
set relativenumber

" Search and moving
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><tab> :noh<cr>
nnoremap j gj
nnoremap k gk
"nnoremap ; :
" nnoremap i zzi
" nnoremap I zzI
" nnoremap a zza
" nnoremap A zzA
" nnoremap o zzo
" nnoremap O zzO


" Wrapping and line lenght
set wrap
set textwidth=79
set formatoptions=tcqrn1
set scrolloff=3
set colorcolumn=80

" Invisible characters
set list
set listchars=eol:¬

" Split open bottom/right
set splitbelow splitright


" Saving
au FocusLost * :wa
set undolevels=10000
set nobackup
set nowritebackup
set noswapfile

" Windows settings
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Delete trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" CSV
autocmd Filetype csv set tabstop=4 shiftwidth=4 noexpandtab formatoptions-=t

" Shell
autocmd filetype sh set tabstop=4 shiftwidth=4 noexpandtab

" R
autocmd filetype r set shiftwidth=2 tabstop=2 expandtab
autocmd filetype rmd set shiftwidth=2 tabstop=2 expandtab

" Python
autocmd filetype python set shiftwidth=4 tabstop=4 expandtab

" HTML
autocmd filetype html set shiftwidth=2 tabstop=2 expandtab formatoptions-=t
autocmd filetype htmldjango set shiftwidth=2 tabstop=2 expandtab formatoptions-=t

" Javascript
autocmd filetype javascript set shiftwidth=2 tabstop=2 expandtab

" YAML
autocmd filetype yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab

" Markdown
augroup pandoc_syntax
    autocmd fileType r setlocal shiftwidth=2 tabstop=2 expandtab
    autocmd! BufNewFile,BufFilePre,BufRead *.md
        \ set filetype=markdown wrapmargin=7
augroup END

" Fountain
autocmd BufRead, BufNewFile *.fountain set filetype=fountain

" VimWiki
augroup vimwikiGroup
    autocmd! BufNewFile,BufFilePre,BufRead *.wiki
        \ set filetype=vimwiki wrapmargin=7 tabstop=2 shiftwidth=2 expandtab
    autocmd! fileType vimwiki set syntax=markdown
    autocmd filetype vimwiki inoremap <silent><buffer> <CR>
              \ <C-]><Esc>:VimwikiReturn 3 5<CR>
    autocmd filetype vimwiki inoremap <silent><buffer> <A-CR>
              \ <Esc>:VimwikiReturn 2 2<CR>
augroup END

let g:vimwiki_global_ext = 0
let g:vimwiki_list = [
            \{},
            \{"path": "~/Vimwiki/mcgill/neur630", "name": "N630"},
            \{"path": "~/Vimwiki/mcgill/neur631", "name": "N631"},
            \{"path": "~/Vimwiki/mcgill/neur602_015", "name": "N602"},
            \{"path": "~/Vimwiki/mcgill/bmde520", "name": "B520"},
            \{"path": "~/Vimwiki/tech", "name": "Tech"},
            \{"path": "~/Vimwiki/writing", "name": "Writing"},
            \{"path": "~/Vimwiki/recipes", "name": "Recipes"}]

" LaTeX
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ]
    \}
let g:Tex_CompileRule_pdf='xelatex --interaction=nonstopmode $*'
let g:tex_flavor = "latex"
let g:livepreview_previewer = 'zathura'
let g:vimtex_view_method = 'zathura'
let g:Tex_IgnoredWarnings =
    \'Underfull'."\n".
    \'Overfull'."\n".
    \'specifier changed to'."\n".
    \'You have requested'."\n".
    \'Missing number, treated as zero.'."\n".
    \'There were undefined references'."\n".
    \'Citation %.%# undefined'."\n".
    \'Double space found.'."\n"
let g:Tex_IgnoreLevel = 8

augroup LaTeX
    au! BufNewFile,BufFilePre,BufRead *.tex  set filetype=tex
    au filetype tex setlocal shiftwidth=2 tabstop=2 expandtab
    au VimLeave *.tex !texclear %
    au filetype tex map <leader>b :vsp<space>$BIB<CR>
    " au filetype tex map <leader>W :w !detex \| wc -w<CR>
augroup END

"""HTML
augroup HTML
    au filetype html inoremap &<space> &amp;<space>
    au filetype html inoremap á &aacute;
    au filetype html inoremap é &eacute;
    au filetype html inoremap í &iacute;
    au filetype html inoremap ó &oacute;
    au filetype html inoremap ú &uacute;
    au filetype html inoremap ä &auml;
    au filetype html inoremap ë &euml;
    au filetype html inoremap ï &iuml;
    au filetype html inoremap ö &ouml;
    au filetype html inoremap ü &uuml;
    au filetype html inoremap ã &atilde;
    au filetype html inoremap ẽ &etilde;
    au filetype html inoremap ĩ &itilde;
    au filetype html inoremap õ &otilde;
    au filetype html inoremap ũ &utilde;
    au filetype html inoremap ñ &ntilde;
    au filetype html inoremap à &agrave;
    au filetype html inoremap è &egrave;
    au filetype html inoremap ì &igrave;
    au filetype html inoremap ò &ograve;
    au filetype html inoremap ù &ugrave;
augroup END
