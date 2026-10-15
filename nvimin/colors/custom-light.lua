-- custom_light.lua
-- Warm paper high-contrast light theme

vim.cmd("highlight clear")
vim.o.background = "light"
vim.g.colors_name = "custom_light"

-- =========================
-- Base colors
-- =========================
local bg      = "#fffef6" -- FFFef6"
local bg_alt  = "#f5f1e8"
local sel     = "#c7e0ff"
local fg      = "#1a1a1a"
local comment = "#4a4a4a"

local blue    = "#004b8d"
local blue2   = "#0057d9"
local purple  = "#4c1d95"
local green   = "#1b7f3a"
local cyan    = "#0047ab"
local red     = "#b00020"
local orange  = "#8a5a00"

-- =========================
-- Helper
-- =========================
local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- =========================
-- UI
-- =========================
hl("Normal",       { fg = fg, bg = bg })
hl("CursorLine",   { bg = "#f5f7fa" })
hl("LineNr",       { fg = "#8a8a8a" })
hl("CursorLineNr", { fg = "#000000", bold = true })

hl("Visual",       { bg = sel })
hl("Search",       { fg = "#ffffff", bg = "#ff3b30", bold = true })
hl("IncSearch",    { fg = "#000000", bg = "#ffd60a" })

hl("StatusLine",   { fg = "#000000", bg = "#e6e6e6" })
hl("StatusLineNC", { fg = "#666666", bg = "#f0f0f0" })

hl("VertSplit",    { fg = "#c0c0c0" })

hl("Directory",    { fg = blue })

-- =========================
-- Syntax (classic Vim groups)
-- =========================
hl("Comment",      { fg = comment, italic = true })
hl("String",       { fg = green })
hl("Number",       { fg = blue2, bold = true })
hl("Constant",     { fg = blue2, bold = true })
hl("Identifier",   { fg = blue })
hl("Function",     { fg = purple, bold = true })
hl("Keyword",      { fg = red, bold = true })
hl("Type",         { fg = orange, bold = true })
hl("PreProc",      { fg = cyan })

-- =========================
-- Treesitter (IMPORTANT for Svelte/JS/HTML)
-- =========================

-- tags / HTML / Svelte structure
hl("@tag",            { fg = blue })
hl("@tag.attribute",  { fg = red })
hl("@tag.delimiter",  { fg = orange })

-- strings / numbers / variables
hl("@string",         { fg = green })
hl("@number",         { fg = blue2, bold = true })
hl("@variable",       { fg = fg })
hl("@property",       { fg = blue })

-- functions / keywords
hl("@function",       { fg = purple, bold = true })
hl("@keyword",        { fg = red, bold = true })
hl("@type",           { fg = orange, bold = true })

-- punctuation
hl("@punctuation.delimiter", { fg = comment })
hl("@punctuation.bracket",    { fg = comment })

-- comments (Treesitter override)
hl("@comment", { fg = comment, italic = true })

-- =========================
-- LSP Semantic Highlights
-- =========================

hl("@lsp.type.function",   { fg = purple, bold = true })
hl("@lsp.type.method",     { fg = purple, bold = true })
hl("@lsp.type.variable",   { fg = fg })
hl("@lsp.type.parameter",  { fg = fg })
hl("@lsp.type.property",   { fg = blue })
hl("@lsp.type.keyword",    { fg = red, bold = true })
hl("@lsp.type.string",     { fg = green })
hl("@lsp.type.number",     { fg = blue2, bold = true })
hl("@lsp.type.type",       { fg = orange, bold = true })

hl("@lsp.mod.readonly",    { italic = true })
hl("@lsp.mod.static",      { bold = true })

-- =========================
-- Diagnostics (LSP)
-- =========================
hl("DiagnosticError", { fg = red })
hl("DiagnosticWarn",  { fg = orange })
hl("DiagnosticInfo",  { fg = cyan })
hl("DiagnosticHint",  { fg = blue })

-- =========================
-- Completion
-- =========================
hl("Pmenu",      { fg = fg, bg = bg_alt })
hl("PmenuSel",   { fg = "#000000", bg = sel, bold = true })
hl("PmenuThumb", { bg = "#c0c0c0" })

-- =========================
-- Diff
-- =========================
hl("DiffAdd",    { bg = "#d4f8d4" })
hl("DiffDelete", { bg = "#ffd6d6" })
hl("DiffChange", { bg = "#fff3b0" })

-- =========================
-- SVELTE CORE STRUCTURE
-- =========================

hl("@tag",           { fg = blue })
hl("@tag.delimiter", { fg = orange })
hl("@tag.attribute", { fg = red })

hl("@constant",      { fg = blue2, bold = true })
hl("@variable",      { fg = fg })
hl("@property",      { fg = blue })

-- =========================
-- SVELTE TEMPLATE BLOCKS
-- =========================

hl("@keyword", { fg = red, bold = true })

-- Svelte block keywords
hl("@keyword.directive", { fg = red, bold = true })
hl("@keyword.control",   { fg = red, bold = true })

hl("@punctuation.bracket", { fg = comment })
hl("@punctuation.delimiter", { fg = comment })

-- =========================
-- SVELTE SCRIPT BLOCK (JS/TS)
-- =========================

hl("@function",        { fg = purple, bold = true })
hl("@function.call",   { fg = purple })
hl("@method",          { fg = purple })

hl("@variable.builtin",{ fg = blue })
hl("@variable.parameter", { fg = fg })

hl("@operator",        { fg = comment })
hl("@number",          { fg = blue2, bold = true })
hl("@string",          { fg = green })

-- =========================
-- SVELTE CSS BLOCK
-- =========================

hl("@property.css", { fg = blue })
hl("@string.css",    { fg = green })
hl("@number.css",    { fg = blue2 })

hl("@type.css",      { fg = orange })
hl("@keyword.css",   { fg = red })

