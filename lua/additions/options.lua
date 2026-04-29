local opt = vim.opt

-- Line numbers: absolute on current line, relative elsewhere
opt.number = true
opt.relativenumber = true

-- Keep context lines visible when scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- No line wrapping
opt.wrap = false

-- Column ruler — helps enforce line-length conventions
opt.colorcolumn = "100"

-- Always show sign column to prevent layout shift on diagnostics
opt.signcolumn = "yes"

-- Default indentation: 4 spaces, expanded.
-- Per-language overrides (C uses real tabs) live in additions/autocmds.lua.
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Case-smart search: lowercase = case-insensitive, mixed = case-sensitive
opt.ignorecase = true
opt.smartcase = true

-- System clipboard integration
opt.clipboard = "unnamedplus"

-- Splits open predictably
opt.splitright = true
opt.splitbelow = true

-- Persist undo history across Neovim sessions
opt.undofile = true
opt.swapfile = false

-- Diagnostics: no inline virtual text clutter, errors before hints, no flicker in insert
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
