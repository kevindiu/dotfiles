-- =============================================================================
-- NEOVIM CONFIGURATION FOR GO DEVELOPMENT
-- =============================================================================

-- Leader key
vim.g.mapleader = ","

-- Exit insert mode with jj
vim.keymap.set('i', 'jj', '<Esc>')

-- Swap ; and :
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')
vim.keymap.set('v', ';', ':')
vim.keymap.set('v', ':', ';')

-- =============================================================================
-- PLUGIN MANAGER SETUP (lazy.nvim)
-- =============================================================================

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
# Prepend lazy to runtime path to ensure it loads before other plugins
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- PLUGINS
-- =============================================================================

require("lazy").setup({
  -- File management
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
          mappings = {
            i = {
              ["<C-x>"] = require('telescope.actions').select_horizontal,
              ["<C-v>"] = require('telescope.actions').select_vertical,
              ["<C-t>"] = require('telescope.actions').select_tab,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = false,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = { theme = 'auto' },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end,
  },

  -- Git commands
  "tpope/vim-fugitive",

  -- Text objects
  "tpope/vim-surround",
  "tpope/vim-commentary",

  -- Syntax highlighting (TreeSitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "go", "gomod", "gosum", "yaml", "json", "bash", "lua", "markdown", "dockerfile" },
        highlight = { 
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end,
  },

  -- YAML support
  {
    "cuducos/yaml.nvim",
    ft = {"yaml"},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
      })
      vim.cmd[[colorscheme tokyonight]]
    end,
  },
  -- Debugging (DAP)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      require("dap-go").setup()
      dapui.setup()
      
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
        },
      })
    end,
  },

  -- Diagnostics
  {
    "folke/trouble.nvim",
    opts = {},
  },
})

-- =============================================================================
-- NATIVE LSP CONFIGURATION (Built-in Neovim 0.11+)
-- =============================================================================

-- Configure gopls using native LSP
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.lsp.start({
      name = 'gopls',
      cmd = {'gopls'},
      root_dir = vim.fs.root(0, {'go.mod', '.git'}),
      settings = {
        gopls = {
          -- Enable advanced static analysis features
          completeUnimported = true,    -- Auto-import on completion
          usePlaceholders = true,       -- Add placeholders for function parameters
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
          },
          staticcheck = true,
        },
      },
    })
    
    -- Auto-format on save (includes import organization)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = 0,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
})

-- Show diagnostics automatically
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

-- =============================================================================
-- BASIC VIM SETTINGS
-- =============================================================================

-- Line Numbers & Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Indentation & Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search Settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show matching brackets
vim.opt.showmatch = true

-- Interface & Behavior
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.encoding = 'utf-8'
vim.opt.backspace = {'indent', 'eol', 'start'}
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Visual Settings
vim.cmd('syntax enable')
vim.opt.background = 'dark'
vim.opt.termguicolors = true

-- Show whitespace characters
vim.opt.listchars = {tab = '▸ ', trail = '·', eol = '¬', nbsp = '_'}
vim.opt.list = true

-- File handling
vim.opt.autoread = true

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.local/share/nvim/undo')

-- =============================================================================
-- LANGUAGE-SPECIFIC SETTINGS
-- =============================================================================

-- Go Settings (tabs, not spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- YAML Settings (2-space indentation)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.autoindent = true
    vim.opt_local.cursorline = true
    vim.opt_local.cursorcolumn = true
  end,
})

-- =============================================================================
-- LSP KEYBINDINGS
-- =============================================================================

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    
    -- Documentation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
    
    -- Navigation
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>gr', '<cmd>Telescope lsp_references<cr>', opts)
    vim.keymap.set('n', '<leader>gi', '<cmd>Telescope lsp_implementations<cr>', opts)
    vim.keymap.set('n', '<leader>gt', '<cmd>Telescope lsp_type_definitions<cr>', opts)
    vim.keymap.set('n', '<leader>gs', '<cmd>Telescope lsp_document_symbols<cr>', opts)
    vim.keymap.set('n', '<leader>gw', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    
    -- Code actions
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    
    
    -- Diagnostics / Errors
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, opts)
  end,
})

-- =============================================================================
-- GO DEVELOPMENT KEYBINDINGS
-- =============================================================================

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local opts = { buffer = true }
    
    -- Build & Test (using built-in terminal)
    vim.keymap.set('n', '<leader>r', ':term go run %<CR>', opts)
    vim.keymap.set('n', '<leader>b', ':term go build<CR>', opts)
    vim.keymap.set('n', '<leader>t', ':term go test<CR>', opts)
    vim.keymap.set('n', '<leader>tf', ':term go test -run ', opts)
    
  end,
})

-- =============================================================================
-- GENERAL KEYBINDINGS & SHORTCUTS
-- =============================================================================

-- File Operations
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>wq', ':wq<CR>')

-- File Tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

-- Telescope
vim.keymap.set('n', '<leader>f', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>bg', ':Telescope buffers<CR>')
vim.keymap.set('n', '<leader>rg', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>fh', ':Telescope oldfiles<CR>')
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>')

-- Buffer Navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprev<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')

-- Split Management
vim.keymap.set('n', '<leader>vs', ':vsplit<CR>')
vim.keymap.set('n', '<leader>hs', ':split<CR>')
vim.keymap.set('n', '<leader>=', '<C-w>=')

-- Split Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Tab Management
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>')
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')
vim.keymap.set('n', '<Tab>', ':tabnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':tabprev<CR>')

-- Git shortcuts
vim.keymap.set('n', '<leader>gs', ':Git<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
vim.keymap.set('n', '<leader>gl', ':Git log --oneline<CR>')

-- Clear search highlighting
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>')

-- Navigation history
vim.keymap.set('n', '<leader><leader>', '<C-o>')  -- Quick go back
vim.keymap.set('n', '<leader>.', '<C-i>')         -- Quick go forward
vim.keymap.set('n', '<leader>jl', ':jumps<CR>')   -- Show jump list

-- TreeSitter commands
vim.keymap.set('n', '<leader>ts', ':TSInstallInfo<CR>')
vim.keymap.set('n', '<leader>tu', ':TSUpdate<CR>')

-- =============================================================================
-- DEBUGGING & TESTING KEYBINDINGS
-- =============================================================================

-- Debugging
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end)

-- Testing
vim.keymap.set('n', '<leader>tt', function() require("neotest").run.run() end)              -- Run nearest test
vim.keymap.set('n', '<leader>tl', function() require("neotest").run.run_last() end)         -- Run last test
vim.keymap.set('n', '<leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end) -- Run file
vim.keymap.set('n', '<leader>ts', function() require("neotest").summary.toggle() end)       -- Toggle summary

-- Trouble (Diagnostics)
vim.keymap.set('n', '<leader>xx', function() require("trouble").toggle() end)
vim.keymap.set('n', '<leader>xw', function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set('n', '<leader>xd', function() require("trouble").toggle("document_diagnostics") end)