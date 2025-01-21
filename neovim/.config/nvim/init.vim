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

Plug 'neovim/nvim-lspconfig'                    " LSP client.

" Treesitter.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope fuzzy search.
Plug 'nvim-lua/plenary.nvim'                    " Dependency for telescope.
Plug 'nvim-telescope/telescope.nvim' , { 'tag': '0.1.8' }

" Code completion.
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Snippets.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'christoomey/vim-tmux-navigator'           " Navigate between vim and tmux panes.
Plug 'lukas-reineke/indent-blankline.nvim'      " Indentation lines.
Plug 'tpope/vim-commentary'                     " Commenting.
Plug 'tpope/vim-fugitive'                       " Vim git wrapper.
Plug 'airblade/vim-gitgutter'	     	        " Git diff in gutter.
Plug 'nvim-tree/nvim-tree.lua'                  " File tree.
Plug 'EdenEast/nightfox.nvim'                   " Color scheme.
Plug 'nvim-lualine/lualine.nvim'                " Statusline.
Plug 'kyazdani42/nvim-web-devicons'             " Icons for lualine and nvim-tree.
Plug 'github/copilot.vim'                       " GitHub Copilot.

call plug#end()

" -----------------------------------------------------------------------------
" General settings.
" -----------------------------------------------------------------------------

set encoding=utf-8

" Tabs to spaces.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Show line numbers (absolute at position and relative elsewhere).
set number relativenumber

" Command line completion.
set wildmode=longest:full,full

" Highlight 88 character line.
set colorcolumn=88

" Set true colors if available.
if has("termguicolors")
    set termguicolors
endif

" Set colorscheme.
colorscheme carbonfox

" Always use system clipboard.
set clipboard^=unnamed,unnamedplus

" Delete trailing whitespaces on save.
autocmd BufWritePre * %s/\s\+$//e

" Disable comment on newline.
autocmd FileType * setlocal formatoptions-=cro

" Vim syntax highlighting for snakemake files.
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" -----------------------------------------------------------------------------
" Lua plugin setup.
" -----------------------------------------------------------------------------

lua require('config')
