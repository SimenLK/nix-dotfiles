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
set t_8f=[38;2;%lu;%lu;%lum
set t_8f=[48;2;%lu;%lu;%lum
set termguicolors
colorscheme NeoSolarized


" Show matching brackets
set showmatch
highlight MatchParen ctermbg=cyan

" Show line numbers
set number
set relativenumber

set nohlsearch

" Text width
" set textwidth=80
set colorcolumn=80
" hi ColorColumn ctermbg=White
autocmd FileType mail setlocal tw=79
autocmd FileType tex setlocal tw=79

" Whitespace and tabs
set listchars=tab:>\ ,nbsp:_,trail:⋅
set list

" Do not wrap lines
" set nowrap

" Split
set splitright
set splitbelow

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
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>

"nmap <leader>gd <Plug>(lcn-definition)
"nmap <leader>gr <Plug>(lcn-references)

" tmux vim navigation
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>

nnoremap <silent> <Bar> <C-w><Bar><CR>

map <C-N> :Ex<CR>

nnoremap <C-c> <C-w>c
" inoremap jk <Esc> " Not needed with moonlander

map <F6> :setlocal spell! spelllang=en_us<CR>
map <F7> :setlocal spell! spelllang=nb<CR>

" Fzf
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>p :Files<CR>

" nvim-lsp

" I don't have nvim_cmp which is for autocomplete, I have deoplete
function! s:nvim_cmp()
lua << EOF
    local cmp = require'cmp'

    cmp.setup({
        mapping = {
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' }
        })
    })
EOF
endfunction

function! s:nvim_lsp()
lua << EOF
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end

        local opts = { noremap=true, silent=true }
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    end

    -- local capabilites = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local setup = function(server)
        server.setup {
            autostart = true,
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
            }
            -- capabilites = capabilites
        }
    end
    local lspconfig = require('lspconfig')
    setup(require('ionide'))
    setup(lspconfig['rnix-lsp'])
    setup(lspconfig.ccls) -- maybe
    -- setup(require('rust_analyzer'))
    -- setup(require('tsserver'))

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { focusable = false }
    )
EOF
endfunction

" cpp
" autocmd FileType cpp set signcolumn=yes
" lua require('lspconfig').clangd.setup{}

" fsharp
" autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp
" lua require('lspconfig').fsautocomplete.setup{}

autocmd FileType fsharp set signcolumn=yes

if has('nvim') && exists('*nvim_open_win')
    set updatetime=1000
    augroup FSharpShowTooltip
        autocmd!
        autocmd CursorHold *.fs,*.fsi,*.fsx call fsharp#showTooltip()
    augroup END
endif

" cpp
autocmd FileType cpp set signcolumn=yes

" rust
autocmd FileType rust set signcolumn=yes

" typescript
autocmd FileType typescript set signcolumn=yes

" nix
" lua require('lspconfig').rnix-lsp.setup{}

function! s:nvim_treesitter()
lua << EOF
    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "cpp" },
        sync_install = false,
        auto_install = true,
        ignore_install = { "javascript" },
        highlight = {
            enable = true,
            disable = { "latex" },
            additional_vim_regex_highlighting = false,
        },
    }
EOF
endfunction

call s:nvim_lsp()
call s:nvim_treesitter()

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

" C/C++
" autocmd FileType cpp set tabstop=8
" autocmd FileType cpp set shiftwidth=8
" autocmd FileType cpp set noexpandtab

" SQL

autocmd FileType sql set shiftwidth=2
autocmd FileType sql set tabstop=2
autocmd FileType sql set expandtab

" Yaml

autocmd FileType yaml set shiftwidth=2
autocmd FileType yaml set tabstop=2
autocmd FileType yaml set expandtab

" TeX
autocmd FileType tex set shiftwidth=2
autocmd FileType tex set tabstop=2
autocmd FileType tex set expandtab

" Hyper Text Markup Language
autocmd FileType html set shiftwidth=2
autocmd FileType html set tabstop=2
autocmd FileType html set expandtab

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
