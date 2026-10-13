# VOIDVIM

A personal Neovim setup built on **NvChad** and **lazy.nvim**.

This repository is my main Neovim configuration: the place where I keep my editor options, keymaps, plugins, language tooling, and ongoing experiments.

## Setup

The configuration bootstraps lazy.nvim, loads NvChad, then imports the plugins in this repository:

```text
init.lua
├── NvChad base
├── lua/plugins/
├── lua/plugins/lang/
├── options.lua
├── mappings.lua
└── autocmds.lua
```

The plugin setup includes language-specific tooling and workflows for the languages I use. The configuration is personal and may change as I refine my editor setup.

## Neovim inside VS Code

I also use **VS Code with the VSCode Neovim extension**. It runs the Neovim executable and provides Vim-style editing inside VS Code.

My VS Code integration has its own init file, `vscode-neovim.lua`. It defines VS Code-aware keymaps and editor actions, and loads a small set of Neovim behavior and plugins for that environment. This is a companion setup to VOIDVIM, rather than a full load of the NvChad configuration: VS Code manages its own interface, while Neovim supplies the modal editing engine.

## Notes

- **Main editor config:** this repository
- **Framework:** NvChad
- **Plugin manager:** lazy.nvim
- **VS Code editing:** VSCode Neovim extension with a separate VS Code-specific init file

