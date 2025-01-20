" -----------------------------------------------------------------------------
"
"                       Tobi's neovim configuration.
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

" Color scheme.
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'       		        " commenting feature
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

if exists('$TMUX')
    function! TmuxOrSplitSwitch(wincmd, tmuxdir)
        let previous_winnr = winnr()
        silent! execute "wincmd " . a:wincmd
        if previous_winnr == winnr()
            call system("tmux select-pane -" . a:tmuxdir)
            redraw!
        endif
    endfunction

    let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
    let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
    let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

    nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
    nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
    nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
    nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l
endif

nnoremap <leader>ft <cmd>NERDTreeToggle<cr>


" powerline shine
let g:airline_powerline_fonts = 1
