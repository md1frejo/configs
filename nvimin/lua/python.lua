function Bins()
-- insert B()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- Insert "B()" on a new line below the current line
    vim.api.nvim_buf_set_lines(0, row,row, false, {"    B()"})
    vim.api.nvim_win_set_cursor(0, {row + 1, 8})
end

function Cins()
-- insert comment # ... 
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line_count = vim.api.nvim_buf_line_count(0)
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_set_current_line("# " .. line)
  vim.api.nvim_win_set_cursor(0, {row, col + 1})
--  vim.api.nvim_buf_set_lines(0, row, row, true, {"#"})
--  vim.api.nvim_win_set_cursor(0, {row,col})
  vim.api.nvim_command('startinsert')

end

function sfd()
-- search for def
    local result = vim.fn.search('def', 'w')
    vim.cmd('normal! zz')
end

function sfb()
-- search for def but with shift backward
    local result = vim.fn.search('def', 'b')
    vim.cmd('normal! zz')
end

-- Function to comment out a visual selection (Python style comments)
function cpr()
    -- Get the current buffer
    local buf = vim.api.nvim_get_current_buf()
    -- Get the start and end of the visual selection (0-indexed)
    local start_row, _, end_row, _ = unpack(vim.fn.getpos("'<")), unpack(vim.fn.getpos("'>"))
    print(buf,start_row,line)
    -- Adjust start and end row (since Lua is 1-indexed)
    start_row = start_row - 1
    end_row = end_row - 1
    -- Loop through each line in the visual selection
    for row = start_row, end_row do
        -- Get the content of the current line
        local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
        -- Add a Python comment symbol '#' at the beginning of the line
        vim.api.nvim_buf_set_lines(buf, row, row + 1, false, {"# " .. line})
    end
end

