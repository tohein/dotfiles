" -----------------------------------------------------------------------------
"
"                          Tobi's vim configuration.
"
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" Plugin manager.
" -----------------------------------------------------------------------------

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
      silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

call plug#begin()

 " Tmux navigation.
Plug 'christoomey/vim-tmux-navigator'
" Color scheme.
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'       		        " Commenting feature.
" Git support.
Plug 'tpope/vim-fugitive'                       " Vim git wrapper.
Plug 'airblade/vim-gitgutter'	     	        " Git diff in gutter.
" Statusbar.
Plug 'vim-airline/vim-airline'
" File tree.
Plug 'scrooloose/nerdtree'

call plug#end()

" -----------------------------------------------------------------------------
" General settings.
" -----------------------------------------------------------------------------

" Filetype detection to set syntax highlightning, indenting etc.
filetype plugin indent on

set nocompatible
set encoding=utf-8

" Tabs to spaces.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Cursor settings.
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" Use relative line numbers.
set number relativenumber

" Delete trailing whitespaces on save.
autocmd BufWritePre * %s/\s\+$//e

" Disable comment on newline.
autocmd FileType * setlocal formatoptions-=cro

" Command line completion.
set wildmenu
set wildmode=longest:full,full

" Syntax highlightning.
syntax enable

" Vim syntax highlighting for snakemake files.
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" Colorscheme.
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" Highlight 88 char line.
set colorcolumn=88

" Always use system clipboard.
set clipboard^=unnamed,unnamedplus


" -----------------------------------------------------------------------------
" Mappings.
" -----------------------------------------------------------------------------

nnoremap <leader>ft <cmd>NERDTreeToggle<cr>

" powerline shine
let g:airline_powerline_fonts = 1
