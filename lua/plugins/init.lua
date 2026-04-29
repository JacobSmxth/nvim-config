return {
  {
    "stevearc/conform.nvim",
    -- Load early so format_on_save autocmd registers before the first write.
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
}
