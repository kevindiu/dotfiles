" =============================================================================
" VIM CONFIGURATION FOR GO DEVELOPMENT & YAML EDITING
" =============================================================================

" Basic compatibility settings
set nocompatible
filetype off

" =============================================================================
" PLUGIN MANAGER SETUP
" =============================================================================

" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =============================================================================
" PLUGIN DECLARATIONS
" =============================================================================

call plug#begin('~/.vim/plugged')

" Go Development Tools
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sebdah/vim-delve'

" Language Server & Code Intelligence
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}

" File Management & Search
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Syntax & Highlighting
Plug 'sheerun/vim-polyglot'

" Status Line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code Formatting & Linting
Plug 'dense-analysis/ale'

" Text Objects & Navigation
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" YAML Support
Plug 'stephpy/vim-yaml'
Plug 'pedrohdz/vim-yaml-folds'

call plug#end()

" Enable filetype detection and plugins
filetype plugin indent on

" Set leader key early
let mapleader = ","

" =============================================================================
" CODE INTELLIGENCE & COMPLETION (CoC.nvim)
" =============================================================================

" CoC Extensions
let g:coc_global_extensions = ['coc-go']

" Floating Documentation Settings
let g:coc_floating_preview = 1
let g:coc_preview_max_width = 80
let g:coc_preview_max_height = 20

" Completion Behavior
set completeopt=menu,menuone,noinsert
set pumheight=15
set updatetime=300
set shortmess+=c

" Auto-show documentation when completion menu is open
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
autocmd CompleteChanged * if pumvisible() | call timer_start(100, {-> CocActionAsync('showSignatureHelp')}) | endif

" Helper Functions
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Completion Keybindings
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Manual completion trigger
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Show documentation for completion items
inoremap <silent><expr> <C-d> coc#pum#visible() ? CocActionAsync('showSignatureHelp') : "\<C-d>"

" =============================================================================
" GO DEVELOPMENT CONFIGURATION
" =============================================================================

" Go Formatting & Tools
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" Use gopls for all language server features
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'
let g:go_rename_command = 'gopls'
let g:go_implements_mode = 'gopls'
let g:go_gopls_enabled = 1

" Syntax Highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_sameids = 1

" Disable vim-go completion (use CoC instead)
let g:go_code_completion_enabled = 0

" =============================================================================
" LINTING & FORMATTING (ALE)
" =============================================================================

" YAML-only linting (Go handled by CoC)
let g:ale_linters = {
\   'yaml': ['yamllint'],
\}
let g:ale_fixers = {
\   'yaml': ['yamlfix', 'remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1
let g:ale_yaml_yamllint_options = '-d relaxed'

" Disable ALE for Go files (CoC handles this)
let g:ale_pattern_options = {'\.go$': {'ale_enabled': 0}}

" =============================================================================
" FUZZY FINDER (FZF) CONFIGURATION
" =============================================================================

let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'down': '~40%' }

" File opening actions
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Color scheme
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" =============================================================================
" BASIC VIM SETTINGS
" =============================================================================

" Line Numbers & Display
set number
set relativenumber
set scrolloff=8
set sidescrolloff=8

" Indentation & Tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" Search Settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Completion & Wildmenu
set wildmenu
set wildmode=list:longest

" Interface & Behavior
set mouse=a
set clipboard=unnamed
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set splitbelow
set splitright

" Visual Settings
syntax enable
set background=dark
colorscheme default

" Show whitespace characters
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" File handling
set autoread

" =============================================================================
" LANGUAGE-SPECIFIC SETTINGS
" =============================================================================

" Go Settings (tabs, not spaces)
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" YAML Settings (2-space indentation)
au FileType yaml set expandtab
au FileType yaml set shiftwidth=2
au FileType yaml set softtabstop=2
au FileType yaml set tabstop=2
au FileType yaml set autoindent
au FileType yaml set cursorline
au FileType yaml set cursorcolumn

" =============================================================================
" GO DEVELOPMENT KEYBINDINGS
" =============================================================================

" Build & Test Workflow
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>tf <Plug>(go-test-func)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)

" Code Navigation (CoC-powered)
au FileType go nmap <leader>ds <Plug>(coc-definition)
au FileType go nmap <leader>dv :call CocAction('jumpDefinition', 'vsplit')<CR>
au FileType go nmap <leader>dtab :call CocAction('jumpDefinition', 'tabe')<CR>
au FileType go nmap <leader>gr <Plug>(coc-references)
au FileType go nmap <leader>rn <Plug>(coc-rename)

" Documentation & Help
au FileType go nnoremap K :call ShowDocumentation()<CR>
au FileType go nnoremap <leader>gd :call CocActionAsync('doHover')<CR>
au FileType go nnoremap <leader>h :call CocActionAsync('doHover')<CR>

" Code Manipulation
au FileType go nmap <leader>ga <Plug>(go-alternate-edit)
au FileType go nmap <leader>gah <Plug>(go-alternate-split)
au FileType go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <leader>ie <Plug>(go-iferr)

" Debugging
au FileType go nmap <leader>db :DlvToggleBreakpoint<CR>
au FileType go nmap <leader>dr :DlvDebug<CR>
au FileType go nmap <leader>dt :DlvTest<CR>


" =============================================================================
" GENERAL KEYBINDINGS & SHORTCUTS
" =============================================================================


" File Operations
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" File Tree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" =============================================================================
" FUZZY FINDER SHORTCUTS
" =============================================================================

nnoremap <leader>f :Files<CR>
nnoremap <leader>bg :Buffers<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>fh :History<CR>
nnoremap <C-p> :Files<CR>

" Advanced file opening
nnoremap <leader>sf :Files<CR>
nnoremap <leader>vf :Files<CR>
nnoremap <leader>ft :Files<CR>

" =============================================================================
" WINDOW & BUFFER MANAGEMENT
" =============================================================================

" Buffer Navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>ls :ls<CR>

" Split Management
nnoremap <leader>vs :vsplit<CR>
nnoremap <leader>hs :split<CR>
nnoremap <leader>= <C-w>=

" Split Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Tab Management
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprev<CR>

" =============================================================================
" GIT INTEGRATION SHORTCUTS
" =============================================================================

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log --oneline<CR>

" =============================================================================
" UTILITY SHORTCUTS
" =============================================================================

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" =============================================================================
" PERSISTENT DATA & BACKUP
" =============================================================================

" Backup and swap directories
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Enable persistent undo
set undofile
