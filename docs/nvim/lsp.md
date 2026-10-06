# LSP, Mason, Fidget, lazydev

The Language Server Protocol gives you go-to-definition, hover docs, rename,
diagnostics and code actions.

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): server configs.
- [mason.nvim](https://github.com/mason-org/mason.nvim) + `mason-lspconfig` +
  `mason-tool-installer`: install servers and tools from inside nvim.
- [fidget.nvim](https://github.com/j-hui/fidget.nvim): bottom-right progress
  notifications ("indexing...").
- [lazydev.nvim](https://github.com/folke/lazydev.nvim): makes `lua_ls` understand
  the nvim API when editing Lua.

Config: `init.lua` (kickstart LSP block), `custom/keybindings/{lsp,code}.lua`,
`custom/plugins/flask.lua`.

Servers and tools installed automatically: `lua_ls`, `stylua`, `pyright`,
`djlint`. Add more in the `servers` table in `init.lua`.

## Go to / look up

| Key | Does |
| --- | --- |
| `Space l d` or `grd` | Definition (`grd` uses Telescope) |
| `Space l D` or `grD` | Declaration |
| `Space l t` or `grt` | Type definition |
| `Space l r` or `grr` | References (`grr` uses Telescope) |
| `gri` | Implementations |
| `Space l h` or `K` | Hover documentation |
| `Space l s` | Signature help (also `Ctrl-s` in insert mode) |
| `gO` | Document symbols (Telescope) |
| `gW` | Workspace symbols (Telescope) |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward after navigating |

## Change code

| Key | Does |
| --- | --- |
| `Space c a` or `gra` | Code action (visual mode too) |
| `Space c q` | Quick fixes only |
| `Space c i` | Organize imports |
| `Space c r` or `grn` | Rename symbol |
| `Space c f` | Format buffer |

## Diagnostics

| Key | Does |
| --- | --- |
| `]d` / `[d` | Next / previous diagnostic |
| `Ctrl-w d` | Float with the diagnostic for this line |
| `Space s d` | Telescope diagnostics |
| `Space q` | Diagnostics to location list |
| `Space x x` / `Space x X` | Trouble list ([trouble.md](trouble.md)) |

Only errors are underlined; all severities show as inline virtual text. Signs use
Nerd Font icons.

## Other

| Key | Does |
| --- | --- |
| `Space t h` | Toggle inlay hints (when the server supports them) |
| `Space l i` | `:LspInfo` |
| `Space l R` | `:LspRestart` |

Cursor-hold highlights other uses of the symbol under the cursor.

## Mason

```vim
:Mason                   " UI: i install, X uninstall, u update, U update all, / filter, g? help
:MasonInstall pyright
:MasonUninstall pyright
:MasonUpdate
:MasonLog
:MasonToolsInstall       " install everything in ensure_installed
:MasonToolsUpdate
```

## Debug commands

```vim
:LspInfo                         " attached clients (or :checkhealth vim.lsp)
:LspRestart
:LspLog                          " log file
:checkhealth vim.lsp
:lua vim.print(vim.lsp.get_clients())
```
