-- conform.nvim full configuration.
--
-- Java uses google-java-format (K&R brace style, deterministic output).
-- jdtls's built-in Eclipse formatter was removed — it defaults to Allman style
-- and can mangle code on auto-save.
--
-- To add a formatter for a new language:
--   1. Add a filetype entry to formatters_by_ft.
--   2. Add the tool's Mason package name to additions/mason.lua.
--   3. Optionally add formatter args under the `formatters` table.
return {
  formatters_by_ft = {
    java       = { "google-java-format" },
    lua        = { "stylua" },
    c          = { "clang_format" },
    cpp        = { "clang_format" },
    python     = { "black" },
    sh         = { "shfmt" },
    bash       = { "shfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json       = { "prettier" },
    html       = { "prettier" },
    css        = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true, -- Java and any unlisted filetype fall back to LSP formatting
  },

  formatters = {
    ["google-java-format"] = {
      args = { "--aosp", "-" }, -- AOSP style: 4-space indent; "-" reads from stdin
    },
    clang_format = {
      -- Reads .clang-format from project root; falls back to LLVM style.
      prepend_args = { "--style=file", "--fallback-style=LLVM" },
    },
    black = {
      prepend_args = { "--line-length", "100" },
    },
    shfmt = {
      -- 4-space indent (-i 4), indent switch cases (-ci), binary ops at line end (-bn)
      prepend_args = { "-i", "4", "-ci", "-bn" },
    },
    prettier = {
      prepend_args = { "--print-width", "100" },
      -- A .prettierrc in the project root overrides all args above.
    },
  },
}
