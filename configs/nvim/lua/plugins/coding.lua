return {
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

  -- Text objects
  "tpope/vim-surround",
  "tpope/vim-commentary",
  
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
  
  -- YAML support
  {
    "cuducos/yaml.nvim",
    ft = {"yaml"},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
  },
}
