vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ==========================================================
-- Options
-- ==========================================================

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250

-- ==========================================================
-- Bootstrap lazy.nvim
-- ==========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if vim.fn.empty(vim.fn.glob(lazypath)) > 0 then

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

local zk_ext = {}

function zk_ext.get(year, month)
  local notes = require('zettelkasten.browser').get_notes()
  local marks = {}
  for _, note in ipairs(notes) do
    local t = vim.split(note.id, '-')
    if tonumber(t[1]) == year and tonumber(t[2]) == month then
      table.insert(
        marks,
        {
          year = tonumber(t[1]),
          month = tonumber(t[2]),
          day = tonumber(t[3]),
        }
      )
    end
  end

  return marks
end

require("lazy").setup({

-- ==========================================================
-- oil
-- ==========================================================

{
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["q"] = "actions.close",
    },
  },
},


-- ==========================================================
-- bufferline
-- ==========================================================

{
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      vim.opt.termguicolors = true

      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })

      vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
      vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
      vim.keymap.set("n", "<leader>bd", "<Cmd>bdelete<CR>")
    end,
  },

-- ==========================================================
-- scope
-- ==========================================================

{
  "tiagovla/scope.nvim",
  config = function()
    require("scope").setup({})
  end,
},

-- ==========================================================
-- autotag
-- ==========================================================

{
  "windwp/nvim-ts-autotag",
  opts = {},
},

-- ==========================================================
-- Nerdy font
-- ==========================================================

{
  "2kabhishek/nerdy.nvim",
},

-- ==========================================================
-- Dashboard
-- ==========================================================

{
  "nvimdev/dashboard-nvim",
  event = "VimEnter",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
  },

  config = function()

    local dashboard = require("dashboard")
local function memory_usage()

  local file = io.open("/proc/self/status", "r")

  if not file then
    return "N/A"
  end

  for line in file:lines() do
    local kb = line:match("^VmRSS:%s+(%d+)")

    if kb then
      file:close()

      local mb = tonumber(kb) / 1024

      return string.format("%.0f MB", mb)
    end
  end

  file:close()

  return "N/A"
end

local function footer()

  local lazy_ok, lazy = pcall(require, "lazy")

  local plugins = "?"

  if lazy_ok then
    plugins = #lazy.plugins()
  end

  local memory = memory_usage()

  local nvim_version = vim.version()

  return {
    "",
    string.format(
      " %d.%d.%d    %s plugins    %s    %s",
      nvim_version.major,
      nvim_version.minor,
      nvim_version.patch,
      plugins,
      memory,
      os.date("%H:%M")
    ),
    "",
    "version --- plugins --- memory --- time",
  }

end
    local recent_files = {}

    for i = 1, 8 do
      local file = vim.v.oldfiles[i]

      if file then
        table.insert(recent_files, {
          icon = "  ",
          desc = vim.fn.fnamemodify(file, ":~:."),
          action = "edit " .. vim.fn.fnameescape(file),
          key = tostring(i),
        })
      end
    end

    local center = {

      {
        icon = "  ",
        desc = "New file",
        action = "enew",
        key = "n",
      },
    {
       icon = "  ",
       desc = "Help",
       action ="lua vim.schedule(function() vim.fn.feedkeys(':help ', 't') end)",
       key = "h",
    },
        {
        icon = "  ",
        desc = "Find file",
        action = "Telescope find_files",
        key = "f",
      },

      {
        icon = "  ",
        desc = "Find text",
        action = "Telescope live_grep",
        key = "g",
      },
      {
        icon = "  ",
        desc = "Recent files",
        action = "Telescope oldfiles",
        key = "r",
       },
      {
        icon = "  ",
        desc = "Edit init.lua",
        action = "edit " .. vim.fn.stdpath("config") .. "/init.lua",
        key = "c",
      },
    }


    vim.list_extend(center, recent_files)


    vim.list_extend(center, {

      {
        icon = "   ",
        desc = "Quit",
        action = "qa",
        key = "q",
      },

    })


    dashboard.setup({
      theme = "doom",

      config = {

        header = {
          "",
          " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
          " ████╗  ██║██║   ██║██║████╗ ████║",
          " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
          " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
          "",
        },

        center = center,

footer = footer(),
      },
    })
  end,
},

-- ==========================================================
-- Snacks
-- ==========================================================

