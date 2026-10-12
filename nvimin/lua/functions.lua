vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "lspinfo", "man", "checkhealth","netrw" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = args.buf,
      silent = true,
    })
  end,
})

vim.keymap.set("n", "<leader>rd", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle LSP Diagnostics" })

local function sqlite_query(db,query)
    local cmd = string.format(
        "sqlite3 -header -column %s %s",
        vim.fn.shellescape(db),
        vim.fn.shellescape(query)
    )

    local output = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        vim.notify(
            table.concat(output, "\n"),
            vim.log.levels.ERROR
        )
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].modifiable = false

    local width = 0
    for _, line in ipairs(output) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end

    width = math.min(width + 2, vim.o.columns - 4)

    local height = math.min(#output + 2, vim.o.lines - 4)

    local win = vim.api.nvim_open_win(buf,true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
    })

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })

    vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

local function sqlite_complete(arglead, cmdline, cursorpos)
    local results = {}

    -- Expand ~ so glob() can find files
    local pattern = vim.fn.expand(arglead)

    -- If nothing has been typed, search current directory
    if pattern == "" then
        pattern = "./"
    end

    -- Complete directories and .db files
    local matches = vim.fn.glob(
        pattern .. "*",
        false,
        true
    )

    for _, path in ipairs(matches) do
        -- Don't show non-database files
        if vim.fn.isdirectory(path) == 1
            or path:match("%.db$")
        then
            table.insert(results, path)
        end
    end

    return results
end

vim.api.nvim_create_user_command("SQLite", function(opts)

    local args = opts.args

    local query, db = args:match('^"(.-)"%s+(.+)$')

    if not query or not db then
        vim.notify(
            'Usage: :SQLite "SQL query" database.db',
            vim.log.levels.ERROR
        )
        return
    end

    sqlite_query(db, query)

    end, {
				 nargs = "+",
				 complete = sqlite_complete,
    }

)

