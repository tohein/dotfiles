-- -----------------------------------------------------------------------------
-- Plugin setup in Lua.
--
-- This file is sourced by `init.vim`.
-- -----------------------------------------------------------------------------

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
    ['<c-b>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<c-e>'] = cmp.mapping.abort(),
    ['<cr>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- -----------------------------------------------------------------------------
-- Setup language servers.
-- -----------------------------------------------------------------------------

require('lspconfig').pyright.setup{
  settings = {
    pyright = {
      -- Using Ruff's import organizer.
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting.
        ignore = { '*' },
      },
    },
  },
}
require('lspconfig').ruff.setup{}

-- Suppress virtual text (floating diagnostics). Diagnostics can be shown using
-- the key mappings below.
local function setup_diags()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
    }
  )
end
setup_diags()

-- Mappings for diagnostics (see `:help vim.diagnostic.*`).
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use `LspAttach` autocommand to only map the following keys after the
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
    vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, opts)
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

     -- Disable hover for Ruff in favor of Pyright
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Set keymaps and disable hover for Ruff',
})

-- -----------------------------------------------------------------------------
-- Setup treesitter.
-- -----------------------------------------------------------------------------

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },
    -- Install parsers synchronously (only applied to `ensure_installed`).
  sync_install = false,
  -- Automatically install missing parsers when entering buffer. Set to
  -- `false` if `tree-sitter` CLI is not installed locally.
  auto_install = true,
  highlight = { enable = true },
}

-- -----------------------------------------------------------------------------
-- Setup telescope.
-- -----------------------------------------------------------------------------

require("telescope").setup{
  pickers = {
    find_files = { hidden = true },
    live_grep = { additional_args = {"--hidden"} },
  },
  extensions = {
    file_browser = {
      -- Disables netrw and use telescope-file-browser in its place.
      hijack_netrw = true
    },
  },
}
require("telescope").load_extension("file_browser")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "<leader>ft", ":Telescope file_browser<CR>")

-- -----------------------------------------------------------------------------
-- Other plugins.
-- -----------------------------------------------------------------------------

require("ibl").setup()              -- Indentation based line highlights.
require("lualine").setup()          -- Status line.
