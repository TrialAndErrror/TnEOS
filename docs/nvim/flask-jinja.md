# Flask / Jinja2 support

Not a single plugin: `custom/plugins/flask.lua` extends other plugins for Python
and Jinja2 template work.

## What it sets up

- **Filetype detection**: `.jinja`, `.jinja2`, `.j2`, and any `.html` under a
  `templates/` directory open as `htmldjango` (Jinja syntax highlighting).
- **Language servers/tools** (installed by Mason): `pyright` (Python LSP) and
  `djlint` (template formatter/linter).
- **Formatting**: `htmldjango`, `jinja`, `jinja2` format with `djlint` via
  [Conform](conform.md), including on save.
- **Parsers**: `python` and `jinja` are in the Treesitter list.

## Usage

All the normal LSP keys apply in Python files: `Space l d`, `Space l r`,
`Space l h`, `Space c r`, `Space c f` ([lsp.md](lsp.md)).

Check things are working:

```vim
:set filetype?        " should say htmldjango in a template
:LspInfo              " pyright attached to .py files
:ConformInfo          " djlint listed for templates
:Mason                " pyright and djlint installed
```

If pyright can't find your packages, start nvim from the project root with the
virtualenv activated.
