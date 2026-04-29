local M = {}

function M.setup()
  require("oil").setup {
    -- false: don't intercept directory opens; nvim-tree remains the tree sidebar
    default_file_explorer = false,
    columns = { "icon" },
    view_options = {
      show_hidden = false,
    },
    keymaps = {
      -- NvChad uses <C-s> for save; disable oil's default horizontal-split binding
      ["<C-s>"] = false,
    },
  }
end

return M
