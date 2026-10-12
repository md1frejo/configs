------------------------------------------------------------
-- HELIX-LIKE NEOVIM INIT.LUA
-- Goal: "batteries included" like Helix, minimal & modern
------------------------------------------------------------

------------------------------------------------------------
-- 0) Leader keys
------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

------------------------------------------------------------
-- 1) Basic options (Helix-ish defaults)
------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 200
vim.opt.timeoutlen = 400

vim.opt.clipboard = "unnamedplus"   -- system clipboard like helix

------------------------------------------------------------
-- 2) Bootstrap lazy.nvim (plugin manager)
------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- 3) Plugins
------------------------------------------------------------
require("lazy").setup({

  -- Treesitter = Helix highlight engine equivalent
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "html", "css", "javascript", "typescript", "tsx",
          "json", "yaml",
          "python", "go", "rust",
          "bash", "markdown",
        },
      })
    end
  },

  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Completion (Helix has built-in completion)
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Fuzzy finder like Helix file picker
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end
  },

  -- Nice diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end
  },

  -- Statusline minimal
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end
  },

  -- File explorer (optional, helix has file picker not tree)
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end
  },

  -- Theme (Helix ships with themes)
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme github_dark")
    end
  },
})

------------------------------------------------------------
-- 4) Completion config (TAB behaves like "select completion")
------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
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
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  }),
})

------------------------------------------------------------
-- 5) LSP setup (Helix-like: everything automatic)
------------------------------------------------------------
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Diagnostics UI
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Common on_attach
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- Helix-ish navigation
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "gi", vim.lsp.buf.implementation)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map("n", "<leader>ca", vim.lsp.buf.code_action)

  -- Diagnostics navigation
  map("n", "[d", vim.diagnostic.goto_prev)
  map("n", "]d", vim.diagnostic.goto_next)
end

-- Servers (add/remove as needed)
local servers = {
  "html",
  "cssls",
  "ts_ls",     -- modern typescript server
  "pyright",
  "gopls",
  "rust_analyzer",
  "bashls",
  "jsonls",
  "yamlls",
}

for _, server in ipairs(servers) do
  if lspconfig[server] then
    lspconfig[server].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end
end

------------------------------------------------------------
-- 6) Autoformat on save (Helix formats automatically)
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    -- format with LSP if available
    pcall(vim.lsp.buf.format, { async = false, timeout_ms = 1500 })
  end
})

------------------------------------------------------------
-- 7) Keymaps (Helix-style workflow)
------------------------------------------------------------
local map = vim.keymap.set

-- file picker
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { silent = true })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true })

-- diagnostics list
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { silent = true })

-- oil file manager (like dired / helix file open)
map("n", "<leader>e", "<cmd>Oil<CR>", { silent = true })

-- splits (helix has views)
map("n", "<C-x>2", "<cmd>split<CR>", { silent = true })
map("n", "<C-x>3", "<cmd>vsplit<CR>", { silent = true })
map("n", "<C-x>o", "<C-w>w", { silent = true })

-- save / quit
map("n", "<F1>", "<cmd>w<CR>", { silent = true })
map("n", "<F10>", "<cmd>q<CR>", { silent = true })

------------------------------------------------------------
-- Done
------------------------------------------------------------
