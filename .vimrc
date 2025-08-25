call plug#begin('~/.vim/plugged')

"shared plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'unblevable/quick-scope'
Plug 'romainl/vim-cool'

if !has('nvim')
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-commentary'
Plug 'Houl/repmo-vim'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'psliwka/vim-smoothie'
endif

if has('nvim')
" lsp, treesitter, cmp, languages
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-lua/plenary.nvim'

" cmp, linter
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/vim-vsnip'
Plug 'mfussenegger/nvim-lint'

" mini
Plug 'echasnovski/mini.files'
Plug 'echasnovski/mini.starter'
Plug 'echasnovski/mini.sessions'
Plug 'echasnovski/mini.pick'
Plug 'echasnovski/mini.extra'
Plug 'echasnovski/mini.ai'
Plug 'echasnovski/mini.pairs'

" navigation
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'lewis6991/gitsigns.nvim'
Plug 'ggandor/leap.nvim'
" Plug 'otavioschwanck/arrow.nvim'
" Plug 'j-morano/buffer_manager.nvim'
" Plug 'toppair/reach.nvim'

" folke
Plug 'folke/flash.nvim'
Plug 'folke/snacks.nvim'
Plug 'folke/trouble.nvim'

" utils, misc
Plug 'nvim-tree/nvim-web-devicons'
Plug 'bekaboo/deadcolumn.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'numToStr/Comment.nvim'
Plug 'nat-418/boole.nvim'
" Plug 'mistricky/codesnap.nvim', { 'do': 'make' }
"Plug 'JoosepAlviste/nvim-ts-context-commentstring'
"Plug 'ray-x/lsp_signature.nvim'
" Plug 'kawre/leetcode.nvim'
" Plug 'MunifTanjim/nui.nvim'
Plug 'subnut/nvim-ghost.nvim'

"colorschemes
"aura, carbonfox
Plug 'olimorris/onedarkpro.nvim'
Plug 'zootedb0t/citruszest.nvim'
Plug 'scottmckendry/cyberdream.nvim'
Plug 'Everblush/nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
endif

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'bignimbus/pop-punk.vim'
" Plug 'catppuccin/vim', { 'as': 'catppuccin_vim' }
Plug 'joshdick/onedark.vim'
call plug#end()

filetype plugin indent on
set termguicolors "enable full palette of colors
syntax on "syntax processing, colors

if !has('nvim')
    colorscheme onedark
endif

" set syntax as custom pt for new buffers without syntax
au BufNewFile,BufReadPost * if &syntax == '' | set syntax=pt | endif

