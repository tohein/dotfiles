" ----------------------------------------------------------------------
"
"                       Tobi's vim configuration
"
" ----------------------------------------------------------------------


" ------------------------------ plug-ins ------------------------------

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" color scheme
Plug 'morhetz/gruvbox'
Plug 'nvim-lua/plenary.nvim'                    " lua functions
Plug 'nvim-tree/nvim-tree.lua'                  " file tree
Plug 'lukas-reineke/indent-blankline.nvim'      " indentation lines
Plug 'tpope/vim-commentary'       		        " commenting feature
" statusline
Plug 'nvim-lualine/lualine.nvim'                " fast statusline
Plug 'kyazdani42/nvim-web-devicons'             " icons for statusline
" git
Plug 'tpope/vim-fugitive'                       " vim git wrapper
" Plug 'sindrets/diffview.nvim'                   " view diff gits
Plug 'airblade/vim-gitgutter'	     	        " git diff in gutter
" telescope fuzzy search
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" ------------------------------ settings ------------------------------

" filetype detection to set syntax highlightning, indenting etc
filetype plugin indent on

set nocompatible
set encoding=utf-8

" use relative line numbers
set number relativenumber

" find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" delete trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" disable comment on newline
autocmd FileType * setlocal formatoptions-=cro

" command line completion
set wildmenu
set wildmode=longest:full,full

" syntax highlightning
syntax enable

" vim syntax highlighting for snakemake files
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" colorscheme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" highlight 80 char line
set colorcolumn=80

" tabs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

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

lua << END
require('lualine').setup()
require("nvim-tree").setup {
    open_on_setup = true
}
END
