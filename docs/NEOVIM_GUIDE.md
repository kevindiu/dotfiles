# Neovim Guide

**Stack**: Neovim 0.9+ (Nightly), Lazy.nvim, Native LSP, DAP, Neotest.

## Quick Actions
| Action | Keybinding | Mnemonic |
|--------|------------|----------|
| **Find File** | `,f` | **F**ind |
| **Grep Project** | `,rg` | **R**ip**G**rep |
| **File Tree** | `Ctrl+n` | **N**vimTree |
| **Diagnostics** | `,xx` | Fi**x** |

## Plugin Management (Lazy.nvim)
- **UI**: `:Lazy`
- **Update**: `:Lazy sync`
- **Profile**: `:Lazy profile` (Debug startup time)

## Debugging (DAP)
We use `nvim-dap` with `dlv` for Go.
- **F5**: Continue / Start
- **F10**: Step Over
- **F11**: Step Into
- **F12**: Step Out
- **Leader+db**: Toggle Breakpoint
- **Leader+du**: Toggle Debug UI

## Testing (Neotest)
- `,tt`: Run **T**est (Nearest)
- `,tf`: Run **T**est (**F**ile)
- `,ts`: Toggle **S**ummary panel

## LSP & Go
- **Docs**: `K` (Hover)
- **Def**: `,ds` (Definition)
- **Refs**: `,gr` (References)
- **Rename**: `,rn`
- **Code Action**: `,ca`
