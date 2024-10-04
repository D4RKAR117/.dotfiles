local options = {
	formatters_by_ft = {
		lua = { 'stylua' },
		css = { 'prettierd', 'prettier' },
		html = { 'prettierd', 'prettier' },
		javascript = { 'eslint_d', 'prettierd', 'prettier', stop_after_first = true },
		typescript = { 'eslint_d', 'prettierd', 'prettier', stop_after_first = true },
		vue = { 'eslint_d', 'prettierd', 'prettier', stop_after_first = true },
		json = { 'prettierd', 'prettier', stop_after_first = true },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return options
