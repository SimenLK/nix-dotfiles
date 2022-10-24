" This is a test comment
" execute pathogen#infect()

set nocompatible
filetype plugin indent on

" Tap options - 4 spaces
set shiftwidth=4
set tabstop=4
set expandtab

" If there are local vimrc
set exrc

set shell=/bin/sh

" Indenting
autocmd FileType c set cindent
autocmd FileType haskell set smartindent

" Set path to search folders from root to allow for fuzzy search
set path+=**
set cmdheight=2

" Syntax highlighting
syntax on

" Highlight yanking
au TextYankPost * silent! lua vim.highlight.on_yank()

" Colorscheme
set termguicolors
colorscheme NeoSolarized

" Background
" set background=light

" Show matching brackets
set showmatch
highlight MatchParen guibg=cyan

" highlight NonText gui=italic guifg=DarkGray

" Show line numbers
" set number
" set relativenumber

set nohlsearch

" Text width
set textwidth=120
set colorcolumn=120
" hi ColorColumn ctermbg=White
autocmd FileType mail setlocal tw=80
autocmd FileType tex setlocal tw=79 colorcolumn=80

" Whitespace and tabs
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨
" set list

" Wildmenu
" set wildmenu
set wildmode=full

" Increase update time
set updatetime=300

" Commands
command! MakeTags !ctags -R .

" Bindings
let mapleader = " "

" TeX shortcuts
autocmd FileType tex nnoremap <leader>b :w<CR> :! pdflatex %<CR>

" Terminal mode
tnoremap <Esc> <C-\><C-N>

" Fugitive
nmap <leader>gs :G<CR>
nmap <leader>gp :diffput<CR>
nmap <leader>gn :diffget //3<CR>
nmap <leader>gt :diffget //2<CR>

" tmux vim navigation
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>

nnoremap <silent> <Bar> <C-w><Bar><CR>

map <C-N> :Ex<CR>

nnoremap <C-c> <C-w>c
" inoremap jk <Esc> " Not needed with colemak

map <F6> :setlocal spell! spelllang=en_us<CR>
map <F7> :setlocal spell! spelllang=nb<CR>

" Fzf
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>p :Files<CR>

" === nvim-lsp ===

" F#
au BufNewFile,BufRead *.fsproj set filetype=xml 
" lua require'lspconfig'.fsautocomplete.setup{}
" let g:fsharp#lsp_auto_setup = 0

" lua require('lspconfig').fsautocomplete.setup{}

" Rust
lua require('lspconfig').rust_analyzer.setup{}

" Typescript
lua require('lspconfig').tsserver.setup{}
autocmd FileType typescript set signcolumn=yes


" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#lsp#handler_enabled = 1
let g:deoplete#lsp#use_icons_for_candidates = 1

" Latex settings
" NB: Don't need it because of spell shortcuts
" autocmd FileType tex setlocal wrap

" vimtex
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'

" Tmux
let g:tmux_navigator_no_mappings = 1

" Language specific

" tsx

autocmd FileType typescriptreact set shiftwidth=2
autocmd FileType typescriptreact set tabstop=2
autocmd FileType typescriptreact set expandtab

" HTML

autocmd FileType html set shiftwidth=2
autocmd FileType html set tabstop=2
autocmd FileType html set expandtab

" SQL

autocmd FileType sql set shiftwidth=2
autocmd FileType sql set tabstop=2
autocmd FileType sql set expandtab

" Yaml

autocmd FileType yaml set shiftwidth=2
autocmd FileType yaml set tabstop=2
autocmd FileType yaml set expandtab

" Tex
autocmd FileType tex set shiftwidth=2
autocmd FileType tex set tabstop=2
autocmd FileType tex set expandtab


" Statusline

set laststatus=2

" hi StatusLine ctermfg=8 ctermbg=3 cterm=NONE
" hi StatusLineNC ctermfg=2 ctermbg=8 cterm=NONE

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %f
set statusline+=\ %2*[%M%R%H%W]%*
" Right side of statusline
set statusline+=%#CursorColumn#
set statusline+=%=
set statusline+=\ [%{&fo}]
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