-- Shell popup

    local function shell_popup(command)
    local output = vim.fn.systemlist({
        "nu",
        "-c",
        command,
    })

    if vim.v.shell_error ~= 0 then
        table.insert(output, 1, "Command failed: " .. command)
    end
    if #output == 0 then
        output = {
            "(no output)"
        }
 
     end

    -- ========================================================
    -- Buffer
    -- ========================================================

    local buf = vim.api.nvim_create_buf(false,true)

    vim.api.nvim_buf_set_lines(buf,0,-1,false,output)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false

    -- ========================================================
    -- Popup dimensions
    -- ========================================================

    local width = 0

    for _, line in ipairs(output) do
        width = math.max(
            width,
            vim.fn.strdisplaywidth(line)
        )
    end

    width = math.max(width + 2, 20)

    width = math.min(
        width,
        math.floor(vim.o.columns * 0.9)
    )

    local height = math.max(#output + 2, 3)

    height = math.min(
        height,
        math.floor(vim.o.lines * 0.8)
    )

    -- ========================================================
    -- Floating window
    -- ========================================================

    local win = vim.api.nvim_open_win(
        buf,
        true,
        {
            relative = "editor",

            width = width,
            height = height,

            row = math.floor(
                (vim.o.lines - height) / 2
            ),

            col = math.floor(
                (vim.o.columns - width) / 2
            ),

            style = "minimal",
            border = "rounded",
        }
    )

    vim.wo[win].wrap = false
    vim.wo[win].cursorline = false

    -- ========================================================
    -- Close popup
    -- ========================================================

    local function close_popup()

        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end

    end

    vim.keymap.set(
        "n",
        "q",
        close_popup,
        {
            buffer = buf,
            silent = true,
            nowait = true,
        }
    )

    vim.keymap.set(
        "n",
        "<Esc>",
        close_popup,
        {
            buffer = buf,
            silent = true,
            nowait = true,
        }
    )
end

-- ============================================================
-- Shell completion
-- ============================================================

local function shell_complete(arglead, cmdline, cursorpos)

    -- Remove :Shell from the command line
    local line = cmdline:sub(1, cursorpos)

    line = line:gsub("^%s*:Shell%s*", "")

    -- ========================================================
    -- Completing the first word
    --
    -- :Shell gi<Tab>
    --
    -- -> git
    -- -> git-receive-pack
    -- -> git-shell
    -- ...
    -- ========================================================

    if not line:find("%s") then

        return vim.fn.getcompletion(
            arglead,
            "shellcmd"
        )
    end


    -- ========================================================
    -- Completing everything after the command
    --
    -- :Shell ls ./<Tab>
    -- :Shell cat ~/Do<Tab>
    -- :Shell sqlite3 ./<Tab>
    -- ========================================================

    return vim.fn.getcompletion(
        arglead,
        "file"
    )
end

-- ============================================================
-- :Shell
-- ============================================================

vim.api.nvim_create_user_command(
    "Shell",
    function(opts)

        if opts.args == "" then

            vim.notify(
                "Usage: :Shell <command>",
                vim.log.levels.ERROR
            )

            return
        end

        shell_popup(opts.args)

    end,
    {
        nargs = "+",
        complete = shell_complete,
    }
)

-- Global jump list
-- A completely separate jump list from Neovim's native
-- jumplist.
--
-- Example:
--
--   main.lua       : 90
--   app.svelte     : 40
--   config.nu      : 123
--   main.lua       : 15
--
--
-- Commands:
--
--   :GJumpAdd      Add current position
--   :GJumps        Show global jump list
--   :GJumpClear    Clear global jump list
--
--
-- Keymaps:
--
--   <leader>ga     Add current position
--   <M-j>          Next global jump
--   <M-k>          Previous global jump
--
--
-- IMPORTANT:
--
-- Alt-j / Alt-k navigate the list without adding anything.
-- ============================================================


local GlobalJumps = {
    list = {},
    index = 0,
    max = 1000,
}


-- ============================================================
-- Current position
-- ============================================================

local function current_position()

    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return nil
    end

    local cursor = vim.api.nvim_win_get_cursor(0)

    return {
        bufnr = bufnr,
        line = cursor[1],
        col = cursor[2],
    }
end


-- ============================================================
-- Compare positions
--
-- Columns within 2 characters are considered the same
-- location. This prevents duplicate entries.
-- ============================================================

local function same_position(a, b)

    if not a or not b then
        return false
    end

    return (
        a.bufnr == b.bufnr
        and a.line == b.line
        and math.abs(a.col - b.col) < 3
    )
end


-- ============================================================
-- Add current position
-- ============================================================

function GlobalJumps.add()

    local pos = current_position()

    if not pos then
        return
    end


    -- --------------------------------------------------------
    -- Don't add the same location twice in a row.
    -- --------------------------------------------------------

    local last = GlobalJumps.list[#GlobalJumps.list]

    if same_position(last, pos) then
        -- Make sure navigation cursor points at the newest
        -- entry.
        GlobalJumps.index = #GlobalJumps.list
        return
    end


    -- --------------------------------------------------------
    -- Add the new location.
    --
    -- IMPORTANT:
    -- We do NOT remove entries after index.
    --
    -- This makes the list behave as a collection of locations
    -- that can be freely cycled with Alt-j / Alt-k.
    -- --------------------------------------------------------

    table.insert(GlobalJumps.list, pos)


    -- --------------------------------------------------------
    -- Maximum size
    -- --------------------------------------------------------

    if #GlobalJumps.list > GlobalJumps.max then
        table.remove(GlobalJumps.list, 1)
    end


    -- --------------------------------------------------------
    -- Newest entry becomes current.
    -- --------------------------------------------------------

    GlobalJumps.index = #GlobalJumps.list


    vim.notify(
        string.format(
            "Global jump added: %s:%d",
            vim.fn.fnamemodify(
                vim.api.nvim_buf_get_name(pos.bufnr),
                ":~"
            ),
            pos.line
        )
    )
end


-- ============================================================
-- Jump to entry
-- ============================================================

local function jump_to(entry)

    if not entry then
        return false
    end


    if not vim.api.nvim_buf_is_valid(entry.bufnr) then
        return false
    end


    -- --------------------------------------------------------
    -- Switch buffer
    -- --------------------------------------------------------

    vim.api.nvim_set_current_buf(entry.bufnr)


    -- --------------------------------------------------------
    -- Make sure line still exists
    -- --------------------------------------------------------

    local line_count =
        vim.api.nvim_buf_line_count(entry.bufnr)

    local line =
        math.min(entry.line, line_count)


    -- --------------------------------------------------------
    -- Make sure column is valid
    -- --------------------------------------------------------

    local line_text =
        vim.api.nvim_buf_get_lines(
            entry.bufnr,
            line - 1,
            line,
            false
        )[1] or ""


    local col =
        math.min(
            entry.col,
            #line_text
        )


    -- --------------------------------------------------------
    -- Move cursor
    -- --------------------------------------------------------

    vim.api.nvim_win_set_cursor(0, {
        math.max(line, 1),
        math.max(col, 0),
    })


    return true
end


-- ============================================================
-- Remove invalid entries
--
-- Buffers can disappear, so clean them before navigation.
-- ============================================================

local function clean_list()

    local new_list = {}

    for _, entry in ipairs(GlobalJumps.list) do

        if vim.api.nvim_buf_is_valid(entry.bufnr) then
            table.insert(new_list, entry)
        end
    end

    GlobalJumps.list = new_list


    if #GlobalJumps.list == 0 then
        GlobalJumps.index = 0
        return
    end


    if GlobalJumps.index < 1 then
        GlobalJumps.index = 1
    end

    if GlobalJumps.index > #GlobalJumps.list then
        GlobalJumps.index = #GlobalJumps.list
    end
end


-- ============================================================
-- Next global jump
-- ============================================================

function GlobalJumps.next()

    clean_list()


    if #GlobalJumps.list == 0 then
        vim.notify(
            "Global jump list is empty",
            vim.log.levels.INFO
        )
        return
    end


    -- --------------------------------------------------------
    -- Move forward.
    --
    -- IMPORTANT:
    -- Wrap around when reaching the end.
    -- --------------------------------------------------------

    if GlobalJumps.index >= #GlobalJumps.list then
        GlobalJumps.index = 1
    else
        GlobalJumps.index =
            GlobalJumps.index + 1
    end


    local entry =
        GlobalJumps.list[GlobalJumps.index]


    -- --------------------------------------------------------
    -- Try to jump there.
    -- --------------------------------------------------------

    if not jump_to(entry) then

        table.remove(
            GlobalJumps.list,
            GlobalJumps.index
        )

        if #GlobalJumps.list == 0 then
            GlobalJumps.index = 0
            return
        end

        GlobalJumps.index =
            math.min(
                GlobalJumps.index,
                #GlobalJumps.list
            )

        GlobalJumps.next()
    end
end


-- ============================================================
-- Previous global jump
-- ============================================================

function GlobalJumps.previous()

    clean_list()


    if #GlobalJumps.list == 0 then
        vim.notify(
            "Global jump list is empty",
            vim.log.levels.INFO
        )
        return
    end


    -- --------------------------------------------------------
    -- Move backward.
    --
    -- Wrap around when reaching the beginning.
    -- --------------------------------------------------------

    if GlobalJumps.index <= 1 then
        GlobalJumps.index =
            #GlobalJumps.list
    else
        GlobalJumps.index =
            GlobalJumps.index - 1
    end


    local entry =
        GlobalJumps.list[GlobalJumps.index]


    if not jump_to(entry) then

        table.remove(
            GlobalJumps.list,
            GlobalJumps.index
        )

        if #GlobalJumps.list == 0 then
            GlobalJumps.index = 0
            return
        end

        GlobalJumps.index =
            math.min(
                GlobalJumps.index,
                #GlobalJumps.list
            )

        GlobalJumps.previous()
    end
end


-- ============================================================
-- Show global jump list
-- ============================================================

function GlobalJumps.show()

    clean_list()


    if #GlobalJumps.list == 0 then
        vim.notify(
            "Global jump list is empty",
            vim.log.levels.INFO
        )
        return
    end


    local lines = {}

    table.insert(
        lines,
        "Global Jump List"
    )

    table.insert(
        lines,
        "────────────────────────────────────────"
    )


    for i, entry in ipairs(GlobalJumps.list) do

        local filename =
            vim.api.nvim_buf_get_name(entry.bufnr)

        if filename == "" then
            filename = "[No Name]"
        else
            filename =
                vim.fn.fnamemodify(
                    filename,
                    ":~"
                )
        end


        local marker = " "

        if i == GlobalJumps.index then
            marker = ">"
        end


        table.insert(
            lines,
            string.format(
                "%s %3d  %-50s : %d",
                marker,
                i,
                filename,
                entry.line
            )
        )
    end


    vim.notify(
        table.concat(lines, "\n"),
        vim.log.levels.INFO
    )
end


-- ============================================================
-- Clear global jump list
-- ============================================================

function GlobalJumps.clear()

    GlobalJumps.list = {}
    GlobalJumps.index = 0

    vim.notify(
        "Global jump list cleared",
        vim.log.levels.INFO
    )
end


-- ============================================================
-- Commands
-- ============================================================

vim.api.nvim_create_user_command(
    "GJumpAdd",
    function()
        GlobalJumps.add()
    end,
    {
        desc = "Add current position to global jump list",
    }
)


vim.api.nvim_create_user_command(
    "GJumps",
    function()
        GlobalJumps.show()
    end,
    {
        desc = "Show global jump list",
    }
)


vim.api.nvim_create_user_command(
    "GJumpClear",
    function()
        GlobalJumps.clear()
    end,
    {
        desc = "Clear global jump list",
    }
)


-- ============================================================
-- Keymaps
-- ============================================================


-- ------------------------------------------------------------
-- Add current location
-- ------------------------------------------------------------

vim.keymap.set(
    "n",
    "<leader>ga",
    function()
        GlobalJumps.add()
    end,
    {
        desc = "Add global jump",
    }
)


-- ------------------------------------------------------------
-- Next
--
-- Alt+j
-- ------------------------------------------------------------

vim.keymap.set(
    "n",
    "<M-n>",
    function()
        GlobalJumps.next()
    end,
    {
        desc = "Next global jump",
    }
)

-- ------------------------------------------------------------
-- Previous
--
-- Alt+k
-- ------------------------------------------------------------

vim.keymap.set(
    "n",
    "<M-m>",
    function()
        GlobalJumps.previous()
    end,
    {
        desc = "Previous global jump",
    }
)

local function jump_to_empty_line()
  vim.fn.search('^$', 'w')
end

vim.keymap.set('n', 'X', jump_to_empty_line, { 
  desc = "Jump to next empty line", 
  silent = true 
})

vim.keymap.set({'v', 'o'}, 'X', jump_to_empty_line, { 
  desc = "Select up to next empty line", 
  silent = true 
})

local function view_markdown_colored()
  -- 1. Get the content of the current file
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local clean_lines = {}
  
  -- Create a fresh table to map highlighting metadata (row, start_col, end_col, group)
  local highlights = {}

  -- 2. Process line by line and track styling locations
  for i, line in ipairs(lines) do
    local clean_line = line
    
    -- Check if line is a header (starts with #)
    local header_level = line:match("^(#+)%s*")
    if header_level then
      clean_line = line:gsub("^#+%s*", "  ") -- Replace '#' with subtle indentation
      table.insert(highlights, {
        row = i - 1, 
        start_col = 0, 
        end_col = #clean_line, 
        group = "Function" -- Headers will be styled like Functions (usually Blue/Purple)
      })
    end

    -- Process bold elements (**text**)
    -- Loop to capture multiple bold elements in a single line if they exist
    while clean_line:find("%*%*(.-)%*%*") do
      local start_idx, end_idx, content = clean_line:find("%*%*(.-)%*%*")
      -- Replace tags in the string
      clean_line = clean_line:sub(1, start_idx - 1) .. content .. clean_line:sub(end_idx + 1)
      table.insert(highlights, {
        row = i - 1,
        start_col = start_idx - 1,
        end_col = start_idx - 1 + #content,
        group = "String" -- Bold text will be styled like Strings (usually Green)
      })
    end

    -- Check for markdown lists (- or *)
    if clean_line:match("^%s*[%-%*]%s+") then
      -- Highlight just the bullet point icon
      local start_idx, end_idx = clean_line:find("[%-%*]")
      table.insert(highlights, {
        row = i - 1,
        start_col = start_idx - 1,
        end_col = end_idx,
        group = "Identifier" -- Bullets styled as Identifiers (usually Cyan/Red)
      })
    end

    table.insert(clean_lines, clean_line)
  end

  -- 3. Create the temporary floating buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, clean_lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  -- 4. Apply colors using Neovim Namespace engine
  local ns_id = vim.api.nvim_create_namespace("md_viewer_colors")
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, ns_id, hl.group, hl.row, hl.start_col, hl.end_col)
  end

  -- 5. Calculate window layout
  local width = math.floor(vim.o.columns * 0.75)
  local height = math.floor(vim.o.lines * 0.75)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- 6. Open the window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = ' Colored MD Viewer (Press q to exit) ',
    title_pos = 'center',
  })

  -- 7. Bind 'q' to close window safely
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })
end

-- Create user command
vim.api.nvim_create_user_command('MdView', view_markdown_colored, {})