{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = { enabled = true },
    explorer = { enabled = false },
 --   dashboard = { enabled = true },
    picker = { enabled = true },
    scratch = { enabled = true },
   terminal = { enabled = true },
   }
},

--local Snacks = require("snacks")

-- ==========================================================
-- wilder
-- ==========================================================

{
  "gelguy/wilder.nvim",
  dependencies = { "romgrk/fzy-lua-native" },
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })

    -- Basic fuzzy + search pipeline
    wilder.set_option("pipeline", {
      wilder.branch(
        -- fuzzy match for commands
        wilder.cmdline_pipeline({
          fuzzy = 1,
          fuzzy_filter = wilder.lua_fzy_filter(),
        }),
        -- search suggestions from buffer
        wilder.vim_search_pipeline()
      ),
    })

    -- Use a popup menu renderer (floating window)
    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
      })
    )
  end,
},

-- ==========================================================
-- neodev
-- ==========================================================

{
  "folke/neodev.nvim",
  config = true
},

-- ==========================================================
-- elixir
-- ==========================================================

{
  "neovim/nvim-lspconfig",
},

-- ==========================================================
-- markdown
-- ==========================================================

{
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
},

-- ==========================================================
-- harpoon
-- ==========================================================

{
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)

      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end)

      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end)

      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end)

      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end)
    end,
},

-- =========================
-- Treesitter
-- =========================

{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-context",
    "HiPhish/rainbow-delimiters.nvim",
  },
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "bash",
      "html",
      "css",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "elixir",
      "svelte",
    },

    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  },
},

-- =========================
-- Snippets (LuaSnip)
-- =========================

{
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
},

{
  "saadparwaiz1/cmp_luasnip",
},

{
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.85,
        width = 0.80,
      },
    })
  end,
},

-- =========================
-- tmux 
-- =========================

{
  "christoomey/vim-tmux-navigator",
},

-- =========================
-- Mason
-- =========================

{
  "williamboman/mason.nvim",
  config = true,
},

{
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "elixirls",
      },
    })

    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }

    vim.lsp.enable("lua_ls")
  end,
},
-- =========================
-- Theme
-- =========================


{
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 2000,
  config = function()
    require("github-theme").setup({})
  end,
},

-- =========================
-- Icons
-- =========================

{ "nvim-tree/nvim-web-devicons" },

-- =========================
-- minifiles + mini.ai + mini.surround
-- =========================

{
  "nvim-mini/mini.nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    require("mini.ai").setup()
    require("mini.files").setup({
      mappings = { go_in = "<Right>", go_out = "<Left>" },
    })

    -- mini.ai: better text objects
    require("mini.ai").setup()

    -- mini.surround: add/change/delete surrounding characters
    require("mini.surround").setup({
      -- Default mappings:
      mappings = {
        add = "",       -- add surrounding
        delete = "",    -- delete surrounding
        find = "",      -- find surrounding (right)
        find_left = "", -- find surrounding (left)
        highlight = "", -- highlight surrounding
        replace = "",   -- replace surrounding
        update_n_lines = "", -- update number of lines
      },
      -- optionally you can customize which pairs to recognize
      n_lines = 500,
    })

    -- OPTIONAL: keymap to open mini.files quickly
    vim.keymap.set("n", "-", function()
      local buf_path = vim.api.nvim_buf_get_name(0)
      local dir = vim.fn.fnamemodify(buf_path, ":h")
      require("mini.files").open(dir)
    end, { desc = "Open mini.files in current buffer's directory" })
  end,
},

-- =========================
-- Telescope
-- =========================

{ "nvim-lua/plenary.nvim" },

{
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({})
  end,
},

-- =========================
-- autopairs 
-- =========================

{
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({})
  end,
},

-- =========================
-- Enhanced search (hlslens)
-- =========================

