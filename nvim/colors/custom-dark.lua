-- custom-dark.lua -- Neovim colorscheme converted from Emacs Base16 version
-- Made for Jonas Fredriksson

local colors = {
  base00 = "#101010", -- Background
  base01 = "#2a2a2a", -- more visible UI
  base02 = "#2f5f8f", -- stronger selection
  base03 = "#6a8fa3", -- dimmer commentsase
  base04 = "#ffffff", -- Subtle UI
  base05 = "#e6f1ff", -- Foreground
  base06 = "#f5faff", -- Bright text
  base07 = "#ffffff", -- Brightest foreground
  base08 = "#aefbae", -- Variables, errors
  base09 = "#66aaff", -- Numbers
  base0A = "#cc6666", -- Types
  base0B = "#b3f4ff", -- Strings
  base0C = "#00bcd4", -- Regexps, escapes
  base0D = "#00bfff", -- Functions
  base0E = "#68ffff", -- Keywords
  base0F = "#b08060",
}

local set = vim.api.nvim_set_hl

-- Editor UI
set(0, "Normal",        { fg = colors.base05, bg = colors.base00 })
set(0, "LineNr", { fg = "#73cceb", bold = false })
set(0, "LineNrAbove", { fg = "#4dd0e1", bold = true })
set(0, "LineNrBelow", { fg = "#73cceb", bold = true })
set(0, "CursorLineNr", { fg = "#ffffff", bold = true })
set(0, "SignColumn",   { bg = colors.base00 })
set(0, "CursorLineNr",  { fg = "#ffffff", bold = true })
set(0, "CursorLine",    { bg = "#1f1f1f" })
set(0, "Visual",        { bg = "#3a6ea5" })
set(0, "Search",        { fg = "#000000", bg = "#b08060", bold = true })
set(0, "IncSearch",     { fg = "#000000", bg = "#27eef5", bold = true })
-- Syntax
set(0, "Comment",       { fg = colors.base03, italic = true })
set(0, "Constant",      { fg = colors.base09 })
set(0, "String",        { fg = colors.base0B })
set(0, "Number",        { fg = colors.base09 })
set(0, "Identifier",    { fg = colors.base08 })
set(0, "Function",      { fg = colors.base0D })
set(0, "Statement",     { fg = colors.base0E })
set(0, "Keyword",       { fg = colors.base0E })
set(0, "Type",          { fg = colors.base0A })
set(0, "Special",       { fg = colors.base0C })

-- Statusline / UI
set(0, "StatusLine",    { fg = colors.base05, bg = colors.base01 })
set(0, "StatusLineNC",  { fg = colors.base03, bg = colors.base01 })
set(0, "VertSplit",     { fg = colors.base01 })
set(0, "Pmenu",         { fg = colors.base05, bg = colors.base01 })
set(0, "PmenuSel",      { fg = colors.base00, bg = colors.base0D })

-- Diagnostics (LSP)
set(0, "DiagnosticError", { fg = "#ffaaaa" })
set(0, "DiagnosticWarn",  { fg = "#ffd27f" })
set(0, "DiagnosticInfo",  { fg = colors.base0D })
set(0, "DiagnosticHint",  { fg = colors.base0C })

-- Git signs
set(0, "DiffAdd",    { bg = "#0c2a0c" })
set(0, "DiffDelete", { bg = "#2a0c0c" })
set(0, "DiffChange", { bg = "#0c0c2a" })

set(0, "NormalFloat", { bg = "#1a1a1a" })
set(0, "FloatBorder", { fg = "#444444" })
set(0, "WinSeparator", { fg = "#303030" })
set(0, "CursorColumn", { bg = "#1a1a1a" })

set(0, "DiagnosticError", { fg = "#ff6b6b", bold = true })
set(0, "DiagnosticWarn",  { fg = "#ffcc66", bold = true })
set(0, "DiagnosticInfo",  { fg = "#66b3ff" })
set(0, "DiagnosticHint",  { fg = "#4dd0e1" })

vim.cmd("highlight Comment gui=italic")

if vim.g.transparent then
  set(0, "Normal", { fg = colors.base05, bg = "none" })
end

set(0, "@function", { fg = colors.base0D })
set(0, "@keyword",  { fg = colors.base0E })
set(0, "@string",   { fg = colors.base0B })
set(0, "@type",     { fg = colors.base0A })

set(0, "@variable",           { fg = "#4dd0e1" })
set(0, "@variable.parameter", { fg = "#66aaff" })
set(0, "@field",              { fg = colors.base09 })
set(0, "@property",           { fg = colors.base09 })
set(0, "@local",              { fg = colors.base08 })
vim.g.colors_name = "custom-dark"

