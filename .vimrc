call plug#begin('~/.vim/plugged')

" python plygins
Plug 'jeetsukumaran/vim-pythonsense', { 'for': 'python' }
"Plug 'nvie/vim-flake8'

"shared plugins
Plug 'Houl/repmo-vim'
Plug 'tpope/vim-commentary'
Plug 'unblevable/quick-scope'
Plug 'michaeljsmith/vim-indent-object'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'romainl/vim-cool'

if !has('nvim')
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'
endif

if has('nvim')
Plug 'ggandor/leap.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'mfussenegger/nvim-lint'
Plug 'bekaboo/deadcolumn.nvim'
Plug 'RRethy/vim-illuminate'

Plug 'olimorris/onedarkpro.nvim'
Plug 'zootedb0t/citruszest.nvim'
Plug 'Everblush/nvim'
endif

"colorschemes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'bignimbus/pop-punk.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'joshdick/onedark.vim'

call plug#end()

filetype plugin indent on
set termguicolors "enable full palette of colors
syntax on "syntax processing, colors
colorscheme onedark

" supress colorscheme bg color for terminal transparency
autocmd vimenter * hi! Normal ctermbg=NONE guibg=NONE 
" autocmd vimenter * hi! LineNr ctermbg=NONE guibg=NONE

" set syntax as custom pt for new buffers without syntax
au BufNewFile,BufEnter * if &syntax == '' | set syntax=pt | endif
" configs for nvim plugins
if has('nvim')
lua << EOF
    -- config treesitter
    require "nvim-treesitter.configs".setup {
        ensure_installed = { "c", "lua", "vim" , "python" },
        sync_install = true,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    }

    -- config lsp
    require'lspconfig'.pyright.setup{}
    
    -- config cmp
    local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local servers = { 'pyright' }
    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup {
        capabilities = capabilities
      }
    end

    local cmp = require'cmp'

    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                end
            end, { "i", "s" }),
                }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
        }, {
            { name = 'buffer' },
        })
    })

    --config linter
    require('lint').linters_by_ft = {
        python = {'pylint',}
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- config leap
    require('leap').create_default_mappings()

    -- config telescope
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    vim.cmd("colorscheme citruszest")
EOF
endif

" configs for shared plugins
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


set mouse=a
set scrolloff=3

"spaces and tabs
set tabstop=4		"number of visual spaces for tab
set softtabstop=4	"number of spaces for tab when editing
set shiftwidth=4
set expandtab		"tabs = spaces
set autoindent

"set cursorline		"line the cursor are on goes highlighted
set wildmenu 		"when tab to complete, appears a zsh-like menu
set wildmode=list:longest,full
set wildignore=__pycache__
set showmatch		"highlight matching [{()}]

set encoding=utf-8 "set encode to utf-8
set showcmd         "show last command entered
set hidden          "hide buffers instead of closing them, 
set formatoptions-=o    "dont continue comments when typing o/O

"search
set incsearch 		"search as characters are entered
set hlsearch		"highlight searches
set ignorecase       "ignore case if search is all lowercase

set noshowmode      "dont shwo mode changes below statusline
set nojoinspaces    "dont join spaces

hi StatusLine ctermbg=NONE guibg=NONE

function! StatusMode() abort
  let l:modes={
         \ 'n'  : 'normal',
         \ 'v'  : 'visual',
         \ 'V'  : 'vi-lin',
         \ "\<C-V>" : 'vi-blk',
         \ 'i'  : 'insert',
         \ 'R'  : 'rplace',
         \ 'Rv' : 'vi-rpl',
         \ 'c'  : 'cmmand',
         \}

  return l:modes[mode()]
endfunction

function! GitBranch() abort
  let l:is_branch = system("git rev-parse --abbrev-ref HEAD")
  if l:is_branch !~ 'fatal'
    return trim(l:is_branch)
  else
    return ''
  endif
endfunction

" component for active window
function! StatuslineActive()
    let w:mode = '%#Type#%{StatusMode()}%*'
    let l:buffer = ' %n |'
    let l:branch = " %#Comment#%{GitBranch()}%*"
    let l:filename = ' %#Function#%f%*'
    let l:modified = ' %#Error#%M%*'
    return w:mode.l:buffer.l:branch.l:filename.l:modified
endfunction

" component for inactive window
function! StatuslineInactive()
    let l:buffer = '%n |'
    let l:filename = ' %f'
    let l:modified = ' %M'
    return 'inactv '.l:buffer.l:filename.l:modified
endfunction

function! StatuslineDefault()
  let l:sep = '%='
  let l:ftro = '%y%r '
  let l:context = '%-4(%l-%L,%c%)'
  return l:sep.l:ftro.l:context
endfunction

" load statusline using `autocmd` event with this function
function! StatuslineLoad(mode)

  if a:mode ==# 'active'
    setlocal statusline=%!StatuslineActive().StatuslineDefault()
  else
    setlocal statusline=%!StatuslineInactive().StatuslineDefault()
  endif

  "l:sep..l:ftro.l:context
endfunction

augroup statusline_startup
  autocmd!
  autocmd BufEnter,FocusGained,WinEnter * call StatuslineLoad('active')
  autocmd BufEnter,FocusGained,WinEnter * call GitBranch()
  autocmd BufLeave,FocusLost,WinLeave * call StatuslineLoad('inactive')
augroup END

set autochdir "change the directory to the directory of the opened file

"set hybrid number line
set nu rnu

" rules to change number line according to mode
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

set clipboard=unnamedplus

set splitbelow
set splitright

"load the respective config file of the language
au BufRead,BufNewFile *.py set filetype=python

"newline without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
nnoremap Y y$

nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>pv :Ex<CR>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap gb <C-^>
" nnoremap <leader>b :bn<CR>
nnoremap <leader>d :bd<CR>

nnoremap [b :bp<cr>
nnoremap ]b :bn<cr>

"noremap <silent> k gk
"noremap <silent> j gj
