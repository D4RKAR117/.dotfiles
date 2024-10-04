return {
	---@type table<string, string[]>
	linters_by_ft = {
		json = { 'jsonlint', 'eslint_d', 'cspell' },
		vue = { 'eslint_d', 'cspell' },
		lua = { 'luac', 'cspell' },
		rust = { 'clippy', 'cspell' },
		javascript = { 'eslint_d', 'cspell' },
		typescript = { 'eslint_d', 'cspell' },
		typescriptreact = { 'eslint_d', 'cspell' },
		javascriptreact = { 'eslint_d', 'cspell' },
		bash = { 'shellcheck', 'cspell' },
		zsh = { 'shellcheck', 'zsh', 'cspell' },
		css = { 'stylelint', 'cspell' },
		scss = { 'stylelint', 'cspell' },
		markdown = { 'markdownlint', 'cspell' },
		yaml = { 'yamllint', 'cspell' },
		dotenv = { 'dotenv_linter', 'cspell' },
	},

	linters = {},
}
