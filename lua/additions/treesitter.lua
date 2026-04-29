-- Treesitter parsers for all target languages.
--
-- NvChad's default spec may already include some of these (vim, lua, vimdoc).
-- vim.list_extend in plugins/additions.lua deduplicates automatically.
--
-- To add a parser: append its Treesitter language name here, then run :TSUpdate.
return {
  ensure_installed = {
    -- Primary languages
    "c",
    "cpp",
    "java",
    "python",

    -- Secondary languages
    "bash",
    "javascript",
    "typescript",

    -- Neovim config / meta
    "lua",
    "vim",
    "vimdoc",
    "query",
  },
}
