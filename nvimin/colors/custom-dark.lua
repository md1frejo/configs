-- custom-dark.lua
-- GitHub Dark High Contrast Theme adaptation
-- Made for Jonas Fredriksson

vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "custom-dark"

-- ============================================================
-- GitHub Dark High Contrast Palette
-- ============================================================

local colors = {
  -- Background / foreground
  bg          = "#010409", -- Pure pitch black canvas
  bg_alt      = "#0d1117", -- Slightly lighter panel background
  bg_float    = "#161b22", -- Bordered floating elements
  bg_visual   = "#033a71", -- Deep vibrant blue selection

  fg          = "#f0f6fc", -- High contrast near-white text
  fg_bright   = "#ffffff", -- Absolute white
  fg_muted    = "#8b949e", -- Medium gray for comments
  border      = "#30363d", -- Crisp panel borders

  -- Semantic syntax mapping
  orange      = "#ff7b72", -- Keywords / Control statements
  blue        = "#79c0ff", -- Variables / Fields / Parameters
  blue_bright = "#58a6ff", -- Functions / Methods / Classes
  green       = "#7ee787", -- Strings
  teal        = "#1f6feb", -- Specialized attributes / builtins
  purple      = "#d2a8ff", -- Numbers / Constants / Operators
  red         = "#ffa198", -- Types / Escapes / Tags

  -- Diagnostics
  error       = "#f85149",
  warning     = "#f0883e",
  info        = "#58a6ff",
  hint        = "#8b949e",
}

local set = vim.api.nvim_set_hl

-- ============================================================
-- Editor UI
-- ============================================================

-- ============================================================
-- Editor UI
-- ============================================================

set(0, "Normal", { fg = colors.fg, bg = colors.bg })
set(0, "CursorLine", { bg = colors.bg_alt })
set(0, "CursorColumn", { bg = colors.bg_alt })

-- High-contrast Line Numbers
set(0, "LineNr", { fg = colors.fg_muted })       -- Clearer, prominent high-contrast gray (#8b949e)
set(0, "LineNrAbove", { fg = "#6e7681" })        -- Official GitHub Primer dark gray for relative numbers
set(0, "LineNrBelow", { fg = "#6e7681" })        -- Official GitHub Primer dark gray for relative numbers
set(0, "CursorLineNr", { fg = colors.fg_bright, bold = true }) -- Absolute white for the current line

set(0, "SignColumn", { bg = colors.bg })
set(0, "Visual", { bg = colors.bg_visual })
set(0, "Search", { fg = colors.bg, bg = "#f2cc60", bold = true })
set(0, "IncSearch", { fg = colors.bg, bg = colors.orange, bold = true })
set(0, "Directory", { fg = colors.blue_bright })

-- ============================================================
-- Statusline & Splits
-- ============================================================

set(0, "StatusLine", { fg = colors.fg, bg = colors.bg_alt })
set(0, "StatusLineNC", { fg = colors.fg_muted, bg = colors.bg })
set(0, "WinSeparator", { fg = colors.border })
set(0, "VertSplit", { fg = colors.border })

-- ============================================================
-- Floating windows
-- ============================================================

set(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_float })
set(0, "FloatBorder", { fg = colors.border, bg = colors.bg_float })

-- ============================================================
-- Completion
-- ============================================================

set(0, "Pmenu", { fg = colors.fg, bg = colors.bg_alt })
set(0, "PmenuSel", { fg = colors.fg_bright, bg = colors.bg_visual, bold = true })
set(0, "PmenuSbar", { bg = colors.bg })
set(0, "PmenuThumb", { bg = colors.border })

-- ============================================================
-- Classic Vim syntax
-- ============================================================

set(0, "Comment", { fg = colors.fg_muted, italic = true })
set(0, "Constant", { fg = colors.purple })
set(0, "String", { fg = colors.green })
set(0, "Number", { fg = colors.purple })
set(0, "Identifier", { fg = colors.blue })
set(0, "Function", { fg = colors.blue_bright })
set(0, "Statement", { fg = colors.orange })
set(0, "Keyword", { fg = colors.orange })
set(0, "Type", { fg = colors.red })
set(0, "Special", { fg = colors.teal })
set(0, "Operator", { fg = colors.orange })

