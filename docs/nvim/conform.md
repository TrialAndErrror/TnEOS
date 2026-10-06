# Conform

[conform.nvim](https://github.com/stevearc/conform.nvim) formats code with
external formatters, falling back to the LSP.

Config: `init.lua` and `custom/plugins/flask.lua`.

## Behavior

- **Format on save**: on `:w` (500ms timeout), except C and C++.
- Formatters by filetype: Lua is `stylua`; `htmldjango`, `jinja`, `jinja2` use
  `djlint`. Everything else falls back to the LSP formatter.

## Keys

| Key | Does |
| --- | --- |
| `Space f` (then pause) | Format buffer with conform (normal / visual) |
| `Space c f` | Format buffer with `vim.lsp.buf.format` (does not use conform) |

Careful with `Space f`: it is also the File menu prefix, so type `Space f f`
etc. without pausing to avoid formatting.

## Ex commands

```vim
:ConformInfo               " which formatters apply and whether they are installed
:lua require('conform').format()
:noautocmd w               " save without format-on-save
```

To disable format-on-save, edit `format_on_save` in `init.lua`. To add a
formatter, add it to `formatters_by_ft` and install it with Mason
(`:MasonInstall prettier`).
