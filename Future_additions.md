# Future Additions — Architecture Rules

This document is the law of this Neovim configuration.
Its purpose is to prevent configuration drift and ensure that every future change —
whether made by a human or an AI — lands in the right place.

---

## Core Principle

**NvChad base files are wiring stubs. All real logic lives in `lua/additions/`
and `lua/plugins/`.**

The files listed in the "Do Not Edit" section below are effectively read-only except
for the minimal wiring lines already present. Do not add logic to them.

---

## Tool Ownership Rules

**Every external tool must be declared in exactly one installer layer. Never in two.**

Violating this causes Mason install races at startup (`Package is already installing`).

| Tool category | Owner | Where declared |
|---|---|---|
| LSP servers | `mason.nvim` | `lua/additions/mason.lua` |
| Formatters | `mason.nvim` | `lua/additions/mason.lua` |
| Linters | `mason.nvim` | `lua/additions/mason.lua` |
| Any other non-DAP tool | `mason.nvim` | `lua/additions/mason.lua` |
| DAP adapters / debuggers | `mason-nvim-dap` | `lua/plugins/additions.lua` → `mason-nvim-dap` opts |
| Java tooling (jdtls, java-debug, vscode-java-test) | `nvim-java` | `lua/plugins/lang/java.lua` |

### Mason vs mason-nvim-dap — name type distinction

`mason.nvim` `ensure_installed` uses **Mason package names** (e.g., `"bash-language-server"`).

`mason-nvim-dap` `ensure_installed` uses **DAP adapter names** as registered in `dap.adapters.*`
(e.g., `"codelldb"`). These can differ from Mason package names:

| DAP adapter name | Mason package name |
|---|---|
| `codelldb` | `codelldb` ← same |
| `python` | `debugpy` ← different |
| `delve` | `delve` ← same |

Always check the mason-nvim-dap source for the mapping before adding a new DAP adapter.

### automatic_installation in mason-nvim-dap

Keep `automatic_installation = false`. Setting it to `true` makes mason-nvim-dap scan
`dap.adapters` at load time and install anything not yet present — this races with
mason.nvim's own installer when any adapter is registered before `VeryLazy` fires.
Use the explicit `ensure_installed` list instead.

### Adding a new DAP adapter — checklist

1. Add the DAP adapter name to `ensure_installed` in the `mason-nvim-dap` opts block
   in `lua/plugins/additions.lua`.
2. Register the adapter and launch configurations in `lua/additions/dap.lua` inside `M.setup()`.
3. Do **not** add the corresponding Mason package to `lua/additions/mason.lua`.
4. Do **not** set `automatic_installation = true`.

---

## Architecture Overview

```
lua/additions/
  options.lua     ← vim.opt settings
  mappings.lua    ← keymaps
  autocmds.lua    ← autocommands
  lsp.lua         ← LSP server configs
  mason.lua       ← Mason ensure_installed: LSP servers, formatters, linters ONLY
  treesitter.lua  ← Treesitter ensure_installed parser list
  formatting.lua  ← conform.nvim config (formatters, format_on_save)
  dap.lua         ← nvim-dap adapters + launch configurations

lua/plugins/
  additions.lua         ← mason ext + treesitter ext + DAP stack plugin specs
  lang/java.lua         ← nvim-java
  lang/c.lua            ← C/C++ anchor (currently no extra plugins needed)
  lang/python.lua       ← Python anchor
  lang/bash.lua         ← Bash anchor
  lang/javascript.lua   ← JS/TS anchor

lua/chadrc.lua          ← NvChad UI / theme (intentionally user-edited)
```

---

## Where to Put Future Changes

### New plugins — non-language-specific
→ **`lua/plugins/additions.lua`**

Add a new entry to the return table. Use lazy.nvim spec format.
If the plugin needs runtime config, put it in `lua/additions/` and call it from the spec's
`config` function.

**Examples:** UI plugins (zen.nvim, twilight.nvim), completion engines, motion/navigation enhancements.

