vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function toggle_number_mode()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  elseif vim.wo.number then
    vim.wo.number = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.keymap.set("n", "<C-l>", "<C-]>", {
      buffer = true,
      silent = true,
    })
  end,
})

function ToggleWarnings()
  show_warnings = not show_warnings

  if show_warnings then
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
    })
    print("Warnings ON")
  else
    vim.diagnostic.config({
      virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
      signs = { severity = { min = vim.diagnostic.severity.ERROR } },
      underline = { severity = { min = vim.diagnostic.severity.ERROR } },
    })
    print("Warnings OFF (errors only)")
  end
end

vim.keymap.set("n", "<leader>fg", function()

  local default = vim.fn.expand("%:p:h")
  local cwd = vim.fn.input("Search directory: ", default, "dir")

  if cwd == "" then
    cwd = default
  end

  require("fzf-lua").live_grep({
    cwd = cwd
  })

end, { desc = "FZF grep (prompt dir)" })

vim.keymap.set("n", "<leader>ff", function()

  local default = vim.fn.expand("%:p:h")
  local cwd = vim.fn.input("File directory: ", default, "dir")

  if cwd == "" then
    cwd = default
  end

  require("fzf-lua").files({
    cwd = cwd
  })

end, { desc = "FZF files (custom cwd)" })

vim.keymap.set("n", "K", vim.diagnostic.open_float, {
    desc = "Show diagnostic",
})

vim.keymap.set({"n","v"}, "ä", "/", { desc = "Visual search" })
vim.keymap.set({"n","v"}, "å", "<cmd>:registers<CR>", { desc = "show registers" })

-- Bind Leader + f + r to open the Snacks Recent Files picker
vim.keymap.set("n", "<leader>fr", function() 
    Snacks.picker.recent() 
end, { desc = "Recent Files" })

vim.keymap.set({"n", "i", "v" }, "<F1>", "<Esc><cmd>w<CR>", { desc = "Save" })
vim.keymap.set({ "n", "i" }, "<F2>", function() vim.cmd("wincmd w") end, { desc = "Switch window" })
vim.keymap.set("n", "<F3>", "<cmd>:bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<F4>", function()
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(":Shell ", true, false, true),
        "n",
        false
    )
end, {
    desc = "Nushell",
})

vim.keymap.set("n", "<F5>", function()
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(
            ":vimgrep | copen" .. string.rep("<Left>",7),
            true,
            false,
            true
        ),
        "n",
        false
    )
end)

-- Visual mode mapping for <leader>mt

vim.keymap.set('v', '<leader>mt', [[:s/\v^(\S+)\s+(.+)/| \1 | \2 |/<CR>]], { 
    desc = "Markdown: Convert line to table row" 
})

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy UI" })

vim.keymap.set("n", "<leader>rs", vim.diagnostic.setloclist, {
    desc = "Show diagnostics",
})

vim.api.nvim_create_user_command("Prog", function()
  require("mini.files").open(vim.fn.expand("~/Dropbox/prog"), true)
end, {})

vim.api.nvim_create_user_command("Web", function()
  require("mini.files").open(vim.fn.expand("~/Dropbox/prog/web"), true)
end, {})

vim.api.nvim_create_user_command("Doc", function()
  require("mini.files").open(vim.fn.expand("~/Dropbox/documents/various/"), true)
end, {})

vim.api.nvim_create_user_command("Home", function()
  require("mini.files").open(vim.fn.expand("~/"), true)
end, {})

vim.keymap.set("n", "<leader>cw", "<cmd>!cal -w -3<cr>",{ desc = "calendar" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>")
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>")
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>")
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<cr>")
vim.keymap.set({ "n", "i" }, "<A-p>", "<cmd>Prog<CR>", { desc = "Open prog" })
vim.keymap.set({ "n", "i" }, "<A-w>", "<cmd>Web<CR>", { desc = "Open web" })
vim.keymap.set({ "n", "i" }, "<A-d>", "<cmd>Doc<CR>", { desc = "Open docs" })
vim.keymap.set({ "n", "i" }, "<A-h>", "<cmd>Home<CR>", { desc = "Open home" })
vim.keymap.set("n", "<leader>e", "<cmd>Explore<CR>", {desc = "Open file explorer",})
vim.keymap.set("n", "<leader>rw", ToggleWarnings, { desc = "Toggle warnings" })
vim.keymap.set("n", "<leader>rn", toggle_number_mode, { desc = "Toggle line numbers mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")


-- Maps § to " so you can type §1p to paste register 1
vim.keymap.set('n', '§', '"', { desc = "Select register to paste" })
vim.keymap.set('n', '½', '@', { desc = "Execute macro from register" })
-- vim.keymap.set({ "n", "x", "o" }, "§", "0")
vim.keymap.set({ "n", "x", "o" }, "+", "$")

vim.keymap.set("n", "<A-c>", "<cmd>edit ~/.config/nvimin<CR>", { desc = "Edit init.lua" })
vim.keymap.set("n", "<A-l>", "<cmd>edit ~/Dropbox/prog/nvim/lorem.txt<CR>", { desc = "Edit lorem.txt" })

vim.keymap.set("i", "<M-h>", "<Left>")
vim.keymap.set("i", "<M-j>", "<Down>")
vim.keymap.set("i", "<M-k>", "<Up>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
