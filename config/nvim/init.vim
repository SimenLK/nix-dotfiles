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

" Show matching brackets
set showmatch
highlight MatchParen ctermbg=cyan

" Show line numbers
" set number
" set relativenumber

set nohlsearch

" Text width
set textwidth=79
set colorcolumn=+1
" hi ColorColumn ctermbg=White
autocmd FileType mail setlocal tw=79
autocmd FileType tex setlocal tw=79

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

map <F6> :setlocal spell! spelllang=en_us<CR>
map <F7> :setlocal spell! spelllang=nb<CR>

" Fzf
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>p :Files<CR>

"
" nvim-cmp: completions
"
function! s:nvim_cmp()
lua << EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-y>']     = cmp.mapping.confirm({ select = true }),
      ['<C-u>']     = cmp.mapping.scroll_docs(-4),
      ['<C-d>']     = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        { name = 'path' },
        { name = 'buffer' },
      })
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF
endfunction

"
" nvim-lsp
"
function! s:nvim_lsp()
lua << EOF
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end

        local opts = { noremap=true, silent=true }
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gh', '<cmd>lua vim.diagnostic.show()<CR>', opts) 
        buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts) 
        buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts) 
    end


    local capabilites = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local setup = function(server)
        server.setup {
            autostart = true,
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
            },
            capabilites = capabilites
        }
    end

    local lspconfig = require('lspconfig')
    setup(require('ionide'))
    setup(lspconfig.ccls)
    setup(lspconfig.tsserver)
    setup(lspconfig.rnix)
    -- setup(lspconfig.rust_analyzer)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { focusable = false }
    )
EOF
endfunction

" fsharp
" autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp
" lua require('lspconfig').fsautocomplete.setup{}

function! s:fsharp()
    let g:fsharp#lsp_auto_setup = 0

    autocmd FileType fsharp set signcolumn=yes tw=119

    " if has('nvim') && exists('*nvim_open_win')
    "     set updatetime=1000
    "     nmap K :call fsharp#showTooltip()<CR>
    "     "augroup FSharpShowTooltip
    "     "    autocmd!
    "     "    autocmd CursorHold *.fs,*.fsi,*.fsx call fsharp#showTooltip()
    "     "augroup END
    " endif

    let g:fsharp#exclude_project_directories = ['paket_files']
    let g:fsharp#fsautocomplete_command = ['fsautocomplete']
endfunction

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
        ignore_install = {},
        highlight = {
            enable = true,
            disable = { "latex" },
            additional_vim_regex_highlighting = false,
        },
    }
EOF
endfunction

call s:fsharp()
call s:nvim_cmp()
call s:nvim_lsp()
call s:nvim_treesitter()

" Latex settings
" NB: Don't need it because of spell shortcuts
" autocmd FileType tex setlocal wrap

" vimtex
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor = 'latex'

" Tmux
let g:tmux_navigator_no_mappings = 1

" Language specific

" vim
autocmd FileType vim set shiftwidth=2
autocmd FileType vim set tabstop=2

" tsx

autocmd FileType typescriptreact set shiftwidth=2
autocmd FileType typescriptreact set tabstop=2

" C/C++
" autocmd FileType cpp set tabstop=8
" autocmd FileType cpp set shiftwidth=8
" autocmd FileType cpp set noexpandtab

" SQL

autocmd FileType sql set shiftwidth=2
autocmd FileType sql set tabstop=2

" Yaml

autocmd FileType yaml set shiftwidth=2
autocmd FileType yaml set tabstop=2

" TeX
autocmd FileType tex set shiftwidth=2
autocmd FileType tex set tabstop=2

" Hyper Text Markup Language
autocmd FileType html set shiftwidth=2
autocmd FileType html set tabstop=2

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
