-- -------------------------------------------------------------------------------------
--
-- Neovim configuration file written in Lua.
--
-- -------------------------------------------------------------------------------------

-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- -------------------------------------------------------------------------------------
-- Setting options.
--  See `:h lua-options`, `:h lua-guide-options`.
-- -------------------------------------------------------------------------------------

-- Indentation.
vim.o.tabstop = 4 -- A tab is displayed as 4 spaces.
vim.o.shiftwidth = 0 -- Sets (auto)indent spaces to `tabstop`.
vim.o.expandtab = true -- Use spaces instead of tabs.

-- Line numbers.
vim.o.number = true -- Show line numbers.
vim.o.relativenumber = true -- Show absolute at position and relative elsewhere.

-- Linewidth.
vim.o.textwidth = 88 -- Set text width to 88 characters.
vim.o.colorcolumn = '88' -- Highlight 88 character line.

-- Update time.
vim.o.updatetime = 3000 -- Faster completion (default is 4000ms).

-- Command line completion style.
vim.o.wildmode = 'longest:full,full'

-- Enable mouse mode for all modes.
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line.
vim.o.showmode = false

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it
-- can increase startup-time. Remove this option if you want your OS clipboard to remain
-- independent. See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.g.clipboard = 'osc52'
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Configure how new splits should be opened.
vim.o.splitright = true
vim.o.splitbelow = true

-- Show <tab> and trailing spaces.
vim.o.list = true

-- Preview partial off-screen substitutions live, as you type.
vim.o.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- If performing an operation that would fail due to unsaved changes in the buffer
-- (like `:q`), instead raise a dialog asking if you wish to save the current file(s).
vim.o.confirm = true

-- -------------------------------------------------------------------------------------
-- Set up keymaps.
--  See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`.
-- -------------------------------------------------------------------------------------

-- Use <Esc> to exit terminal mode.
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Change to normal mode' })

-- Diagnostic keymaps.
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic quickfix list' }
)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })

-- Maps <C-j>, <C-k>, <C-h>, <C-l> to navigate between windows in any modes.
local function set_window_nav_key(mode, key, orig_prefix, window)
  local desc = 'Move focus to the ' .. window .. ' window'
  vim.keymap.set(mode, '<C-' .. key .. '>', orig_prefix .. key, { desc = desc })
end

for key, window in pairs({ h = 'left', j = 'lower', k = 'upper', l = 'right' }) do
  set_window_nav_key({ 't' }, key, '<C-\\><C-n><C-w>', window)
  set_window_nav_key({ 'n' }, key, '<C-w>', window)
end

-- -------------------------------------------------------------------------------------
-- Basic Autocommands.
--  See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`.
-- -------------------------------------------------------------------------------------

-- Highlight when yanking (copying) text.
--  See `:h vim.hl.on_yank()`.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Disable comment continuation on newline.
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Delete trailing whitespace on save.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    -- Replace trailing whitespace with nothing.
    local save_cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, save_cursor)
  end,
})

-- Set indentation for Lua files.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.bo.tabstop = 2
  end,
})

-- -------------------------------------------------------------------------------------
-- Plugin setup.
-- -------------------------------------------------------------------------------------