" configs for nvim plugins
if has('nvim')
lua << EOF
    -- config treesitter
    require "nvim-treesitter.configs".setup {
        ensure_installed = { "c", "lua", "vim" , "python", "javascript", "bash",
                             "markdown", "tsx", "json", "html", "css", "rust", "go"},
        sync_install = true,
        auto_install = true,
        event = { "BufReadPre", "BufNewFile" },
        highlight = { enable = true },
        indent = { enable = true },
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>e",
            node_incremental = "<leader>e",
            scope_incremental = false,
            node_decremental = "<leader>r",
          },
        },
    
    }

    -- config treesitter textobjects
    require'nvim-treesitter.configs'.setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
            ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

            ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

            ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
            }
          },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner",
          },
        },
      },
    }
    
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- config lsp
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    vim.api.nvim_create_autocmd('LspAttach', {

        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
        vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        -- vim.keymap.set('n', '<space>f', function()
        --     vim.lsp.buf.format { async = true }
        -- end, opts)
      end,
    })
    
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
    local servers = { 'pyright', 'ts_ls', 'html', 'cssls',
                      'emmet_language_server', 'rust_analyzer', 'ccls' }

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
        }, {
            { name = 'nvim_lsp_signature_help' }
        })
    })

    -- config linter
    require('lint').linters_by_ft = {
        python = {'pylint',}
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

     vim.diagnostic.config {
       virtual_text = false,
       signs = true,
       underline = false,
     }

    -- config leap
    require('leap').create_default_mappings()

    -- config fzf-lua
    require('fzf-lua').setup({
      'fzf-native'
    })
    
    local fzf = require('fzf-lua')
    -- open files
    vim.keymap.set('n', '<leader>r', fzf.lsp_references, {})
    vim.keymap.set('n', '<leader>g', fzf.live_grep, {})
    vim.keymap.set('n', '<leader>s', fzf.lsp_document_symbols, {})

    -- config gitsigns
    require('gitsigns').setup({

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hR', gs.reset_buffer)
      end
    })

    -- config mini
    require("mini.files").setup({
            options = {
                permanent_delete = true,
                use_as_default_explorer = true,
            },
    })
    -- vim.keymap.set('n', '<leader>f', "<cmd>lua MiniFiles.open()<CR>", {})

    local starter = require('mini.starter')
    require("mini.starter").setup({
        query_updaters = 'abcdefgimnopqrstuvwxyz0123456789_-.',
        evaluate_single = true,
        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(7, false),
          starter.sections.recent_files(3, true),
          starter.sections.sessions(3, true)
        }
    })

    require("mini.sessions").setup()
    require('mini.pick').setup()
    require('mini.extra').setup()

    -- config boole
    require('boole').setup({
      mappings = {
        increment = '<C-a>',
        decrement = '<C-x>'
      }
    })

    -- config Comment
    require('Comment').setup()

    require("cyberdream").setup({
        transparent = true,
        italic_comments = false,
        hide_fillchars = true,
        borderless_telescope = false,
        terminal_colors = true,
        -- extensions = {
        --     fzflua = true,
        -- },
    })

    vim.keymap.set('n', '<leader><leader>', '<cmd>ReachOpen buffers<CR>', {})
    vim.keymap.set('n', '<leader>hh', '<cmd>Gitsigns setloclist<CR>', {})
    vim.keymap.set('n', '<leader>m', '<cmd>Pick marks<CR>', {})
    vim.keymap.set('n', '<leader><Tab>', '<cmd>Pick buffers<CR>', {})
    vim.keymap.set('n', '<leader>b', '<cmd>Pick buffers<CR>', {})
    vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', {})
    vim.keymap.set('n', '<leader>f', "<cmd>Pick files<CR>", {})

    require('trouble').setup({
        focus = true
    })

    vim.cmd("colorscheme cyberdream")

    require('reach').setup({
      notifications = true
    })

    vim.api.nvim_set_hl(0, "Normal", {guibg=NONE, ctermbg=NONE})
EOF
endif

" supress colorscheme bg color for terminal transparency
" autocmd VimEnter,SourcePost * highlight Normal ctermbg=NONE guibg=NONE 
highlight Normal ctermbg=NONE guibg=NONE 

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
set wildmode=full:lastused
" set wildmode=list:longest,full
set wildoptions=pum
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
         \ 't'  : 'fzflua',
         \}

  return l:modes[mode()]
endfunction

function! GitBranch() abort
  let l:is_branch = system("git rev-parse --abbrev-ref HEAD")
  if l:is_branch !~ 'fatal'
    let l:is_dirty = system("git diff-index --quiet HEAD 2> /dev/null")
    if v:shell_error != 0
      return ' %#Error#'..trim(l:is_branch)..'%*'
    else
      return ' %#Comment#'..trim(l:is_branch)..'%*'
    endif
  else
    return ''
  endif
endfunction

" component for active window
function! StatuslineActive()
    let w:mode = '%#Type#%{StatusMode()}%*'
    let l:buffer = ' %n |'
    let l:branch = GitBranch()
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

"nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>pv :Ex<CR>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap gb <C-^>
" nnoremap <leader>b :bn<CR>
" nnoremap <leader>d :bd<CR>

nnoremap [b :bp<cr>
nnoremap ]b :bn<cr>
nnoremap <Tab> <C-^>
nnoremap <S-Tab> :bp<cr>
nnoremap <C-Tab> :bn<cr>
" nnoremap <leader><leader> :b^<cr>

"noremap <silent> k gk
"noremap <silent> j gj
