-- ==========================================================
-- Minimal Neovim init.lua
-- lazy.nvim + Carbon + Telescope
-- ==========================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic options (minimal)
vim.opt.number = true
vim.opt.relativenumber = false 
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true

-- ==========================================================
-- Bootstrap lazy.nvim
-- ==========================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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

{
  "neovim/nvim-lspconfig",
},
      
{
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000,
  config = function()
    require("github-theme").setup({
      -- optional: only put overrides here
      options = {
        transparent = false,
      },
    })

    -- Pick ONE colorscheme
    vim.cmd("colorscheme github_dark_high_contrast")
  end,
},
  -- icons (needed for carbon)
  { "nvim-tree/nvim-web-devicons" },

  -- Carbon file manager
  {
    "SidOfc/carbon.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("carbon").setup({
        auto_open = false,
      })
    end,
  },

  -- Telescope dependency
  { "nvim-lua/plenary.nvim" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  rocks = {
    enabled = false,
  },
})

  
-- ==========================================================
-- Keymaps
-- ==========================================================

-- Carbon
vim.keymap.set("n", "<F2>", "<cmd>Carbon<CR>", { silent = true, desc = "Open Carbon" })

-- Telescope
vim.keymap.set("n", "<F5>", "<cmd>Telescope live_grep<CR>", { silent = true, desc = "Live grep" })
vim.keymap.set("n", "<F6>", "<cmd>Telescope find_files<CR>", { silent = true, desc = "Find files" })
-- Save in normal mode
vim.keymap.set("n", "<F1>", "<cmd>w<CR>", { desc = "Save file" })

-- Save in insert mode
vim.keymap.set("i", "<F1>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Save in visual mode
vim.keymap.set("v", "<F1>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Save in select mode (optional)
vim.keymap.set("s", "<F1>", "<Esc><cmd>w<CR>", { desc = "Save file" })


vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", {
  desc = "Switch buffer"
})
-- Lazy
vim.keymap.set("n", "<F12>", "<cmd>Lazy<CR>", { silent = true, desc = "Lazy UI" })

vim.keymap.set("n", "<C-c>", "<cmd>edit $MYVIMRC<CR>", {
  desc="Open init.lua",
})

-- ==========================================================
-- Bookmarks
-- ==========================================================

vim.api.nvim_create_user_command("Prog", function()
  vim.cmd("cd ~/Dropbox/prog")
end, {})

vim.api.nvim_create_user_command("Web", function()
  vim.cmd("cd ~/Dropbox/prog/web")
end, {})