-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specs.
require('lazy').setup({

  { -- Colorscheme.
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('duskfox')
    end,
  },

  { -- Statusline (consider switching to mini.statusline).
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {},
  },

  { -- Highlight context (consider switching to mini.indentscope).
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },

  -- AI plugins.
  { -- Copilot. TODO: Try NES with Copilot LSP.
    'zbirenbaum/copilot.lua',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      suggestion = { enabled = true, auto_trigger = true },
      panel = { enabled = false },
      filetypes = { markdown = true },
    },
  },
  { -- Copilot chat.
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim', branch = 'master' } },
    build = 'make tiktoken',
    opts = { mappings = { reset = { normal = '<C-r>', insert = '<C-r>' } } },
    keys = {
      { '<leader>ac', '<Cmd>CopilotChatToggle<CR>', desc = 'Open Copilot Chat' },
      {
        '<leader>aa',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'Quick Copilot Chat',
      },
    },
  },

  -- Git plugins.
  { -- Git signs, hunks, etc.
    'lewis6991/gitsigns.nvim',
    opts = { signs = { add = { text = '+' } } },
  },
  'tpope/vim-fugitive',

  { -- Telescope.
    'nvim-telescope/telescope.nvim',
    tag = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup({
        pickers = {
          find_files = { hidden = true },
          live_grep = { additional_args = { '--hidden' } },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
          file_browser = {
            theme = 'ivy',
            hijack_netrw = true,
            grouped = true,
            sorting_strategy = 'ascending',
            display_stat = false,
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
          },
        },
      })

      -- Load extensions.
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')
      require('telescope').load_extension('file_browser')

      -- Keymaps for telescope.
      local builtin = require('telescope.builtin')
      local extensions = require('telescope').extensions
      local telescope_dropdown = require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      })
      local map_telescope_key = function(key, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, key, func, { desc = desc })
      end
      map_telescope_key('<leader>ff', builtin.find_files, 'Telescope find files')
      map_telescope_key('<leader>fg', builtin.live_grep, 'Telescope live grep')
      map_telescope_key('<leader>fh', builtin.help_tags, 'Telescope help tags')
      map_telescope_key('<leader>fk', builtin.keymaps, 'Telescope keymaps')
      map_telescope_key('<leader>fq', builtin.diagnostics, 'Telescope diagnostics')
      map_telescope_key('<leader>f/', builtin.current_buffer_fuzzy_find, 'Telescope current buffer')
      map_telescope_key(
        '<leader>ft',
        extensions.file_browser.file_browser,
        'Telescope file browser'
      )
      map_telescope_key('<leader>fb', function()
        builtin.buffers(telescope_dropdown)
      end, 'Telescope buffers')
    end,
  },

  -- LSP plugins.
  { -- Main LSP configuration.
    'neovim/nvim-lspconfig',
    dependencies = 'nvim-telescope/telescope.nvim',
    config = function()
      -- Python.
      vim.lsp.config('pyright', {
        settings = {
          -- Disable in favour of Ruff's import organizer.
          pyright = { disableOrganizeImports = true },
          python = { analysis = { typeCheckingMode = 'standard' } },
        },
        on_attach = function(client, _)
          -- Disable formatting for Pyright in favour of Ruff.
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
      vim.lsp.enable('pyright')
      vim.lsp.config('ruff', {
        on_attach = function(client, _)
          -- Disable hover for Ruff in favour of Pyright.
          client.server_capabilities.hoverProvider = false
        end,
      })
      vim.lsp.enable('ruff')

      -- Lua.
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            -- Disable built-in formatter in favour of stylua.
            format = { enable = false },
          },
        },
      })
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('stylua')

      -- Augroup for LSP document highlights.
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-document-highlight', {})

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Keymaps for LSP.
          local map_lsp_key = function(key, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, key, func, { buffer = event.buf, desc = desc })
          end
          map_lsp_key('<Space>f', function()
            vim.lsp.buf.format({ async = true })
          end, 'Format current buffer')
          map_lsp_key('grd', vim.lsp.buf.definition, 'Go to definition')
          map_lsp_key('grD', vim.lsp.buf.declaration, 'Go to declaration')

          local builtin = require('telescope.builtin')
          map_lsp_key('grr', builtin.lsp_references, 'Find references')
          map_lsp_key('g0', builtin.lsp_document_symbols, 'Find document symbol')
          map_lsp_key('gW', builtin.lsp_dynamic_workspace_symbols, 'Find workspace symbol')

          -- Highlight symbols when the cursor is on them.
          if
            client
            and client.supports_method(
              client,
              vim.lsp.protocol.Methods.textDocument_documentHighlight
            )
          then
            -- Highlight symbol under cursor on CursorHold / CursorHoldI.
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            -- Clear highlights on CursorMoved / CursorMovedI.
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            -- Clean-up autocommands and highlights on LspDetach.
            vim.api.nvim_create_autocmd('LspDetach', {
              buffer = event.buf,
              group = highlight_augroup,
              callback = function(event2)
                -- Note, here event2.buf = event.buf.
                -- This will actually clear all highlights for the buffer (not just for this client).
                vim.lsp.buf.clear_references(event2.buf)
                vim.api.nvim_clear_autocmds({
                  group = highlight_augroup,
                  buffer = event2.buf,
                })
              end,
            })
          end
        end,
      })

      -- Diagnostic Config.
      --  See :help vim.diagnostic.Opts.
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = true,
      })
    end,
  },

  { -- Treesitter parser for code highlighting and navigation.
    'nvim-treesitter/nvim-treesitter',
    branch = 'master', -- TODO: Switch to stable rewrite when available.
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'lua',
        'luadoc',
        'vim',
        'vimdoc',
        'query',
        'python',
        'markdown',
      },
      auto_install = true,
      highlight = { enable = true },
    },
  },

  { -- Useful plugin to show pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      -- Delay between pressing a key and opening which-key (milliseconds).
      -- This setting is independent of vim.o.timeoutlen.
      delay = 0,
    },
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    opts = function()
      -- Register nvim-cmp lsp capabilities.
      vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })
      local cmp = require('cmp')
      return {
        -- For now uses the built-in snippet engine (default).
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        experimental = { ghost_text = false },
      }
    end,
  },

  -- Plugins to check:
  --  - conform.nvim: Improved code formatting.
})
