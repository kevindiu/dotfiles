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

-- Leader key (Must be set before lazy)
vim.g.mapleader = ","