{
  "kevinhwang91/nvim-hlslens",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("hlslens").setup()

    local kopts = { noremap = true, silent = true }

    vim.keymap.set("n", "n",
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)

    vim.keymap.set("n", "N",
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
  end,
},

-- =========================
-- Completion
-- =========================

{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
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
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end,
},

-- =========================
-- Legendary
-- =========================

  {
    "mrjones2014/legendary.nvim",
    config = function()
      local legendary = require("legendary")

      -- Example keymaps to test
      vim.keymap.set("n", "zz", "zz", { desc = "center page" })
      
      vim.keymap.set("n", "<leader>fd", function()
          require("telescope.builtin").find_files({
          cwd = vim.fn.expand("~")
      })
      end, { desc = "find files globally" })
     
      vim.keymap.set("n", "<leader>fh", function()
        require("telescope.builtin").live_grep({
        cwd = vim.fn.expand("~")
         })
      end)
      
      -- Setup Legendary
      legendary.setup({
        keymaps = {},  -- keymaps already registered above
        commands = {}, -- optional
        auto_register_which_key = true, -- integrate with which-key if installed
      })
    end,
  },

-- =========================
-- Trouble
-- =========================

{
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = true,
},

-- =========================
-- Statusline
-- =========================

{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = { theme = "github_dark_high_contrast" },
    })
  end,
},

-- =========================
-- terminal
-- =========================

{
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      direction = "float",
    })
  end,
},

-- =========================
-- flash nvim
-- =========================

{
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    jump = {
      min_pattern_length = 3,
    },
  },
  keys = {
    {
      "<leader>ma",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = {
            mode = "search",
          },
        })
      end,
      desc = "Flash Search",
    },

    {
      "<leader>mb",
      mode = { "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Treesitter Flash",
    },

    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },

    {
      "<leader>mc",
      mode = "n",
      function()
        require("flash").treesitter()
      end,
      desc = "Treesitter Flash",
    },
  },
},

-- =========================
-- telekasten
-- =========================

{
  "nvim-telekasten/telekasten.nvim",
  cmd = "Telekasten",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telekasten").setup({
      home = vim.fn.expand("~/zettelkasten"),
    })
  end,
},

-- =========================
-- colorschemes
-- =========================

{ "folke/tokyonight.nvim" },
{ "catppuccin/nvim" },

-- =========================
-- Which-key
-- =========================

{
  "folke/which-key.nvim",
  config = true,
},

-- =========================
-- obsidian
-- =========================

{
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
    },
  },
},

-- =========================
-- test plugins
-- =========================



-- =========================
-- custom plugins
-- =========================

-- {	
--   dir = "~/Dropbox/prog/nvim/customplugins",
--   config = function()
--    require("customplugins.cplugins").setup()
--  end
--},

})

-- =========================
-- custom functions 
-- =========================

local function oldest_files()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local files = {}

  for i = 1, math.min(10, #vim.v.oldfiles) do
    table.insert(files, {
      index = i,
      path = vim.v.oldfiles[i],
    })
  end

  pickers.new({}, {
    prompt_title = "Recent Files",
    previewer = false,

    layout_strategy = "center",
    layout_config = {
      width = 0.45,
      height = 0.30,
    },

    finder = finders.new_table({
      results = files,

      entry_maker = function(entry)
        return {
          value = entry.path,
          display = string.format(
            "%2d  %s",
            entry.index,
            vim.fn.fnamemodify(entry.path, ":t")
          ),
          ordinal = entry.path,
        }
      end,
    }),

    sorter = conf.generic_sorter({}),

    attach_mappings = function(prompt_bufnr, map)
      -- Press 1-9 to open that file immediately
      for i = 1, math.min(9, #files) do
        map("i", tostring(i), function()
          actions.close(prompt_bufnr)
          vim.cmd.edit(vim.fn.fnameescape(files[i].path))
        end)
      end

      -- Press 0 for the 10th file
      if #files >= 10 then
        map("i", "0", function()
          actions.close(prompt_bufnr)
          vim.cmd.edit(vim.fn.fnameescape(files[10].path))
        end)
      end

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        vim.cmd.edit(vim.fn.fnameescape(entry.value))
      end)

      return true
    end,
  }):find()
end


vim.api.nvim_create_user_command("LuaScratch", function()
  vim.cmd("enew")
  vim.bo.filetype = "lua"
  vim.cmd("setlocal buftype=nofile")
  vim.cmd("setlocal bufhidden=hide")
  vim.cmd("setlocal noswapfile")
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- enable semantic tokens
 end,
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
})

local show_warnings = true

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

vim.keymap.set("n", "<leader>rw", ToggleWarnings, { desc = "Toggle warnings" })


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

vim.keymap.set("n", "<leader>rn", toggle_number_mode, { desc = "Toggle line numbers mode" })

