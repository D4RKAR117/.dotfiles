-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = 'onedark',
	transparency = true,
	integrations = {
		'cmp',
		'mason',
		'treesitter',
		'git',
		'dap',
		'codeactionmenu',
		'notify',
		'nvcheatsheet',
		'semantic_tokens',
		'nvimtree',
		'nvdash',
		'devicons',
		'nvcheatsheet',
		'bufferline',
		'navic',
		'lsp',
	},
	hl_override = {
		Comment = { italic = true, bold = true },
		['@comment'] = { italic = true, bold = true },
		['@variable'] = { fg = '#e5c07b' },
		['@tag'] = { fg = '#e06c75' },
		['@tag.delimiter'] = { fg = '#abb2bf' },
		['@tag.attribute'] = { fg = '#d19a66' },
		['Type'] = { fg = '#d19a66' },
		['@attribute'] = { fg = '#56b6c2' },
	},
}

M.ui = {
	statusline = {
		theme = 'vscode_colored',
		separator_style = 'block',
	},
}

M.nvdash = {
	load_on_startup = true,
}

return M
