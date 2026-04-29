-- Apply NvChad's default on_attach and capabilities to all LSP servers.
-- This must run before any vim.lsp.config() or vim.lsp.enable() call.
require("nvchad.configs.lspconfig").defaults()

-- Server list. To add a server: append its lspconfig name here, add its Mason package
-- to additions/mason.lua, and optionally add a vim.lsp.config() block below.
--
-- DO NOT add "jdtls" here. Ever.
-- Reason: nvim-java must call java.setup() before jdtls starts. If jdtls appears in
-- this list, vim.lsp.enable("jdtls") fires when lspconfig loads (User FilePost), which
-- is before nvim-java has been set up. jdtls would start without nvim-java's extensions
-- registered, silently breaking DAP, test runner, Spring Boot tools, and code actions.
-- Java is owned entirely by lua/plugins/lang/java.lua.
local servers = {
  "html",
  "cssls",
  "clangd",
  "pyright",
  "bashls",
  "ts_ls",     -- typescript-language-server (lspconfig name since nvim-lspconfig v0.1.7+)
  "lemminx",   -- XML LSP: Maven pom.xml, Spring Boot application.xml
}

-- clangd: background indexing, clang-tidy integration, detailed completion.
-- Uses .clang-format / compile_commands.json from project root when present.
-- Generate compile_commands.json with CMake (-DCMAKE_EXPORT_COMPILE_COMMANDS=ON)
-- or with Bear (bear -- make).
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})

-- pyright: basic type checking — informational, not blocking.
-- Raise typeCheckingMode to "standard" or "strict" for fully-typed projects.
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- bashls: include zsh so scripts are covered regardless of shebang.
vim.lsp.config("bashls", {
  filetypes = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
    },
  },
})

-- ts_ls uses lspconfig defaults — no override needed for standard JS/TS projects.

vim.lsp.enable(servers)
