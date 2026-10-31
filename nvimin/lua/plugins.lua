-- ==========================================================
-- lazy.nvim bootstrap
-- ==========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)


-- ==========================================================
-- Plugins
-- ==========================================================

require("lazy").setup({

    -- Mason
{
    "mason-org/mason.nvim",
    opts = {},
},

{
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
    },

    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "ts_ls",
                "pyright",
                "bashls",
                "html",
                "cssls",
                "svelte",
                "rust_analyzer",
            },
        })
    end,
},

{
    "neovim/nvim-lspconfig",

    config = function()

        local capabilities =
            require("cmp_nvim_lsp").default_capabilities()

        -- Settings shared by all LSP servers
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- Lua-specific settings
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                        },
                    },

                    runtime = {
                        version = "LuaJIT",
                    },

                    workspace = {
                        checkThirdParty = false,
                    },

                    telemetry = {
                        enable = false,
                    },
                },
            },
        })

        vim.lsp.enable({
            "lua_ls",
            "ts_ls",
            "pyright",
            "bashls",
            "html",
            "cssls",
            "svelte",
            "rust_analyzer",
        })

    end,
},

{
    "hrsh7th/nvim-cmp",

    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },

    config = function()
        local cmp = require("cmp")

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            }),

            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            },
        })
    end,
},
    -- Harpoon 2
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()

            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon add" })


            vim.keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(
                    harpoon:list()
                )
            end, { desc = "Harpoon menu" })


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
  
		-- obsidian
	
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

		-- render markdown 

{
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
	      completions = {
            lsp = { enabled = true }
        }
    },
},

   -- flash 

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
      "ö",
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
      "<leader>jb",
      mode = { "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Treesitter Flash",
    },

    {
      "<leader>jr",
      mode = {"o","n"},
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },

    {
      "<leader>jc",
      mode = "n",
      function()
        require("flash").treesitter()
      end,
      desc = "Treesitter Flash",
    },
  },
},

    -- snacks 
{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = { enabled = true },
    explorer = { enabled = false },
    dashboard = { enabled = true, 
      preset = {
        -- Pass your custom NVIM ASCII banner here
        header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },
   },
    picker = { enabled = true },
    scratch = { enabled = true },
   terminal = { enabled = true },
   }
},

    -- mini.nvim

{
    "echasnovski/mini.nvim", 
    version = false,
    lazy = false,
    priority = 1000,

    config = function()
        -- 1. Initialize Icons & Mock the old devicons system globally
        require("mini.icons").setup()
        require("mini.icons").mock_nvim_web_devicons()

        -- 2. Mini AI Setup
        local ai = require("mini.ai")
        ai.setup({
            custom_textobjects = {
                q = ai.gen_spec.pair('"', '"'),
                s = ai.gen_spec.pair("'", "'"),
  	            },
        })

        -- 3. Mini Pairs Setup
        require("mini.pairs").setup()

        -- 4. Mini Files Setup
        require("mini.files").setup({
            mappings = {
                go_in = "l",
                go_out = "h",
            },
        })

        -- 5. Mini Surround Setup
        require("mini.surround").setup({
            mappings = {
                add = "",
                delete = "",
                find = "",
                find_left = "",
                highlight = "",
                replace = "",
                update_n_lines = "",
            },
            n_lines = 500,
        })

        -- 6. Independent Modules
        require("mini.extra").setup()
        require("mini.pick").setup()

        -- 7. Keymaps
        vim.keymap.set("n", "-", function()
            local path = vim.api.nvim_buf_get_name(0)
            local dir = vim.fn.fnamemodify(path, ":h")
            require("mini.files").open(dir)
        end, { desc = "Open mini.files" })
    end,
},

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            -- Changed from 'nvim-treesitter.configs' to 'nvim-treesitter'
            require('nvim-treesitter').setup({
                -- Ensure these parsers are automatically installed on launch
                ensure_installed = { "svelte", "typescript", "javascript", "html", "css", "lua" }, 
                
                -- Enable syntax highlighting
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            require("telescope").setup({})
        end,
    },

    -- fzf-lua

    {
        "ibhagwan/fzf-lua",


        config = function()

            require("fzf-lua").setup({
                winopts = {
                    height = 0.85,
                    width = 0.80,
                },
            })

        end,
    },


    -- Bufferline
    {
        "akinsho/bufferline.nvim",

        version = "*",


        config = function()


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


            vim.keymap.set(
                "n",
                "<Tab>",
                "<Cmd>BufferLineCycleNext<CR>"
            )


            vim.keymap.set(
                "n",
                "<S-Tab>",
                "<Cmd>BufferLineCyclePrev<CR>"
            )


            vim.keymap.set(
                "n",
                "<leader>ed",
                "<Cmd>bdelete<CR>"
            )

				for i = 1,9 do
								vim.keymap.set("n","<leader>w" .. i,"<Cmd>BufferLineGoToBuffer " .. i .. "<CR>"
    )
end
        end,
    },

-- which key

{
  "folke/which-key.nvim",
  config = true,
}

})
