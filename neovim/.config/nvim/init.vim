"
" tobi's vim configuration
"

" ----- plug-ins -----

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'PotatoesMaster/i3-vim-syntax'	    " syntax highlighting for i3 config
Plug 'morhetz/gruvbox'                  " gruvbox color scheme
Plug 'scrooloose/nerdtree'		        " file browser
Plug 'Xuyuanp/nerdtree-git-plugin'	    " nerdtree git integration
Plug 'airblade/vim-gitgutter'	     	" show changes in gutter
Plug 'tpope/vim-commentary'       		" commenting feature
Plug 'vim-airline/vim-airline'    		" statusbar
Plug 'tpope/vim-fugitive'               " vim git wrapper
call plug#end()

" ----- settings -----

filetype plugin indent on
set nocompatible
set encoding=utf-8
set number relativenumber		        " show relative numbers for all but current line

" delete trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" disable comment on newline
autocmd FileType * setlocal formatoptions-=cro

" cmd completion
set wildmenu				            " enable wildmenu
set wildmode=longest,list,full	        " completion mode for wildmenu

" colors scheme & highlighting
syntax enable
set background=dark
colorscheme gruvbox

let g:airline_powerline_fonts = 1       " powerline shine

"set cursorcolumn			            " highlight cursor to detect indentation
"set cursorline
set colorcolumn=80			            " highlight 80 character line

" vim syntax highlighting for snakemake files
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" tabs to spaces
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

" open nerdtree on startup if no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" vim / tmux split navigation
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

