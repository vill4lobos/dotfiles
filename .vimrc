call plug#begin('~/.vim/plugged')

" python plygins
"Plug 'dense-analysis/ale'
"Plug 'davidhalter/jedi-vim'
Plug 'jeetsukumaran/vim-pythonsense', { 'for': 'python' }
"Plug 'nvie/vim-flake8'
"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" legacy
"Plug 'sjbach/lusty'
"Plug 'vds2212/vim-remotions'
"Plug 'vim-scripts/ReplaceWithRegister'
"Plug 'jpalardy/vim-slime'

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
" Plug 'freddiehaddad/feline.nvim'
Plug 'bekaboo/deadcolumn.nvim'
"Plug 'nanozuki/tabby.nvim'
Plug 'RRethy/vim-illuminate'
" Plug 'nvimdev/hlsearch.nvim'

Plug 'olimorris/onedarkpro.nvim'
Plug 'maxmx03/fluoromachine.nvim'
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

    -- config colorschemes
    require('fluoromachine').setup {
        glow = false,
        theme = 'fluoromachine',
        transparent = 'full',
        overrides = {
            ['@function'] = { italic = false },
            ['@comment'] = { italic = false },
            ['@parameter'] = { italic = false },
            ['@type'] = { italic = false },
            }
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

nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>pv :Ex<CR>

"layout
set laststatus=2
"statusline
set statusline=                 "init
set statusline+=\ %(%l-%L%)     "line number and line total
set statusline+=\ <<\ %f\ >>   "file name
"set statusline+=\ %t
"set statusline+=\ /%{Wd()}/
"set statusline+=\ %{getcwd()}
set statusline+=\ %y
set statusline+=%(%m%r%w%)   "file type
set statusline+=[%n]
set statusline+=%=              "right align
"set statusline+=%-5.{strftime('%a\ %I:%M\ %p')}
set statusline+=%-7{strftime('%I:%M')}
set statusline+=%-4(%l,%c%V%)\ %P "set character and column number and percentage

set autochdir "change the directory to the directory of the opened file


"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"noremap <silent> k gk
"noremap <silent> j gj

"nnoremap <Up> <gk>
"nnoremap <Down> <gj>

"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>

"set hybrid number line
set nu rnu

" rules to change number line according to mode
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

set clipboard=unnamedplus

set splitbelow
set splitright

"load the respective config file of the language
au BufRead,BufNewFile *.py set filetype=python

"newline without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

"map motions to repmo (it's necessary to supress map in plugin of origin)
map <expr> ]m repmo#Key('<plug>(PythonsenseStartOfNextPythonFunction)', '<plug>(PythonsenseStartOfPythonFunction)')|sunmap ]m
map <expr> [m repmo#Key('<plug>(PythonsenseStartOfPythonFunction)', '<plug>(PythonsenseStartOfNextPythonFunction)')|sunmap [m
map <expr> ]b repmo#Key(':bn<CR>', ':bp<CR>')|sunmap ]b
map <expr> [b repmo#Key(':bp<CR>', ':bn<CR>')|sunmap [b

map <expr> f repmo#ZapKey('<Plug>(QuickScopef)')|sunmap f
map <expr> F repmo#ZapKey('<Plug>(QuickScopeF)')|sunmap F
map <expr> t repmo#ZapKey('<Plug>(QuickScopet)')|sunmap t
map <expr> T repmo#ZapKey('<Plug>(QuickScopeT)')|sunmap T

if !has('nvim')
    "sneak show labels
    let g:sneak#label = 1

    "change default fFtT to sneak behavior
    " map f <Plug>Sneak_f
    " map F <Plug>Sneak_F
    " map t <Plug>Sneak_t
    " map T <Plug>Sneak_T

    map  <expr> ; repmo#LastKey('<Plug>Sneak_;')|sunmap ;
    map  <expr> , repmo#LastRevKey('<Plug>Sneak_,')|sunmap ,

    map  <expr> s repmo#ZapKey('<Plug>Sneak_s')|ounmap s|sunmap s
    map  <expr> S repmo#ZapKey('<Plug>Sneak_S')|ounmap S|sunmap S
    " map  <expr> f repmo#ZapKey('<Plug>Sneak_f')|sunmap f
    " map  <expr> F repmo#ZapKey('<Plug>Sneak_F')|sunmap F
    " map  <expr> t repmo#ZapKey('<Plug>Sneak_t')|sunmap t
    " map  <expr> T repmo#ZapKey('<Plug>Sneak_T')|sunmap T
else
    map <expr> ; repmo#LastKey(';')|sunmap ;
    map <expr> , repmo#LastRevKey(',')|sunmap ,
endif
