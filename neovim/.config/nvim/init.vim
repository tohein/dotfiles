" -----------------------------------------------------------------------------
"
"                       Tobi's vim configuration
"
" -----------------------------------------------------------------------------


" ------------------------------ plug-ins -------------------------------------

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" LSP
Plug 'neovim/nvim-lspconfig'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" telescope fuzzy search
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }

" indentation lines
Plug 'lukas-reineke/indent-blankline.nvim'

" comments
Plug 'tpope/vim-commentary'

" color scheme
Plug 'rebelot/kanagawa.nvim'

" git support
Plug 'tpope/vim-fugitive'                       " vim git wrapper
Plug 'airblade/vim-gitgutter'	     	        " git diff in gutter

" file tree
Plug 'nvim-tree/nvim-tree.lua'

" statusline
Plug 'nvim-lualine/lualine.nvim'

" icons for lualine and nvim-tree
Plug 'kyazdani42/nvim-web-devicons'

" " co-pilot
" Plug 'github/copilot.vim'

call plug#end()

" ------------------------------ settings -------------------------------------

filetype plugin indent on
set encoding=utf-8

" tabs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" use relative line numbers
set number relativenumber

" delete trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" disable comment on newline
autocmd FileType * setlocal formatoptions-=cro

" command line completion
" set wildmenu
set wildmode=longest:full,full

" vim syntax highlighting for snakemake files
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" set true colors
if has("termguicolors")
    set termguicolors
endif

" highlight 80 char line
set colorcolumn=80

" ------------------------- vim / tmux split navigation------------------------

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

" ------------------------------- keymaps -------------------------------------

" show file tree
nnoremap <leader>ft <cmd>NvimTreeToggle<cr>

" find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" ----------------------------------- lua -------------------------------------

:lua << EOF
    -- Setup language servers.
    local lspconfig = require('lspconfig')
    lspconfig.pyright.setup {}

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })

    require('nvim-treesitter.configs').setup {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      highlight = {
      enable = true,
      },
    }

    -- Setup status line
    require("lualine").setup()

    -- Setup file tree
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
        git = {
            ignore = false
        },
        renderer = {
          group_empty = true,
        }
    })

    -- Setup telescope
    require("telescope").setup()

    -- Setup indentation highlights
    require("indent_blankline").setup()

    -- Customize theme
    require('kanagawa').setup({
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
        }
    })
    vim.cmd("colorscheme kanagawa")

EOF


