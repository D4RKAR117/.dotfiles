local options = {
	formatters_by_ft = {
		lua = { 'stylua' },
		css = { 'prettier' },
		html = { 'prettier' },
		javascript = { 'eslint', 'prettier', stop_after_first = true },
		typescript = { 'eslint', 'prettier', stop_after_first = true },
		vue = { 'eslint', 'prettier', stop_after_first = true },
		json = { 'prettier', stop_after_first = true },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 2500,
		lsp_fallback = true,
	},
}

return options
