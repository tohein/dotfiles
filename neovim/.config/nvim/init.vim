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

" LSP.
Plug 'neovim/nvim-lspconfig'
" Treesitter.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Telescope fuzzy search.
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' , { 'tag': '0.1.4' }
" Code completion.
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Snippets.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
" Indentation lines.
Plug 'lukas-reineke/indent-blankline.nvim'
" Comments.
Plug 'tpope/vim-commentary'
" Git support.
Plug 'tpope/vim-fugitive'                       " Vim git wrapper.
Plug 'airblade/vim-gitgutter'	     	        " Git diff in gutter.
" File tree.
Plug 'nvim-tree/nvim-tree.lua'
" Color scheme.
Plug 'EdenEast/nightfox.nvim'
" Statusline.
Plug 'nvim-lualine/lualine.nvim'
" Icons for lualine and nvim-tree.
Plug 'kyazdani42/nvim-web-devicons'
" Co-pilot.
Plug 'github/copilot.vim'

call plug#end()

" -----------------------------------------------------------------------------
" General settings.
" -----------------------------------------------------------------------------

filetype plugin indent on
set encoding=utf-8

" Tabs to spaces.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Use relative line numbers.
set number relativenumber

" Delete trailing whitespaces on save.
autocmd BufWritePre * %s/\s\+$//e

" Disable comment on newline.
autocmd FileType * setlocal formatoptions-=cro

" Command line completion.
set wildmode=longest:full,full

" Vim syntax highlighting for snakemake files.
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" Set true colors if available.
if has("termguicolors")
    set termguicolors
endif

" Highlight 80 character line.
set colorcolumn=80

" Always use system clipboard.
set clipboard=unnamedplus

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


" Show file tree.
nnoremap <leader>ft <cmd>NvimTreeToggle<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" -----------------------------------------------------------------------------
" Plugin settings.
" -----------------------------------------------------------------------------

:lua << EOF
    -- Setup nvim-cmp.
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      })

    -- Setup language servers.
    local lspconfig = require('lspconfig')
    lspconfig.pyright.setup {}

    -- Global mappings (see `:help vim.diagnostic.*`).
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys after the
    -- language server attaches to the current buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Buffer local mappings (see `:help vim.lsp.*`).
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

        -- Install parsers synchronously (only applied to `ensure_installed`).
      sync_install = false,

      -- Automatically install missing parsers when entering buffer. Set to
      -- `false` if `tree-sitter` CLI is not installed locally.
      auto_install = true,

      highlight = {
      enable = true,
      },
    }

    -- Setup status line.
    require("lualine").setup()

    -- Setup file tree.
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

    -- Setup telescope.
    require("telescope").setup()

    -- Setup indentation highlights.
    require("ibl").setup()

    -- Customize theme.
    vim.cmd("colorscheme carbonfox")
EOF


