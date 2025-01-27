-- -----------------------------------------------------------------------------
-- Plugin setup in Lua.
--
-- This file is sourced by `init.vim`.
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- Setup language servers.
-- -----------------------------------------------------------------------------

local lspconfig = require('lspconfig')
lspconfig.pyright.setup({
  settings = {
    pyright = {
      -- Disable in favour of Ruff's import organizer.
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting.
        ignore = { '*' },
      },
    },
  },
})
lspconfig.ruff.setup({})

-- Mappings for diagnostics (see `:help vim.diagnostic.*`).
vim.keymap.set('n', '<Space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Space>q', vim.diagnostic.setloclist)

-- Runs callback when a new language server is attached to the buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings (see `:help vim.lsp.*`).
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<Space>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<Space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Disable hover for Ruff in favour of Pyright
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Set keymaps and disable hover for Ruff',
})

-- -----------------------------------------------------------------------------
-- Setup nvim-cmp.
-- -----------------------------------------------------------------------------

local cmp = require('cmp')
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
    -- Accept currently selected item. Set `select` to `false` to only confirm
    -- explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- -----------------------------------------------------------------------------
-- Setup treesitter.
-- -----------------------------------------------------------------------------

require('nvim-treesitter.configs').setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
  -- Install parsers synchronously (only applied to `ensure_installed`).
  sync_install = false,
  -- Automatically install missing parsers when entering buffer. Set to
  -- `false` if `tree-sitter` CLI is not installed locally.
  auto_install = true,
  highlight = { enable = true },
})

-- -----------------------------------------------------------------------------
-- Setup telescope.
-- -----------------------------------------------------------------------------

local telescope = require("telescope")
telescope.setup({
  pickers = {
    find_files = { hidden = true },
    live_grep = { additional_args = { "--hidden" } },
  },
  extensions = {
    file_browser = {
      -- Disables netrw and uses telescope-file-browser in its place.
      hijack_netrw = true
    },
  },
})
telescope.load_extension("file_browser")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "<leader>ft", ":Telescope file_browser<CR>")

-- -----------------------------------------------------------------------------
-- Other plugins.
-- -----------------------------------------------------------------------------

require("ibl").setup({})     -- Indentation based line highlights.
require("lualine").setup({}) -- Status line.
