-- ==========================================================
-- Neovim init.lua (clean + stable)
-- Plugin manager: lazy.nvim
-- ==========================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.shell = "/usr/bin/fish"

-- disable netrw (needed for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 1
vim.opt.foldenable = true

-- ==========================================================
-- Bootstrap lazy.nvim
-- ==========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================
-- Plugins
-- ==========================================================
require("lazy").setup({
  -- Colorscheme
  { "projekt0n/github-nvim-theme", priority = 1000 },

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Telescope
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },

  -- File tree
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua" },

  -- Bufferline tabs
  { "akinsho/bufferline.nvim", version = "*" },

  -- Carbon file manager
  { "SidOfc/carbon.nvim" },
})

-- ==========================================================
-- Colorscheme
-- ==========================================================
vim.cmd.colorscheme("github_dark_high_contrast")

-- ==========================================================
-- Treesitter
-- ==========================================================
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "typescript",
    "elixir",
    "heex",
    "eex",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- ==========================================================
-- Telescope
-- ==========================================================
require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
})

-- ==========================================================
-- nvim-tree
-- ==========================================================
require("nvim-tree").setup({
  view = { width = 30, side = "left" },
})

-- ==========================================================
-- bufferline
-- ==========================================================
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    offsets = {
      { filetype = "NvimTree", text = "File Explorer", text_align = "left" },
    },
  },
})

vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })

-- ==========================================================
-- Carbon
-- ==========================================================
require("carbon").setup({
  auto_open = false,
})

vim.keymap.set("n", "<F2>", "<cmd>Carbon<CR>", { silent = true, desc = "Open Carbon" })

-- ==========================================================
-- CMP (Completion)
-- ==========================================================
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

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
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  }),
})

-- ==========================================================
-- LSP Setup
-- ==========================================================
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- HTML / CSS / TS
lspconfig.html.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.tsserver.setup({ capabilities = capabilities })

-- Emmet
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
})

-- Elixir (requires elixir-ls installed on system)
lspconfig.elixirls.setup({
  capabilities = capabilities,
  cmd = { "elixir-ls" },
})

-- ==========================================================
-- Keymaps (your F-keys kept)
-- ==========================================================
vim.keymap.set("n", "<F1>", "<cmd>w<CR>", { silent = true, desc = "Save" })
vim.keymap.set("n", "<F3>", "<cmd>vsp<CR>", { silent = true })
vim.keymap.set("n", "<F4>", "<cmd>edit ~/.config/nvim/init.lua<CR>", { silent = true })
vim.keymap.set("n", "<F5>", "<cmd>Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<F6>", "<cmd>Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<F8>", "<cmd>bd<CR>", { silent = true })
vim.keymap.set("n", "<F9>", "<cmd>ls<CR>", { silent = true })
vim.keymap.set("n", "<F10>", "<cmd>q<CR>", { silent = true })
