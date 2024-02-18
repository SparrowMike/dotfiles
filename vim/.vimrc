"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               

" " Disable compatibility with vi which can cause unexpected issues.
" set nocompatible

" " Enable type file detection. Vim will be able to try to detect the type of file is use.
" filetype on

" " Enable plugins and load plugin for the detected file type.
" filetype plugin on

" " Load an indent file for the detected file type.
" filetype indent on

" syntax on


" set number
" set shiftwidth=2
" set tabstop=2
" set expandtab
" set nobackup
" set scrolloff=10
" set wrap 
" set incsearch
" set ignorecase
" set smartcase
" set showcmd
" set showmode
" set showmatch
" set hlsearch
" set history=1000
" set wildmenu
" set wildmode=list:longest
" set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
" set relativenumber
" set backspace=indent,eol,start
" set mouse=a
" set encoding=UTF-8
" set noswapfile


" " PLUGINS ---------------------------------------------------------------- {{{

" call plug#begin('~/.vim/plugged')

" Plug 'morhetz/gruvbox'
" Plug 'haishanh/night-owl.vim'
" Plug 'tomasr/molokai'
" Plug 'dracula/vim', { 'as': 'dracula' }

" Plug 'preservim/nerdtree'
" Plug 'dense-analysis/ale'
" Plug 'git@github.com:Valloric/YouCompleteMe.git'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" " Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" Plug 'ryanoasis/vim-devicons'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'sedm0784/vim-you-autocorrect'

" call plug#end()

" set t_Co=256

" if (has("termguicolors"))
"  set termguicolors
" endif

" colorscheme gruvbox

" highlight Comment cterm=italic

" " }}}

" " MAPPINGS --------------------------------------------------------------- {{{
" " Type jj to exit insert mode quickly.
" " nnoremap jj <Esc>
" imap jj <Esc>

" nnoremap <space> :
" nnoremap o o<esc>
" nnoremap O O<esc>

" " Center the cursor vertically when moving to the next word during a search.
" nnoremap n nzz
" nnoremap N Nzz

" nnoremap Y y$

" " nnoremap b :NERDTreeToggle<CR>
" nnoremap nb :NERDTreeToggle<CR>

" " Have nerdtree ignore certain files and directories.
" let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']
" let g:airline_powerline_fonts = 1
" let NERDTreeShowHidden=1
" let g:NERDTreeWinSize=37
" let g:NERDTreeGitStatusWithFlags = 1
" " let g:NERDTreeWinPos = "right"

" " sync open file with NERDTree
" " Check if NERDTree is open or active
" function! IsNERDTreeOpen()        
"   return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction"


" highlight Normal     ctermbg=NONE guibg=NONE
" highlight LineNr     ctermbg=NONE guibg=NONE
" highlight SignColumn ctermbg=NONE guibg=NONE

" " }}}

" " coc config
" let g:coc_global_extensions = [
"   \ 'coc-snippets',
"   \ 'coc-pairs',
"   \ 'coc-eslint', 
"   \ 'coc-prettier', 
"   \ 'coc-json', 
"   \ 'coc-html',
"   \ 'coc-css',
"   \ ]
" " if hidden not set, TextEdit might fail.
" set hidden
