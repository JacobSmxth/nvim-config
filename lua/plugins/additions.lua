return {
  -- Extend Mason's ensure_installed list with tools from additions/mason.lua.
  -- NvChad already declares mason.nvim; this spec is merged by lazy.nvim.
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, require("additions.mason").ensure_installed)
    end,
  },

  -- Extend Treesitter's ensure_installed list with parsers from additions/treesitter.lua.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, require("additions.treesitter").ensure_installed)
    end,
  },

  -- DAP core. Loads lazily; config runs on first require("dap") (e.g., from a keymap).
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      require("additions.dap").setup()
    end,
  },

  -- DAP UI. `dependencies` guarantees nvim-dap (and its config) loads first.
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- async library required by dap-ui
    },
    config = function()
      require("additions.dap").setup_ui()
    end,
  },

  -- DAP adapter installer. SOLE owner of DAP adapter/debugger packages.
  -- Do not list DAP adapters in additions/mason.lua; that layer owns LSP/formatters only.
  --
  -- NAME TYPE: ensure_installed uses DAP adapter names (dap.adapters.*), not Mason pkg names.
  -- For codelldb these are identical. They can differ for other adapters:
  --   DAP name "python"  → Mason package "debugpy"
  --   DAP name "codelldb" → Mason package "codelldb"  ← same
  -- Check mason-nvim-dap source for the mapping before adding new adapters.
  --
  -- automatic_installation = false: prevents mason-nvim-dap from scanning dap.adapters
  -- at load time and issuing implicit installs. That scan races with mason.nvim's own
  -- installer. Use the explicit ensure_installed list only.
  --
  -- handlers = {}: disables automatic dap.adapters wiring. Adapters are registered
  -- explicitly in additions/dap.lua for predictable, self-documented configuration.
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "codelldb" }, -- DAP adapter name, happens to match Mason pkg name
      automatic_installation = false,
      handlers = {},
    },
  },

  -- Surround: add/change/delete surrounding delimiters, quotes, tags
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Sleuth: auto-detect indentation (tabstop, shiftwidth, expandtab) from file context
  {
    "tpope/vim-sleuth",
    event = "BufReadPre",
  },

  -- Flash: fast jump-to-anywhere motions with labeled targets
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s",     function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S",     function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "r",     function() require("flash").remote() end,            mode = "o",               desc = "Flash remote" },
      { "R",     function() require("flash").treesitter_search() end, mode = { "o", "x" },      desc = "Flash Treesitter search" },
      { "<c-s>", function() require("flash").toggle() end,            mode = "c",               desc = "Flash toggle search" },
    },
  },

  -- Oil: buffer-native filesystem editing (browse, rename, move, delete)
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    config = function()
      require("additions.oil").setup()
    end,
  },
}
