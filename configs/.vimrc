" Basic Vim Configuration with Go support
set nocompatible
filetype off

" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

" Go development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" File management and fuzzy finder  
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Modern LSP with completion preview (latest version)
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code formatting and linting
Plug 'dense-analysis/ale'

" Better text objects and motions
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Debugging support
Plug 'sebdah/vim-delve'

" YAML support
Plug 'stephpy/vim-yaml'
Plug 'pedrohdz/vim-yaml-folds'

call plug#end()

" CoC configuration for Go with floating documentation
let g:coc_global_extensions = ['coc-go']

" Enable floating documentation
let g:coc_floating_preview = 1
let g:coc_preview_max_width = 80
let g:coc_preview_max_height = 20

" Show documentation in floating window automatically
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Completion behavior
set completeopt=menu,menuone,noinsert
set pumheight=15

" Enable hover documentation
set updatetime=300
set shortmess+=c

" CoC completion settings (latest version with preview)
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use Tab for trigger completion with characters ahead and navigate with docs
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Show documentation when navigating completion
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Auto-show documentation when completion menu is open
autocmd CompleteChanged * if pumvisible() | call timer_start(100, {-> CocActionAsync('showSignatureHelp')}) | endif

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" vim-go settings  
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'
let g:go_rename_command = 'gopls'
let g:go_implements_mode = 'gopls'
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_sameids = 1

" Disable vim-go completion - use LSP only
let g:go_code_completion_enabled = 0
let g:go_gopls_enabled = 1

" Keep ALE for YAML linting only
let g:ale_linters = {
\   'yaml': ['yamllint'],
\}
let g:ale_fixers = {
\   'yaml': ['yamlfix', 'remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fix_on_save = 1
let g:ale_yaml_yamllint_options = '-d relaxed'

" Disable ALE for Go (using CoC instead)
let g:ale_pattern_options = {'\.go$': {'ale_enabled': 0}}

" FZF settings
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
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

" Basic settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest
set scrolloff=8
set sidescrolloff=8
set mouse=a
set clipboard=unnamed
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set splitbelow
set splitright

" Color scheme
syntax enable
set background=dark
colorscheme default

" Go specific settings
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" YAML specific settings
au FileType yaml set expandtab
au FileType yaml set shiftwidth=2
au FileType yaml set softtabstop=2
au FileType yaml set tabstop=2
au FileType yaml set autoindent
au FileType yaml set cursorline
au FileType yaml set cursorcolumn

" Go shortcuts - Development workflow
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>tf <Plug>(go-test-func)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)

" Go shortcuts - Navigation and information (using CoC)
au FileType go nmap <leader>ds <Plug>(coc-definition)
au FileType go nmap <leader>dv :call CocAction('jumpDefinition', 'vsplit')<CR>
au FileType go nmap <leader>dt :call CocAction('jumpDefinition', 'tabe')<CR>
au FileType go nnoremap <leader>gd :call CocActionAsync('doHover')<CR>
au FileType go nmap <leader>gr <Plug>(coc-references)
au FileType go nmap <leader>rn <Plug>(coc-rename)

" Additional CoC shortcuts with documentation
au FileType go nnoremap K :call ShowDocumentation()<CR>
au FileType go nnoremap <leader>h :call CocActionAsync('doHover')<CR>

" Show documentation for completion items  
inoremap <silent><expr> <C-d> coc#pum#visible() ? CocActionAsync('showSignatureHelp') : "\<C-d>"

" Go shortcuts - Code manipulation
au FileType go nmap <leader>ga <Plug>(go-alternate-edit)
au FileType go nmap <leader>gah <Plug>(go-alternate-split)
au FileType go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <leader>ie <Plug>(go-iferr)

" Go shortcuts - Debugging
au FileType go nmap <leader>db :DlvToggleBreakpoint<CR>
au FileType go nmap <leader>dr :DlvDebug<CR>
au FileType go nmap <leader>dt :DlvTest<CR>


" NERDTree settings
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Key mappings
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" FZF shortcuts
nnoremap <leader>f :Files<CR>
nnoremap <leader>bg :Buffers<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>h :History<CR>
nnoremap <C-p> :Files<CR>

" Advanced file opening with FZF
nnoremap <leader>sf :Files<CR>
nnoremap <leader>vf :Files<CR>
nnoremap <leader>tf :Files<CR>

" Git shortcuts
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log --oneline<CR>

" Buffer management
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :ls<CR>

" Split management
nnoremap <leader>vs :vsplit<CR>
nnoremap <leader>hs :split<CR>
nnoremap <leader>= <C-w>=

" Tab management  
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprev<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Show whitespace
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" Auto-reload files changed outside vim
set autoread

" Use persistent directories
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Persistent undo
set undofile
