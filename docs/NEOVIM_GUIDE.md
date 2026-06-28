# Neovim Guide

**Stack**: Neovim 0.10+ (Nightly), Lazy.nvim, Native LSP, DAP, Neotest, TreeSitter.

## Quick Actions
| Action | Keybinding | Mnemonic |
|--------|------------|----------|
| **Find File** | `,f` | **F**ind |
| **Grep Project** | `,rg` | **R**ip**G**rep |
| **File Tree** | `Ctrl+n` | **N**vimTree |
| **Recent Files** | `,fh` | **F**ile **H**istory |
| **Buffers** | `,bg` | **B**uffer**G**o |

## Plugin Management (Lazy.nvim)
- **UI**: `:Lazy`
- **Update**: `:Lazy sync`
- **Profile**: `:Lazy profile` (Debug startup time)

## File & Buffer Navigation
| Action | Keybinding |
|--------|------------|
| Save | `,w` |
| Quit | `,q` |
| Save & Quit | `,wq` |
| Next Buffer | `,bn` |
| Previous Buffer | `,bp` |
| Delete Buffer | `,bd` |
| New Tab | `,tn` |
| Close Tab | `,tc` |
| Next Tab | `Tab` |
| Previous Tab | `Shift+Tab` |

## Split Management
| Action | Keybinding |
|--------|------------|
| Vertical Split | `,vs` |
| Horizontal Split | `,hs` |
| Equalize Splits | `,=` |
| Navigate Splits | `Ctrl+h/j/k/l` |

## LSP & Go
| Action | Keybinding |
|--------|------------|
| Hover Docs | `K` |
| Definition | `,ds` |
| References | `,gr` (Telescope) |
| Rename | `,rn` |
| Code Action | `,ca` |
| Diagnostics Float | `,e` |

- **Auto-format on save** is enabled for Go files.
- Go files use tabs (tabstop=4), YAML uses spaces (tabstop=2).

## Git Integration
| Action | Keybinding |
|--------|------------|
| Git Status | `,gs` |
| Git Commit | `,gc` |
| Git Push | `,gp` |
| Git Log | `,gl` |

Gitsigns shows `+`/`~`/`_` markers in the sign column.

## General Shortcuts
| Action | Keybinding |
|--------|------------|
| Exit Insert Mode | `jj` |
| Clear Search | `,/` |
| Jump Back | `,<leader>` (,,) |
| Jump Forward | `,.` |
| Jump List | `,jl` |

**Note**: `;` and `:` are swapped in normal/visual mode.

## Debugging (DAP)
We use `nvim-dap` with `nvim-dap-go` for Go debugging. The debug UI opens automatically when a debug session starts.

Start debugging with `:lua require('dap').continue()` or configure keybindings:
```vim
" Suggested (not yet configured):
" F5     → Continue/Start
" F10    → Step Over
" F11    → Step Into
" F12    → Step Out
```

## Testing (Neotest)
Neotest with `neotest-go` is installed. Run tests via command mode:
```vim
:lua require('neotest').run.run()        " Nearest test
:lua require('neotest').run.run(vim.fn.expand('%'))  " Current file
:lua require('neotest').summary.toggle() " Summary panel
```

## Diagnostics (Trouble)
Trouble.nvim is installed. Open via command mode:
```vim
:Trouble diagnostics    " Project diagnostics
:Trouble diagnostics toggle   " Toggle panel
```

## Clipboard
OSC52 clipboard is configured for seamless copy/paste over SSH.