### New plugins — language-specific
→ **`lua/plugins/lang/<language>.lua`**

Each language has its own file. Adding a new language file is automatically picked up by
`{ import = "plugins.lang" }` in `init.lua` — no other file needs to change.

### LSP server configuration
→ **`lua/additions/lsp.lua`**

1. Add `vim.lsp.config("server_name", { ... })` with any custom options.
2. Append the server name to the `servers` table.
3. Add the server's Mason package name to `lua/additions/mason.lua`.

**Exception:** Java (`jdtls`) is managed by nvim-java. Do not add it here.

### Mason tool declarations
→ **`lua/additions/mason.lua`**

LSP servers, formatters, and linters only. Do not add DAP adapters here.
After editing, run `:Lazy sync` or `:MasonInstallAll`.

**Exception:** Java tooling (`jdtls`, `java-debug-adapter`, `vscode-java-test`) is installed
by nvim-java via its own Mason registry. Do not add those here.

### Treesitter parser declarations
→ **`lua/additions/treesitter.lua`**

Append to the `ensure_installed` list. After editing, run `:TSUpdate`.

### Formatters and linters (conform.nvim)
→ **`lua/additions/formatting.lua`**

1. Add a filetype entry to `formatters_by_ft`.
2. Add the tool's Mason package name to `lua/additions/mason.lua`.
3. Optionally add formatter CLI args under `formatters`.

### DAP / debugging adapters and launch configurations
→ **`lua/additions/dap.lua`** (adapter registration + launch configs)
→ **`lua/plugins/additions.lua`** (add DAP adapter name to `mason-nvim-dap` `ensure_installed`)

Do **not** add the Mason package name to `lua/additions/mason.lua`.
See "Adding a new DAP adapter" checklist in the Tool Ownership Rules section above.

**Exception:** Java DAP is handled automatically by `nvim-java/nvim-java-dap`.

### Keymaps
→ **`lua/additions/mappings.lua`**

Use `vim.keymap.set()`. Group related maps with a comment header.
Do not add keymaps to `lua/mappings.lua` directly.

### vim.opt settings
→ **`lua/additions/options.lua`**

Use `vim.opt.*`. Per-filetype overrides use `vim.opt_local.*` inside a FileType autocmd
in `additions/autocmds.lua`. Do not add settings to `lua/options.lua` directly.

### Autocommands
→ **`lua/additions/autocmds.lua`**

Use `vim.api.nvim_create_autocmd()`. Always create a named augroup with `{ clear = true }`.
Do not add autocommands to `lua/autocmds.lua` directly.

### NvChad UI / theme changes
→ **`lua/chadrc.lua`**

This is the one base file intentionally user-edited.
Refer to: https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

### Language-specific enhancements
- Plugin declarations → `lua/plugins/lang/<language>.lua`
- LSP config → `lua/additions/lsp.lua`
- Formatter config → `lua/additions/formatting.lua`
- Debugger config → `lua/additions/dap.lua`
- Mason tools (non-DAP) → `lua/additions/mason.lua`
- DAP adapter install → `mason-nvim-dap` opts in `lua/plugins/additions.lua`

---

## Do Not Edit (Base Wiring Files)

These files are intentionally minimal. They contain only `require` delegation calls.
Do not add logic to them directly.

| File | Contents |
|------|----------|
| `init.lua` | lazy.nvim bootstrap + `{ import = "plugins" }` + `{ import = "plugins.lang" }` |
| `lua/options.lua` | `require "nvchad.options"` + `require "additions.options"` |
| `lua/mappings.lua` | `require "nvchad.mappings"` + `require "additions.mappings"` |
| `lua/autocmds.lua` | `require "nvchad.autocmds"` + `require "additions.autocmds"` |
| `lua/configs/conform.lua` | `return require "additions.formatting"` |
| `lua/configs/lspconfig.lua` | `require "additions.lsp"` |
| `lua/plugins/init.lua` | conform.nvim + nvim-lspconfig plugin specs only |
| `lua/configs/lazy.lua` | lazy.nvim performance/UI config (no custom logic) |

