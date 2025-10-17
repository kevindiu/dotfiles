local opt = vim.opt
local g = vim.g

g.mapleader = ","
g.maplocalleader = ","

opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.wrap = false
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 300
opt.timeoutlen = 500
opt.completeopt = { "menu", "menuone", "noselect" }
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.undofile = true
opt.backup = false
opt.swapfile = false

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

local function ensure_state_dirs()
  local state = vim.fn.stdpath("state")
  for _, name in ipairs({ "undo", "backup", "swap" }) do
    local path = state .. "/" .. name
    if vim.fn.isdirectory(path) == 0 then
      vim.fn.mkdir(path, "p")
    end
  end
  opt.undodir = state .. "/undo"
  opt.backupdir = state .. "/backup//"
  opt.directory = state .. "/swap//"
end

ensure_state_dirs()

local map = vim.keymap.set

map("i", "jj", "<Esc>", { desc = "Exit insert mode" })
map({ "n", "v" }, ";", ":", { desc = "Command mode alias" })
map({ "n", "v" }, ":", ";", { desc = "Swap : and ;" })
map("n", "<leader>/", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

local function find_file()
  local command
  if vim.fn.executable("fd") == 1 then
    command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" }
  elseif vim.fn.executable("rg") == 1 then
    command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git" }
  else
    vim.notify("Install fd or ripgrep for file search", vim.log.levels.INFO)
    return
  end
  local files = vim.fn.systemlist(table.concat(command, " "))
  if vim.v.shell_error ~= 0 or vim.tbl_isempty(files) then
    vim.notify("No files found", vim.log.levels.INFO)
    return
  end
  vim.ui.select(files, { prompt = "Find file" }, function(choice)
    if choice then
      vim.cmd.edit(vim.fn.fnameescape(choice))
    end
  end)
end

map("n", "<leader>f", find_file, { desc = "Find file" })
map("n", "<C-p>", find_file, { desc = "Find file" })

local function switch_buffer()
  local buffers = {}
  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    local name = buf.name ~= "" and vim.fn.fnamemodify(buf.name, ":~:.") or "[No Name]"
    table.insert(buffers, { label = name, bufnr = buf.bufnr })
  end
  if vim.tbl_isempty(buffers) then
    vim.notify("No listed buffers", vim.log.levels.INFO)
    return
  end
  vim.ui.select(buffers, {
    prompt = "Switch buffer",
    format_item = function(item)
      return string.format("%s  (%d)", item.label, item.bufnr)
    end,
  }, function(choice)
    if choice then
      vim.cmd.buffer(choice.bufnr)
    end
  end)
end

map("n", "<leader>bg", switch_buffer, { desc = "Switch buffer" })

local function go_toggle(target)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or not file:match("%.go$") then
    vim.notify("Not a Go buffer", vim.log.levels.INFO)
    return
  end
  local alt
  if file:match("_test%.go$") then
    alt = file:gsub("_test%.go$", ".go")
  else
    alt = file:gsub("%.go$", "_test.go")
  end
  vim.cmd((target or "edit") .. " " .. vim.fn.fnameescape(alt))
end

map("n", "<leader>ga", function()
  go_toggle("edit")
end, { desc = "Go: toggle test file" })
map("n", "<leader>gah", function()
  go_toggle("split")
end, { desc = "Go: toggle test file (split)" })
map("n", "<leader>gav", function()
  go_toggle("vsplit")
end, { desc = "Go: toggle test file (vsplit)" })

local function go_root(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local start = name ~= "" and vim.fs.dirname(name) or vim.loop.cwd()
  local marker = vim.fs.find({ "go.work", "go.mod", ".git" }, { upward = true, path = start })[1]
  return marker and vim.fs.dirname(marker) or start
end

local function ensure_gopls(buf)
  if next(vim.lsp.get_active_clients({ bufnr = buf, name = "gopls" })) then
    return
  end
  vim.lsp.start({
    name = "gopls",
    cmd = { "gopls" },
    root_dir = go_root(buf),
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        usePlaceholders = true,
      },
    },
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(ev)
    ensure_gopls(ev.buf)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[ev.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local buf = event.buf
    local function lsp_map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    lsp_map("gd", vim.lsp.buf.definition, "Goto definition")
    lsp_map("K", vim.lsp.buf.hover, "Hover documentation")
    lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    lsp_map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    lsp_map("]d", vim.diagnostic.goto_next, "Next diagnostic")
    lsp_map("gr", vim.lsp.buf.references, "List references")
  end,
})

local function organize_imports()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
  for _, res in pairs(result or {}) do
    for _, action in pairs(res.result or {}) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, "UTF-8")
      elseif action.command then
        vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    organize_imports()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})
