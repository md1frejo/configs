
local ignore_patterns = {
	"node_modules",
	"%.git",
	"%.cache",
	"dist",
	"build",
	"%.tmp",
	"%.log",
}

local function should_ignore(path)
	for _, pat in ipairs(ignore_patterns) do
		if path:match(pat) then
			return true
		end
	end
	return false
end

function _G.native_find(text, _)
	-- Expand ~
	text = vim.fn.expand(text)

	-- Separate directory from filename/pattern.
	--
	-- Examples:
	--   init.lua       -> dir=".",       pattern="init.lua"
	--   ../init.lua    -> dir="..",      pattern="init.lua"
	--   ../../init.lua -> dir="../..",   pattern="init.lua"
	--   /tmp/init.lua  -> dir="/tmp",    pattern="init.lua"
	local dir, pattern = text:match("^(.*)/([^/]*)$")

	if not dir then
		dir = "."
		pattern = text
	end

	-- If the user has only typed the directory so far,
	-- allow completion inside it.
	if pattern == "" then
		pattern = "*"
	end

	-- Search recursively below the requested directory.
	local glob_pattern = dir .. "/**/" .. pattern

	local files = vim.fn.glob(glob_pattern, true, true)

	local result = {}

	for _, f in ipairs(files) do
		if vim.fn.isdirectory(f) == 0 and not should_ignore(f) then
			result[#result + 1] = f
		end
	end

	-- Fuzzy-match the filename/pattern while preserving the path.
	return vim.fn.matchfuzzy(result, pattern)
end

vim.opt.findfunc = "v:lua.native_find"

vim.keymap.set("n", "<leader>d", ":find ", { silent = false })
