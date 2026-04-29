-- Java support via nvim-java.
--
-- nvim-java bundles java-core, java-dap, java-test, and async internally.
-- Do NOT add nvim-java/nvim-java-core, nvim-java/nvim-java-test, etc. as dependencies.
-- Those are legacy separate repos that now duplicate nvim-java's bundled Lua modules,
-- creating runtimepath conflicts (two directories exporting the same module names).
--
-- lazy = false: nvim-java must load at startup so java.setup() runs before any FileType
-- event fires. With defaults.lazy = true, there is no safe ft-based trigger that
-- guarantees setup() precedes jdtls start in all cases.
--
-- Load order guaranteed by lazy = false + lspconfig dependency:
--   1. lspconfig loads → defaults() + vim.lsp.enable(non-java servers)
--   2. nvim-java loads → java.setup() → vim.lsp.enable("jdtls")
--   3. User opens .java file → FileType "java" → jdtls starts (extensions already registered)
--
-- nvim-java manages: jdtls install (via its own Mason registry), DAP (java-debug-adapter,
-- vscode-java-test), test runner, Spring Boot tools, and all :Java* commands.
--
-- First open of a .java file triggers jdtls download on a fresh machine; subsequent
-- opens are fast. Gradle and Maven projects are auto-detected via root heuristics.
--
-- Useful commands:
--   :JavaBuildBuildWorkspace  — build the project
--   :JavaBuildCleanWorkspace  — clear workspace cache (reopen to restart jdtls)
--   :JavaTestRunCurrentClass  — run tests in the active buffer
--   :JavaTestRunCurrentMethod — run the test under the cursor
--   :JavaDapConfig            — force-reconfigure DAP for the current project
--   :JavaRunnerRunMain        — run the application main class
--   :checkhealth java         — diagnose jdtls and nvim-java issues

return {
  {
    "nvim-java/nvim-java",
    lazy = false, -- must be set up before any FileType event fires; see load order above
    dependencies = {
      -- lspconfig must be loaded before java.setup() so defaults() has already run.
      "neovim/nvim-lspconfig",
      -- nvim-java's own lazy.lua declares these two; we mirror them for explicit clarity.
      "MunifTanjim/nui.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- java.setup() registers nvim-java's jdtls extensions.
      -- It must run before vim.lsp.enable("jdtls") — order here is load-order-critical.
      require("java").setup()

      -- sourcePaths tells jdtls where Java sources live when there is no build file (pom.xml /
      -- build.gradle). With only a .git root marker, jdtls cannot infer this on its own.
      -- Maven/Gradle projects override these automatically via their build manifests.
      vim.lsp.config("jdtls", {
        settings = {
          java = {
            project = {
              sourcePaths = { "src", "src/main/java", "." },
            },
          },
        },
      })

      vim.lsp.enable("jdtls")
    end,
  },

  -- nvim-java requires its own Mason registry for jdtls and associated debug tools.
  -- The nvim-java registry must come before the default mason-org registry.
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      }
    end,
  },
}
