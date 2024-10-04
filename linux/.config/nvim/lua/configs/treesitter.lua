local config = {
	ensure_installed = {
		'vim',
		'lua',
		'vimdoc',
		'html',
		'css',
		'tsx',
		'toml',
		'json',
		'css',
		'scss',
		'html',
		'yaml',
		'rust',
		'toml',
		'json',
		'javascript',
		'typescript',
		'vue',
		'bash',
		'regex',
		'diff',
	},
	refactor = {
		highlight_definitions = {
			enable = true,
			clear_on_cursor_move = true,
		},
	},
}

local config_callback = function(_, opts)
	opts.refactor = {
		highlight_definitions = {
			enable = true,
		},
		highlight_current_scope = { enable = true },
		smart_rename = {
			enable = true,
			-- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
			keymaps = {
				smart_rename = '<F2>',
			},
		},
	}
	require('nvim-treesitter.configs').setup(opts)
end

return {
	opts = config,
	config = config_callback,
}
