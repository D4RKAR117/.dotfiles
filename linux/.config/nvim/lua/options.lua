require 'nvchad.options'

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
local g = vim.g
local api = vim.api

g.clipboard = {
	name = 'WslClipboard',
	copy = {
		['+'] = 'clip.exe',
		['*'] = 'clip.exe',
	},
	paste = {
		['+'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		['*'] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	},
	cache_enabled = 0,
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
	group = lint_augroup,
	callback = function()
		local lint = require 'lint'
		lint.linters.cspell = require('lint.util').wrap(lint.linters.cspell, function(diagnostic)
			diagnostic.severity = vim.diagnostic.severity.HINT
			return diagnostic
		end)

		if vim.bo.buftype ~= 'terminal' and vim.bo.buftype ~= 'prompt' then
			-- try_lint without arguments runs the linters defined in `linters_by_ft`
			-- for the current filetype
			lint.try_lint()

			-- You can call `try_lint` with a linter name or a list of names to always
			-- run specific linters, independent of the `linters_by_ft` configuration
		end
	end,
})

vim.opt.updatetime = 200

vim.ui.select = require('dropbar.utils.menu').select

-- Telescope plugins
require('telescope').load_extension 'noice'

-- Copilot chat integracions
api.nvim_create_autocmd({ 'LspAttach' }, {
	callback = function()
		require('CopilotChat.integrations.cmp').setup()
	end,
})
