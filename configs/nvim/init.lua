-- =============================================================================
-- NEOVIM CONFIGURATION
-- =============================================================================

-- 1. Core Config (Options, Keymaps)
require("core.options")
require("core.keymaps")

-- 2. Plugin Bootstrap (Lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins.editor" },
    { import = "plugins.coding" },
    { import = "plugins.lsp" },
    { import = "plugins.debug" },
  },
  -- Move lockfile out of the config directory so it doesn't appear on the host.
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})

-- 3. Clipboard (OSC52 Fallback for SSH)
if vim.fn.has('nvim-0.10') == 1 then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

-- 4. Native LSP Setup (Loaded after plugins)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Configure gopls using native LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.lsp.start({
      name = 'gopls',
      cmd = {'gopls'},
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {'go.mod', '.git'}),
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
          },
          staticcheck = true,
        },
      },
    })
    
    -- Auto-format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = 0,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
})

-- Configure lua_ls using native LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.lsp.start({
      name = 'lua_ls',
      cmd = {'lua-language-server'},
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {'.git', '.lazy.lua', 'init.lua'}),
      settings = {
        Lua = {
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        },
      },
    })
  end,
})

-- Configure yamlls for Kubernetes/Docker Compose/CI manifests
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function()
    local cmd = vim.fn.exepath('yaml-language-server')
    if cmd == '' then return end
    vim.lsp.start({
      name = 'yamlls',
      cmd = {'yaml-language-server', '--stdio'},
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {'.git'}),
      settings = {
        yaml = {
          schemas = {
            ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose*.yml',
          },
          validate = true,
          completion = true,
          hover = true,
        },
      },
    })
  end,
})

-- Configure bashls for shell scripts
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'sh', 'bash', 'zsh'},
  callback = function()
    local cmd = vim.fn.exepath('bash-language-server')
    if cmd == '' then return end
    vim.lsp.start({
      name = 'bashls',
      cmd = {'bash-language-server', 'start'},
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {'.git'}),
    })
  end,
})

-- Configure dockerls for Dockerfiles
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dockerfile',
  callback = function()
    local cmd = vim.fn.exepath('docker-langserver')
    if cmd == '' then return end
    vim.lsp.start({
      name = 'dockerls',
      cmd = {'docker-langserver', '--stdio'},
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {'Dockerfile', '.git'}),
    })
  end,
})

-- Configure ts_ls for TypeScript/JavaScript
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact'},
  callback = function()
    local cmd = vim.fn.exepath('typescript-language-server')
    if cmd == '' then return end
    vim.lsp.start({
      name = 'ts_ls',
      cmd = {'typescript-language-server', '--stdio'},
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {'tsconfig.json', 'jsconfig.json', 'package.json', '.git'}),
    })
  end,
})

-- Diagnostic config
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic signs
local signs = { Error = "✗", Warn = "⚠", Hint = "💡", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP Keybindings (Dynamic attach)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    
    -- Docs & Nav
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>gr', '<cmd>Telescope lsp_references<cr>', opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    
    -- Diagnostics
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  end,
})

-- Go Dev Mappings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set('n', '<leader>r', ':term go run %<CR>', opts)
    vim.keymap.set('n', '<leader>t', ':term go test<CR>', opts)
    
    -- Go indentation settings
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- YAML Settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})