vim.keymap.set("n", "<leader>b", vim.diagnostic.open_float, {
  desc = "Show diagnostic"
})
vim.keymap.set("n", "<leader>d", "<cmd>Dashboard<CR>", {
  desc = "Open dashboard",
})
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", {
  desc = "Diagnostics"
})

vim.keymap.set("v", "<leader>r", function()
  vim.cmd('normal! y')
  local text = vim.fn.getreg('"'):gsub("%d+", "\\d+")
  local pattern = "\\v" .. text

  vim.fn.setreg("/", pattern)
  vim.api.nvim_feedkeys("/" .. pattern, "n", false)
end)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

vim.opt.hlsearch = true

local function search_keymaps(keyword)
  if not keyword or keyword == "" then
    print("Usage: :SearchKey <keyword>")
    return
  end

  local found = false
  local modes = { n = "Normal", i = "Insert", v = "Visual", x = "Visual", s = "Select" }

  for _, mode in ipairs({ "n", "i", "v", "x", "s" }) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, m in ipairs(maps) do
      if m.desc and m.desc:lower():find(keyword:lower()) then
        print(string.format("[%s] %s -> %s (%s)", modes[mode] or mode, m.lhs, m.rhs, m.desc))
        found = true
      end
    end
  end

  if not found then
    print("No keymaps found for: " .. keyword)
  end
end

