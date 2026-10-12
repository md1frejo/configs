local vim = vim
local Plug = vim.fn['plug#']

vim.call("plug#begin", "~/.local/share/nvim/plugged")


Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug('junegunn/vim-easy-align')
-- Any valid git URL is allowed
Plug('https://github.com/junegunn/seoul256.vim.git')

-- Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug('fatih/vim-go', { ['tag'] = '*' })

-- Using a non-default branch
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })

-- Post-update hook can be a lambda expression
Plug('junegunn/fzf', { ['do'] = function()
  vim.fn['fzf#install']()
end })

-- If the vim plugin is in a subdirectory, use 'rtp' option to specify its path
Plug('nsf/gocode', { ['rtp'] = 'vim' })

-- On-demand loading: loaded when the specified command is executed
Plug('preservim/nerdtree', { ['on'] = 'NERDTreeToggle' })

-- On-demand loading: loaded when a file with a specific file type is opened
Plug('tpope/vim-fireplace', { ['for'] = 'clojure' })

Plug 'nvim-tree/nvim-web-devicons' 

Plug 'nvim-tree/nvim-tree.lua'

Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-lua/plenary.nvim'

Plug 'elixir-lang/vim-elixir'

Plug 'renerocksai/telekasten.nvim'

Plug 'itchyny/calendar.vim'

Plug 'stevearc/oil.nvim'

Plug 'folke/tokyonight.nvim'

Plug 'folke/which-key.nvim'

Plug 'folke/trouble.nvim'

Plug 'folke/todo-comments.nvim'

Plug 'rcarriga/nvim-notify'

Plug 'catppuccin/nvim'

Plug 'oxfist/night-owl.nvim'

Plug 'morhetz/gruvbox'

Plug 'glepnir/zephyr-nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'AlexvZyl/nordic.nvim'

Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'rafamadriz/friendly-snippets'

Plug 'norcalli/nvim-colorizer.lua'

Plug 'akinsho/nvim-bufferline.lua'

Plug "rebelot/kanagawa.nvim"

Plug 'sheerun/vim-polyglot'

Plug 'nvim-lualine/lualine.nvim'

Plug 'nosduco/remote-sshfs.nvim'

Plug 'nvimdev/epo.nvim'

Plug 'gennaro-tedesco/nvim-peekup'

Plug 'gregsexton/atom'

Plug 'NLKNguyen/papercolor-theme'

Plug 'dikiaap/minimalist'

Plug 'sts10/vim-pink-moon'

Plug 'jaredgorski/spacecamp'

Plug 'marcopaganini/termschool-vim-theme'

Plug 'jacoborus/tender.vim'

Plug 'echasnovski/mini.nvim'

Plug 'echasnovski/mini.files'

Plug "elihunter173/dirbuf.nvim"

Plug 'GustavoPrietoP/doom-themes.nvim'

Plug 'tversteeg/registers.nvim'

Plug 'projekt0n/github-nvim-theme'

Plug 'protesilaos/tempus-themes'

Plug 'lifepillar/vim-solarized8'

Plug 'katawful/kat.nvim'

Plug 'nvim-orgmode/orgmode'

Plug 'SidOfc/carbon.nvim'

vim.call("plug#end")

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<TAB>'] = cmp.mapping.select_next_item(),
    ['<S-TAB>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
        end
      end, { "i", "s" }),

    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require("lspconfig")

lspconfig.emmet_ls.setup({
  filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
})

require('lspconfig').html.setup { capabilities = capabilities }
require('lspconfig').cssls.setup { capabilities = capabilities }
require('lspconfig').ts_ls.setup { capabilities = capabilities }

vim.opt.shell = "/usr/bin/fish"

require("carbon").setup({
  auto_open = false,
})

require('mini.files').setup()

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
-- vim.opt.termguicolors = true

-- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
-- add ~org~ to ignore_install
-- require('nvim-treesitter.configs').setup({
--   ensure_installed = 'all',
--   ignore_install = { 'org' },
-- })

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'ag',
      '-i',
      '-l',
    },
    -- other configurations...
  }
}

require'bufferline'.setup{
  options = {
    diagnostics = "nvim_lsp",
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
  }
}

-- Key mappings for buffer navigation
vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

require("nvim-treesitter.configs").setup({
  ensure_installed = { "html", "css", "javascript", "typescript", "lua", "elixir" },
  highlight = { enable = true },
})

require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
})

require('telekasten').setup({
  home = vim.fn.expand("~/Dropbox/prog/nvim/telekasten"), -- Put the name of your notes directory here
})

require("oil").setup()

-- Disable GUI colors and use terminal colors
--vim.opt.termguicolors = false

vim.cmd 'colorscheme github_dark_high_contrast' 

--require("night-owl").setup()
--vim.cmd.colorscheme("night-owl")

vim.api.nvim_set_keymap('n', '<F1>', ':w<CR>', { noremap = true, silent = true })
-- save
vim.keymap.set("n", "<F2>", "<cmd>Carbon<CR>", { silent = true, desc = "Open Carbon" })

---vim.api.nvim_set_keymap('n', '<F2>', ':Carbon<CR>', { noremap = true, silent = true })
-- file manager
vim.api.nvim_set_keymap('n', '<F3>', ':vsp<CR>', { noremap = true, silent = true })
-- new window
vim.api.nvim_set_keymap('n', '<F4>', ':edit ~/.config/nvim/init.lua <CR>', { noremap = true, silent = true })
-- edit init.lua
vim.api.nvim_set_keymap('n', '<F5>', ':Telescope live_grep<CR>', { noremap = true, silent = true })
-- telescope
vim.api.nvim_set_keymap('n', '<F6>', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F7>', ':colorscheme ', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F8>', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F9>', ':ls<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ':q<CR>', { noremap = true, silent = true })
--vim.opt.foldmethod=indent

-- remap keys
---vim.api.nvim_set_keymap('n', '<Left>', 'h', { noremap = true, silent = true })
---vim.api.nvim_set_keymap('v', '<Left>', 'h', { noremap = true, silent = true })
---vim.api.nvim_set_keymap('n', '<Right>', 'l', { noremap = true, silent = true })
---vim.api.nvim_set_keymap('v', '<Right>', 'l', { noremap = true, silent = true })

vim.opt.foldmethod="indent"
-- Start with all folds closed
vim.opt.foldlevel = 1
-- Enable folding
vim.opt.foldenable = true

-- user defiend commands

-- python macos in lua/python.lua
require('python')

function dli()
-- delete character and go to insert mode
    vim.api.nvim_command('normal! x')
    vim.api.nvim_command('startinsert')
end

vim.api.nvim_set_keymap('n', '<C-x>', ':lua dli()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', ':lua sfd()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-d>', ':lua sfb()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', ':lua Cins()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-b>', ':lua Bins()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'c', ':lua cpr()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', '/', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<C-a>', 'vimgrep', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-m>', ':lua MiniFiles.open()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':Dirbuf<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-A-b>', '?', { noremap = true, silent = true })

