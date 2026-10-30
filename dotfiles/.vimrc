
" ============================================================
" 1. Essential Global Configurations (Must load FIRST)
" ============================================================
let mapleader = " "
set t_Co=256
set background=dark

" ============================================================
" 2. Plugin Management (vim-plug)
" ============================================================
call plug#begin()

Plug 'mhinz/vim-startify'
Plug 'preservim/nerdtree'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
Plug 'cocopon/iceberg.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'projekt0n/github-nvim-theme'

call plug#end()

" ============================================================
" 3. Visual Styling & Themes
" ============================================================
syntax on
filetype plugin indent on

" Use PaperColor in high contrast dark mode (No Lua required)
colorscheme PaperColor

" Normal mode: block cursor
let &t_SI = "\<Esc>[6 q"   " Insert mode: vertical bar
let &t_EI = "\<Esc>[2 q"   " Normal mode: block
let &t_SR = "\<Esc>[4 q"   " Optional: replace mode cursor

" ============================================================
" 4. Key Mappings & Shortcuts
" ============================================================
nnoremap <leader>n :NERDTreeToggle<cr>

nnoremap <F1> :write<CR>
inoremap <F1> <Esc>:write<CR>
vnoremap <F1> <Esc>:write<CR>

" Search files by name in the current directory (Telescope find_files equivalent)
nnoremap <leader>f :Files<CR>

" Search text inside files using Ripgrep (Telescope live_grep equivalent)
nnoremap <leader>t :Rg<CR>

" Search through currently open buffers
nnoremap <leader>b :Buffers<CR>

" Search through your command history
nnoremap <leader>h :History:<CR>

" ============================================================
" 5. CoC Auto-Completion Settings
" ============================================================

" Autocomplete with Tab (cycles forward, triggers completion if word before cursor)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ Check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Confirm selection with <CR> (Enter key)
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()

" Helper function for Tab completion checking
function! Check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to manually force completion menu open
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
