# Treesitter manager

[tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim)
installs and manages Tree-sitter parsers, which give accurate syntax
highlighting and indentation. (It replaces the archived `nvim-treesitter`.)

Config: `init.lua`.

Parsers installed up front: bash, c, diff, html, lua, luadoc, markdown,
markdown_inline, query, vim, vimdoc, sql, jinja, python, json, go. With
`auto_install = true`, opening a new filetype installs its parser. Ruby is
excluded from treesitter highlighting.

No keybindings; it's driven by commands.

## Commands

```vim
:TSManager                 " UI listing all parsers; install/remove from it
:TSInstall python go
:TSInstallSync rust        " wait until finished
:TSUninstall python
:TSUpdate                  " update all parsers
:TSUpdateSync
```

## Handy built-ins

```vim
:InspectTree               " live syntax tree of the buffer
:Inspect                   " highlight groups under the cursor
:checkhealth vim.treesitter
```

If highlighting looks wrong after a plugin update, run `:TSUpdate`.