-- Create the :SearchKey command
vim.api.nvim_create_user_command("SearchKey", function(opts)
  search_keymaps(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("ReloadConfig", function()
  vim.cmd("source $MYVIMRC")
  print("Neovim config reloaded!")
end, {})

-- ===============================
-- Fuzzy search in current buffer
-- ==============================

vim.keymap.set("n", "<leader>s", function()
  require("telescope.builtin").current_buffer_fuzzy_find({
    sorting_strategy = "ascending",
    tiebreak = function() return false end,
  })
end)

-- ==========================================================
-- Keymaps
-- ==========================================================

vim.keymap.set({"n", "i", "v" }, "<F1>", "<Esc><cmd>w<CR>", { desc = "Save" })
vim.keymap.set({ "n", "i" }, "<F2>", function() vim.cmd("wincmd w") end, { desc = "Switch window" })
vim.keymap.set("n", "<F3>", "<cmd>:bd<CR>", { desc = "Close buffer" })

vim.keymap.set("n", "<f4>", ":vimgrep /", { desc = "Vimgrep" })
vim.keymap.set("n", "<C-q>", "<cmd>copen<CR>", { desc = "Open quickfix" })
-- vim.keymap.set("n "<C-c>", ":cdo ", { desc = "Quickfix cdo" })
vim.keymap.set("n","<F5>", "vip", { desc = "select paragraph" })
vim.keymap.set("n", "<F6>", "q:", { desc = "Command history" })
vim.keymap.set("n", "<F7>", ":<C-u>%s//<Left><Left>", { desc = "Search and replace" })
vim.keymap.set("n", "<F8>", "<cmd>Telescope help_tags<cr>")
vim.keymap.set({"n","i"}, "<F10>", "<cmd>FzfLua buffers<CR>", { desc = "FZF grep" })
vim.keymap.set("n", "<F11>", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
vim.keymap.set({ "n", "i", "v", "s", "o" }, "<F12>", "<Esc><cmd>quit<CR>", {desc = "Quit",})
vim.keymap.set({ "n", "i", "v", "s", "o" }, "<f12>", ":help <space>", {desc = "help",})
-- vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "FZF files" })

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

-- =========================
-- telekasten keymaps
-- =========================

local tk = require("telekasten")

vim.keymap.set("n", "<leader>cn", tk.new_note, { desc = "New note" })
vim.keymap.set("n", "<leader>cf", tk.find_notes, { desc = "Find notes" })
vim.keymap.set("n", "<leader>cd", tk.goto_today, { desc = "Today's note" })
vim.keymap.set("n", "<leader>cg", tk.follow_link, { desc = "Follow link" })
vim.keymap.set("n", "<leader>ct", tk.show_tags, { desc = "Show tags" })

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
vim.keymap.set("n", "<leader>n", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>t", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader><", "vi>", { desc = "select inside <>" })
vim.keymap.set("n", '<leader>"', 'vi"', { desc = 'select inside ""' })
vim.keymap.set("n", "<leader>[", "vi[", { desc = "select inside []" })
vim.keymap.set("n", "<leader>c", "yiw", { desc = "copy word" })
vim.keymap.set("n", "<leader>(", "vib")
vim.keymap.set("n", "<leader>{", "vi{")
vim.keymap.set("n", "<leader>r1", "cib")
vim.keymap.set("n", "<leader>r2", 'ci"')
vim.keymap.set("n", "<leader>r3", "ci[")
vim.keymap.set("n", "<leader>r4", "ci{")

vim.keymap.set("n", "<leader>rf", function()
  vim.fn.feedkeys("/")
end)

vim.keymap.set("n", "<C-w>", "ciw", { desc = "insert" })
vim.keymap.set("n", "<C-c>", "vwy", { desc = "copy" })
vim.keymap.set("n", "<leader>v", "vc")
vim.keymap.set("n", "<leader>w", "ciw")
vim.keymap.set("n", "<leader>y", ":<C-u>g/")
vim.keymap.set({ "n", "x", "o" }, "<C-a>", function() require("flash").jump() end, { desc = "Flash search" })
vim.keymap.set("n", "<A-c>", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit init.lua" })
vim.keymap.set("n", "<A-l>", "<cmd>edit ~/Dropbox/prog/nvim/lorem.txt<CR>", { desc = "Edit lorem.txt" })
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>")
--vim.keymap.set("n", "<Tab>", "gt", { desc = "Next tab" })
--vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>ga", ":!git add .<CR>")
vim.keymap.set("n", "<leader>gc", ":!git commit<CR>")
vim.keymap.set("n", "<leader>gp", ":!git push<CR>")
vim.keymap.set("n", "<F13>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("x", "<leader>q", ":normal ", {
  desc = "Run :normal on selection",
})
vim.cmd("packadd nvim.undotree")

vim.keymap.set("n", "<leader>u", function()
  require("undotree").open()
end)

vim.keymap.set("n", "<leader>z", function()
--vim.keymap.set("n", "<F9>", "/", { desc = "start search" })

vim.cmd("reg")

  -- Ask the user to type a register
  local reg = vim.fn.getcharstr()

  if reg ~= "" then
    -- Get the contents of the registe(r
    local content = vim.fn.getreg(reg)

    -- Paste it at the cursor (character-wise)
    vim.api.nvim_put({content}, "c", true, true)
  end
end, { desc = "Pick a register and paste" })

vim.api.nvim_create_user_command("Prog2", function()
  require("mini.files").open(vim.fn.expand("~/prog2/"), true)
end, {})

vim.api.nvim_create_user_command("Home", function()
  require("mini.files").open(vim.fn.expand("~/"), true)
end, {})

vim.api.nvim_create_user_command("Cust", function()
  require("mini.files").open(vim.fn.expand("~/.config/nvim/colors/custom-light.lua"), true)
end, {})

vim.api.nvim_create_user_command("Prog2", function()
  require("mini.files").open(vim.fn.expand("~/prog2"), true)
end, {})

vim.api.nvim_create_user_command("Prog", function()
  require("mini.files").open(vim.fn.expand("~/Dropbox/prog"), true)
end, {})

vim.api.nvim_create_user_command("Web", function()
  require("mini.files").open(vim.fn.expand("~/Dropbox/prog/web"), true)
end, {})

vim.api.nvim_create_user_command("Doc", function()
  require("mini.files").open(vim.fn.expand("~/Dropbox/documents/various/"), true)
end, {})

vim.keymap.set("v", "<C-l>", function()
  vim.cmd("'<,'>lua")
end, { desc = "Run selected Lua" })

vim.filetype.add({
  extension = {
    ex = "elixir",
    exs = "elixir",
  },
})

vim.keymap.set("n", "<leader>ro", ":%s/\\<<C-r><C-w>\\>/&/gn<CR>", {
  desc = "Count word occurrences"
})

vim.keymap.set("n", "<leader>xl", function()
  vim.cmd("luafile %")
end, { desc = "Run Lua file" })

vim.keymap.set({"n","v"}, "å", "<cmd>Telescope find_files<CR>", { desc = "fuzzy search" })
vim.keymap.set({"n","v"}, "Å", "<cmd>Telescope live_grep<CR>", { desc = "fuzzy search" })
vim.keymap.set({"n","v"}, "ä", "/", { desc = "Visual search" })

vim.keymap.set("n", "Ä", function()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(":vimgrep ", true, false, true),
    "n",
    false
  )
end, { desc = "vimgrep" })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "vimgrep",
  callback = function()
    vim.cmd("copen")
  end,
})

