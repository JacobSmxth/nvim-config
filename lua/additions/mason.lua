-- Mason-managed tools for all languages except Java.
--
-- OWNERSHIP RULE:
--   This list owns: LSP servers, formatters, linters, and non-DAP external tools.
--   DAP adapters/debuggers are owned by mason-nvim-dap (lua/plugins/additions.lua).
--   Java tooling is owned by nvim-java (lua/plugins/lang/java.lua).
--   Do not declare the same tool in more than one installer layer.
--
-- To add a tool: append its Mason package name below, then run :Lazy sync
-- or :MasonInstallAll. Also add any new LSP server to additions/lsp.lua.
return {
  ensure_installed = {
    -- C / C++ (codelldb is a DAP adapter — owned by mason-nvim-dap, not here)
    "clangd",
    "clang-format",

    -- Python
    "pyright",
    "black",

    -- Bash / Shell
    "bash-language-server",
    "shfmt",

    -- JavaScript / TypeScript
    "typescript-language-server",
    "prettier",

    -- Lua (for this Neovim config)
    "stylua",

    -- XML (Maven pom.xml, Spring Boot config files)
    "lemminx",

    -- Java formatter (google-java-format uses K&R braces; jdtls Eclipse formatter defaults Allman)
    "google-java-format",
  },
}
