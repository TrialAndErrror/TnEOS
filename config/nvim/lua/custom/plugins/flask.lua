-- Flask / Jinja2 development support
return {
	-- Extend treesitter with Python and Jinja2 parsers + filetype detection
	{
		"romus204/tree-sitter-manager.nvim",
		-- python and jinja parsers are in the base ensure_installed list in init.lua
		init = function()
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				group = vim.api.nvim_create_augroup("flask-filetypes", { clear = true }),
				callback = function(ev)
					local path = ev.file
					-- .jinja2, .j2, .jinja extensions → htmldjango (Jinja2 syntax)
					if path:match("%.jinja2$") or path:match("%.j2$") or path:match("%.jinja$") then
						vim.bo[ev.buf].filetype = "htmldjango"
						return
					end
					-- .html files inside a templates/ directory
					if path:match("[/\\]templates[/\\].*%.html$") then
						vim.bo[ev.buf].filetype = "htmldjango"
					end
				end,
			})
		end,
	},

	-- Install pyright + djlint via mason
	-- mason-lspconfig's default handler automatically sets up pyright with blink.cmp capabilities
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "pyright", "djlint" })
		end,
	},

	-- djlint formatter for Jinja2/HTML template files
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.htmldjango = { "djlint" }
			opts.formatters_by_ft.jinja = { "djlint" }
			opts.formatters_by_ft.jinja2 = { "djlint" }
		end,
	},
}
