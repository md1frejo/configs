local M = {}

-- Open floating window with a list of strings
local function open_float(lines, title)
  local buf = vim.api.nvim_create_buf(false, true) -- scratch buffer

  -- Make buffer modifiable before writing
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  -- Add title if given
  if title then
    table.insert(lines, 1, title)
    table.insert(lines, 2, "") -- blank line after title
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Close on <Esc> or q
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })
end

-- :SearchKey <keyword>
function M.search(keyword)
  if not keyword or keyword == "" then
    print("Usage: :SearchKey <keyword>")
    return
  end

  local results = {}
  local found = false
  local modes = { n = "Normal", i = "Insert", v = "Visual", x = "Visual", s = "Select" }

  for _, mode in ipairs({ "n", "i", "v", "x", "s" }) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, m in ipairs(maps) do
      if m.desc and m.desc:lower():find(keyword:lower()) then
        table.insert(results, string.format("[%s] %s -> %s (%s)", modes[mode] or mode, m.lhs, m.rhs, m.desc))
        found = true
      end
    end
  end

  if not found then
    results = { "No keymaps found for: " .. keyword }
  end

  open_float(results, "SearchKey Results")
end

-- Create command :SearchKey
vim.api.nvim_create_user_command("SearchKey", function(opts)
  M.search(opts.args)
end, { nargs = 1 })

return M