-- ============================================================
-- Treesitter
-- ============================================================

-- Functions
set(0, "@function", { fg = colors.blue_bright, bold = true })
set(0, "@function.call", { fg = colors.blue_bright })
set(0, "@method", { fg = colors.blue_bright })
set(0, "@method.call", { fg = colors.blue_bright })

-- Keywords
set(0, "@keyword", { fg = colors.orange, bold = true })
set(0, "@keyword.function", { fg = colors.orange, bold = true })
set(0, "@keyword.return", { fg = colors.orange, bold = true })

-- Strings
set(0, "@string", { fg = colors.green })
set(0, "@string.escape", { fg = colors.red })
set(0, "@string.special", { fg = colors.red })

-- Numbers / constants
set(0, "@number", { fg = colors.purple })
set(0, "@number.float", { fg = colors.purple })
set(0, "@constant", { fg = colors.purple })
set(0, "@constant.builtin", { fg = colors.orange })

-- Variables
set(0, "@variable", { fg = colors.fg })
set(0, "@variable.builtin", { fg = colors.blue })
set(0, "@variable.parameter", { fg = colors.blue })
set(0, "@variable.member", { fg = colors.blue })

-- Properties / fields
set(0, "@property", { fg = colors.blue })
set(0, "@field", { fg = colors.blue })

-- Types
set(0, "@type", { fg = colors.red })
set(0, "@type.builtin", { fg = colors.red })
set(0, "@constructor", { fg = colors.fg })

-- Operators / punctuation
set(0, "@operator", { fg = colors.orange })
set(0, "@punctuation.delimiter", { fg = colors.fg })
set(0, "@punctuation.bracket", { fg = colors.fg })
set(0, "@comment", { fg = colors.fg_muted, italic = true })

-- Tags
set(0, "@tag", { fg = colors.green })
set(0, "@tag.attribute", { fg = colors.purple })
set(0, "@tag.delimiter", { fg = colors.fg_muted })

-- ============================================================
-- LSP Semantic Tokens
-- ============================================================

set(0, "@lsp.type.function", { fg = colors.blue_bright, bold = true })
set(0, "@lsp.type.method", { fg = colors.blue_bright })
set(0, "@lsp.type.variable", { fg = colors.fg })
set(0, "@lsp.type.parameter", { fg = colors.blue })
set(0, "@lsp.type.property", { fg = colors.blue })
set(0, "@lsp.type.keyword", { fg = colors.orange, bold = true })
set(0, "@lsp.type.string", { fg = colors.green })
set(0, "@lsp.type.number", { fg = colors.purple })
set(0, "@lsp.type.type", { fg = colors.red })
set(0, "@lsp.mod.readonly", { italic = false })
set(0, "@lsp.mod.static", { bold = true })

-- ============================================================
-- Diagnostics
-- ============================================================

set(0, "DiagnosticError", { fg = colors.error })
set(0, "DiagnosticWarn", { fg = colors.warning })
set(0, "DiagnosticInfo", { fg = colors.info })
set(0, "DiagnosticHint", { fg = colors.hint })

set(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })
set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
set(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

-- ============================================================
-- Diff
-- ============================================================

set(0, "DiffAdd", { bg = "#0f5323" })
set(0, "DiffDelete", { bg = "#78191b" })
set(0, "DiffChange", { bg = "#0c2d54" })
set(0, "DiffText", { bg = "#033a71" })

-- ============================================================
-- Cursor
-- ============================================================

set(0, "Cursor", { fg = colors.bg, bg = colors.blue_bright })

-- ============================================================
-- Transparent mode
-- ============================================================

if vim.g.transparent then
  set(0, "Normal", { fg = colors.fg, bg = "none" })
  set(0, "SignColumn", { bg = "none" })
  set(0, "NormalFloat", { fg = colors.fg, bg = "none" })
end
