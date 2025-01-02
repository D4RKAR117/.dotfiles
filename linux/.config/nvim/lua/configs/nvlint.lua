return {
	---@type table<string, string[]>
	linters_by_ft = {
		json = { 'jsonlint', 'eslint', 'cspell' },
		vue = { 'eslint', 'cspell' },
		lua = { 'luac', 'cspell' },
		rust = { 'clippy', 'cspell' },
		javascript = { 'eslint', 'cspell' },
		typescript = { 'eslint', 'cspell' },
		typescriptreact = { 'eslint', 'cspell' },
		javascriptreact = { 'eslint', 'cspell' },
		bash = { 'shellcheck', 'cspell' },
		zsh = { 'zsh', 'cspell' },
		css = { 'stylelint', 'cspell' },
		scss = { 'stylelint', 'cspell' },
		markdown = { 'markdownlint', 'cspell' },
		yaml = { 'yamllint', 'cspell' },
		dotenv = { 'dotenv_linter', 'cspell' },
	},

	linters = {},
}
