# mini.nvim

[mini.nvim](https://github.com/echasnovski/mini.nvim) is a collection of small
modules. Enabled here: **ai** (text objects), **surround**, **statusline**,
**animate** (smooth scrolling only). The colorscheme `miniautumn` is from the
same suite.

Config: `init.lua`; colorscheme in `custom/options.lua`.

## mini.ai: better text objects

Use after an operator (`d`, `c`, `y`, `v`). `a` = around (includes delimiters),
`i` = inside.

| Keys | Selects |
| --- | --- |
| `ci(` / `ci)` / `cib` | Inside parentheses |
| `ci[` / `ci{` / `ciB` | Inside brackets / braces |
| `ci"` / `ci'` / `` ci` `` / `ciq` | Inside any quote |
| `cit` | Inside an HTML/XML tag |
| `caf` / `cif` | Function call (around / inside) |
| `caa` / `cia` | Function argument |
| `ci?` | User prompt: asks for the left and right characters |
| `cin(` / `cil(` | **Next** / **last** parentheses (looks ahead / behind, up to 500 lines) |
| `ciw` | Normal vim word (still there) |

Examples: `daa` delete an argument with its comma; `vif` select a call's inside;
`yinq` yank the next quoted string.

## mini.surround

| Keys | Does |
| --- | --- |
| `saiw)` | **Add** `)` surround around inner word |
| `sa` + motion + char | Add surround (visual: `sa` + char) |
| `sd'` | **Delete** surrounding `'` |
| `sr)'` | **Replace** surrounding `)` with `'` |
| `sf` / `sF` | Find surround right / left |
| `sh` | Highlight surround |
| `sn` | Update `n_lines` |

Examples: `saiw"` wraps the word in quotes; `sr"'` changes `"x"` to `'x'`.
See `:help mini.surround` for more surround types (function calls, tags).

`s` is no longer the plain "substitute" key; use `cl` instead.

## mini.statusline

The bar at the bottom: mode, git branch, diff counts, diagnostics, filename,
filetype, and `line:column`. No keys.

## mini.animate

Scrolling (`Ctrl-d`, `Ctrl-u`, `zz`, ...) is animated over 150 ms. Cursor,
resize, open and close animations are disabled.

## Colorscheme

`miniautumn` is set in `custom/options.lua`. Try others with `Space s c`.