vim.keymap.set("n", "<leader>cw", "<cmd>!cal -w -3<cr>",{ desc = "calendar" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>")
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>")
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>")
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<cr>")
vim.keymap.set({ "n", "x", "o" }, "§", "0")
vim.keymap.set({ "n", "x", "o" }, "+", "$")
vim.keymap.set("n", "ö", oldest_files, { desc = "Recent files" })
vim.keymap.set("n", "Ö", "<cmd>Telescope registers<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<C-s>", "/", { desc = "Search" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "-", function() require("mini.files").open() end)
vim.keymap.set({ "n", "i" }, "<A-o>", "<cmd>Prog2<CR>", { desc = "Open prog2" })
vim.keymap.set({ "n", "i" }, "<A-p>", "<cmd>Prog<CR>", { desc = "Open prog" })
vim.keymap.set({ "n", "i" }, "<A-w>", "<cmd>Web<CR>", { desc = "Open web" })
vim.keymap.set({ "n", "i" }, "<A-d>", "<cmd>Doc<CR>", { desc = "Open docs" })
vim.keymap.set({ "n", "i" }, "<A-r>", "<cmd>Prog2<CR>", { desc = "Open docs" })
vim.keymap.set({ "n", "i" }, "<A-h>", "<cmd>Home<CR>", { desc = "home dir" })
vim.keymap.set({ "n", "i" }, "<A-t>", "<cmd>Cust<CR>", { desc = "open custom dark lua" })

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Oil" })
-- vim.keymap.set("n", "<leader>e", function() require("snacks.explorer").open() end, { desc = "Snacks Explorer" })
vim.keymap.set("n","<leader>fb", function() Snacks.picker.buffers() end,{ desc = "Buffers" })

vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", {
  desc = "New tab"
})

vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>", {
  desc = "Next tab"
})

vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>", {
  desc = "Previous tab"
})

vim.keymap.set("n", "<leader>cb", function()

  local dir = vim.fn.expand("%:p:h")

  -- tab-local cwd
  vim.cmd("tcd " .. vim.fn.fnameescape(dir))

  -- print tab-local cwd
  print("tab cwd -> " .. vim.fn.getcwd(-1, 0))

end, { desc = "Change tab cwd to buffer dir" })

vim.cmd.colorscheme("custom-light")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "lspinfo", "man", "checkhealth" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = args.buf,
      silent = true,
    })
  end,
})

vim.keymap.set({ "n", "x" }, "X", function()
  local mode = vim.fn.mode()

  if mode == "n" then
    vim.cmd("normal! V")
  elseif mode == "V" then
    vim.cmd("normal! j")
  end
end, { desc = "Helix-style line selection" })

-- ==========================================================
-- Macros
-- ==========================================================

vim.fn.setreg('ca',"I#\27")
vim.fn.setreg('cb',"I//\27")
vim.fn.setreg('cc',"I--\27")
vim.fn.setreg('ua', [[:s/^\s*#\s\?//]])
vim.fn.setreg('ub', [[:s#^\s*//\s\?##]])
vim.fn.setreg('uc', [[:s#^\s*--\s\?##]])
vim.fn.setreg('d',"I    \27")
vim.fn.setreg('c',":! ncal -w")

-- key combos: vaf vif yiw ciw diw viw
--
-- jonas@jonas-ThinkPad-X13-Gen-1 ~> cd
-- jonas@jonas-ThinkPad-X13-Gen-1 ~> mkdir -p ~/.local/share/elixir-ls
-- jonas@jonas-ThinkPad-X13-Gen-1 ~> cd ~/.local/share/elixir-ls
-- jonas@jonas-ThinkPad-X13-Gen-1 ~/.l/s/elixir-ls> curl -LO https://github.com/elixir-lsp/elixir-ls/releases/download/v0.22.1/elixir-ls-v0.22.1.zip
-- ~/.l/s/elixir-ls> unzip elixir-ls-v0.22.1.zip 
-- ~/.l/s/elixir-ls> chmod +x language_server.sh
--
-- lua =vim.api.nvim_list_bufs()
-- 
--
-- combinations: dr$