---

## Checklist for Future AI Prompts

Before making any change, verify each item:

- [ ] Is this a plugin addition? → `lua/plugins/additions.lua` or `lua/plugins/lang/`
- [ ] Is this an LSP server config? → `lua/additions/lsp.lua` (and `mason.lua`)
- [ ] Is this a formatter or linter? → `lua/additions/formatting.lua` (and `mason.lua`)
- [ ] Is this a DAP adapter? → `lua/additions/dap.lua` + `mason-nvim-dap` opts (NOT `mason.lua`)
- [ ] Is this a keymap? → `lua/additions/mappings.lua`
- [ ] Is this a vim option? → `lua/additions/options.lua`
- [ ] Is this an autocommand? → `lua/additions/autocmds.lua`
- [ ] Does the change touch a base wiring file? If yes, is it strictly necessary?
- [ ] Does the change introduce a new Mason tool (non-DAP)? Added to `mason.lua` only?
- [ ] Does the change introduce a DAP adapter? Added to `mason-nvim-dap` opts only?
- [ ] Does the change introduce a new Treesitter parser? Added to `treesitter.lua`?
- [ ] Is any tool now declared in more than one installer layer? If yes, remove the duplicate.
- [ ] Is the change isolated and minimal — no unnecessary refactoring of surrounding code?
- [ ] Are all new plugins lazy-loaded correctly (event, ft, cmd, or keys trigger)?

---

## Conventions for Every Addition

1. **Minimal:** Add only what is required for the stated goal.
2. **Isolated:** Do not touch files outside the stated scope of the change.
3. **Explicit:** Name Mason tools and Treesitter parsers explicitly by their canonical names.
4. **Single owner:** Every external tool is declared in exactly one installer layer.
5. **Consistent:** Follow the existing pattern in the target file (same style, same structure).
6. **No base edits:** If in doubt whether a base file needs to change, it almost certainly does not.
7. **No speculation:** If a plugin choice is uncertain, document it rather than guessing.

---

## Current Tooling Reference

| Language | LSP | Formatter | Debugger |
|----------|-----|-----------|----------|
| Java | jdtls (nvim-java) | jdtls built-in (lsp_fallback) | nvim-java-dap (auto) |
| C/C++ | clangd | clang-format | codelldb |
| Python | pyright | black | — |
| Bash/Shell | bashls | shfmt | — |
| JS/TS | ts_ls | prettier | — |
| Lua | — | stylua | — |

## Installer Layer Reference

| Tool | Mason package name | Installer layer | Declared in |
|------|-------------------|-----------------|-------------|
| clangd | clangd | mason.nvim | `additions/mason.lua` |
| clang-format | clang-format | mason.nvim | `additions/mason.lua` |
| codelldb | codelldb (DAP name) | mason-nvim-dap | `plugins/additions.lua` |
| pyright | pyright | mason.nvim | `additions/mason.lua` |
| black | black | mason.nvim | `additions/mason.lua` |
| bash-language-server | bash-language-server | mason.nvim | `additions/mason.lua` |
| shfmt | shfmt | mason.nvim | `additions/mason.lua` |
| typescript-language-server | typescript-language-server | mason.nvim | `additions/mason.lua` |
| prettier | prettier | mason.nvim | `additions/mason.lua` |
| stylua | stylua | mason.nvim | `additions/mason.lua` |
| jdtls | — | nvim-java | `plugins/lang/java.lua` |

---

## lazy-lock.json

`lazy-lock.json` records the exact pinned commit of every installed plugin.
- **Commit it** to lock a known-good state.
- **Run `:Lazy update`** to pull new versions, then commit the updated lockfile.
- **Do not edit it manually.**

---

## NvChad Update Safety

This configuration is structured so that `git pull` on the NvChad remote
(i.e., the starter template origin) affects only the base wiring files.
Because those files contain no custom logic, merging upstream NvChad changes
should never conflict with additions. The only exception is `lua/chadrc.lua`,
which should be reviewed manually after any upstream update.
