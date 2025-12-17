-- =============================================================================
-- GENERAL KEYBINDINGS
-- =============================================================================

-- Exit insert mode with jj
vim.keymap.set('i', 'jj', '<Esc>')

-- Swap ; and :
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')
vim.keymap.set('v', ';', ':')
vim.keymap.set('v', ':', ';')

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
