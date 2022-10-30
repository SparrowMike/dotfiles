" Options
syntax on
filetype plugin indent on

set clipboard=unnamedplus " Enables the clipboard between Vim/Neovim and other applications.
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.
set hidden " Hide unused buffers
set autoindent
set inccommand=split " Show replacements in a split screen
set mouse=a
set number
set relativenumber
" set splitbelow splitright " Change the split screen behavior
set title " Show file title
set wildmenu " Show a more advance menu
" set cc=80
set spell" enable spell check (may need to download language package)
set ttyfast " Speed up scrolling in Vim 

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'morhetz/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'

call plug#end()

colorscheme gruvbox
autocmd VimEnter * hi Normal ctermbg=none
highlight Comment cterm=italic


let g:bargreybars_auto=0
let g:airline_solorized_bg='dark'
let g:airline_powerline_fonts=1
let g:airline#extension#tabline#enable=1
let g:airline#extension#tabline#left_sep=' '
let g:airline#extension#tabline#left_alt_sep='|'
let g:airline#extension#tabline#formatter='unique_tail'
let NERDTreeQuitOnOpen=1

" ===key mapping===
noremap <space> :
nnoremap nb :NERDTreeToggle<CR>
