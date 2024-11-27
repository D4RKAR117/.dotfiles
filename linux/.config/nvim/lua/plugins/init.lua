---@type LazyPluginSpec[]
return {
	{
		'stevearc/conform.nvim',
		event = 'BufWritePre', -- uncomment for format on save
		opts = require 'configs.conform',
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		'neovim/nvim-lspconfig',
		config = function()
			require 'configs.lspconfig'
		end,
	},

	{
		'nvim-treesitter/nvim-treesitter',
		opts = require('configs.treesitter').opts,
		config = require('configs.treesitter').config,
	},
	{
		'mfussenegger/nvim-lint',
		config = function(_, _)
			local configs = require 'configs.nvlint'
			require('lint').linters_by_ft =
				vim.tbl_deep_extend('force', require('lint').linters_by_ft, configs.linters_by_ft)
			for linter, config in ipairs(configs.linters) do
				require('lint')[linter] = vim.tbl_extend('force', require('lint')[linter]['args'], config.args)
			end
			-- require('lint').linters = vim.tbl_deep_extend('force', require('lint').linters, configs.linters)
		end,
	},
	{
		'L3MON4D3/LuaSnip',
		build = 'make install_jsregexp',
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
		},
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = false, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
				},
			},
		},
		config = function()
			-- Telescope extensions
			require('telescope').load_extension 'noice'
			require('telescope').load_extension 'fzf'
		end,
	},
	{
		'Bekaboo/dropbar.nvim',
		event = { 'OptionSet', 'BufWinEnter', 'BufWritePost' },
		-- optional, but required for fuzzy finder support
		dependencies = {
			'nvim-telescope/telescope-fzf-native.nvim',
		},
	},
	{
		'rachartier/tiny-code-action.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
		},
		opts = {
			telescope_opts = {
				layout_strategy = 'vertical',
				layout_config = {
					width = 0.7,
					height = 0.9,
					preview_cutoff = 1,
					preview_height = function(_, _, max_lines)
						local h = math.floor(max_lines * 0.5)
						return math.max(h, 10)
					end,
				},
			},
		},
		config = function(_, opts)
			require('tiny-code-action').setup(opts)
		end,
	},

	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		opts = {
			lsp = {
				signature = {
					enabled = false,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			routes = {
				{
					view = 'popup',
					filter = { event = 'msg_show', kind = '', find = 'Authenticate Type' },
				},
			},
		},
		dependencies = {
			'MunifTanjim/nui.nvim',
			{ 'rcarriga/nvim-notify', opts = {
				background_colour = '#282c34',
			} },
		},
	},
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		event = 'VeryLazy',
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
	},
	{
		'zbirenbaum/copilot-cmp',
		event = 'LspAttach',
		dependencies = { 'copilot.lua', 'hrsh7th/nvim-cmp' },
		opts = {},
		config = function(_, opts)
			require('copilot_cmp').setup(opts)
		end,
	},

	{
		'hrsh7th/nvim-cmp',
		opts = function(_, opts)
			table.insert(opts.sources, 1, {
				name = 'copilot',
				group_index = 2,
				priority = 100,
			})

			table.insert(opts.sources, {
				name = 'crates',
				group_index = 2,
				priority = 100,
			})
			return opts
		end,
		config = function(_, opts)
			local cmp = require 'cmp'

			opts.sorting = {
				priority_weight = 2,
				comparators = {
					require('copilot_cmp.comparators').prioritize,

					-- Below is the default comparitor list and order for nvim-cmp
					cmp.config.compare.offset,
					-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			}

			cmp.setup(opts)
		end,
	},
	{ 'nvchad/menu', lazy = true },
	{
		'CopilotC-Nvim/CopilotChat.nvim',
		branch = 'canary',
		cmd = { 'CopilotChat', 'CopilotChatOpen' },
		lazy = true,
		keys = {
			{
				'<leader>cch',
				function()
					local actions = require 'CopilotChat.actions'
					require('CopilotChat.integrations.telescope').pick(actions.help_actions())
				end,
				mode = { 'n', 'v' },
				desc = 'Copilot Chat - Help Actions',
			},
			{
				'<leader>ccp',
				function()
					local actions = require 'CopilotChat.actions'
					require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
				end,
				mode = { 'n', 'v' },
				desc = 'Copilot Chat - Prompt Actions',
			},
			{
				'<leader>ccq',
				function()
					local input = vim.fn.input 'Quick Chat: '
					if input ~= '' then
						require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
					end
				end,
				mode = { 'n', 'v' },
				desc = 'Copilot Chat - Quick Chat',
			},
		},
		dependencies = {
			{ 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
			{ 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
		},
		build = 'make tiktoken', -- Only on MacOS or Linux
		opts = {
			debug = false, -- Enable debuggin mode
			chat_autocomplete = true,
			mappings = {
				complete = {
					insert = '',
				},
			},
		},
	},
	{
		'saecki/crates.nvim',
		dependencies = { 'hrsh7th/nvim-cmp' },
		event = { 'BufRead Cargo.toml' },
		opts = {
			completion = {
				cmp = {
					enabled = true,
				},
			},
		},
	},
	{
		'folke/trouble.nvim',
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = 'Trouble',
		keys = {
			{
				'<leader>xx',
				'<cmd>Trouble diagnostics toggle<cr>',
				desc = 'LSP Diagnostics (Trouble)',
			},
			{
				'<leader>xX',
				'<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
				desc = 'LSP Buffer Diagnostics (Trouble)',
			},
			{
				'<leader>cs',
				'<cmd>Trouble symbols toggle focus=false<cr>',
				desc = 'LSP Symbols (Trouble)',
			},
			{
				'<leader>cl',
				'<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
				desc = 'LSP Definitions / references / ... (Trouble)',
			},
			{
				'<leader>xL',
				'<cmd>Trouble loclist toggle<cr>',
				desc = 'LSP Location List (Trouble)',
			},
			{
				'<leader>xQ',
				'<cmd>Trouble qflist toggle<cr>',
				desc = 'LSP Quickfix List (Trouble)',
			},
		},
	},
	{
		'kylechui/nvim-surround',
		version = '*', -- Use for stability; omit to use `main` branch for the latest features
		event = 'VeryLazy',
		opts = {},
	},
	{
		'f-person/git-blame.nvim',
		event = 'VeryLazy',
	},
	{
		'kdheepak/lazygit.nvim',
		lazy = true,
		cmd = {
			'LazyGit',
			'LazyGitConfig',
			'LazyGitCurrentFile',
			'LazyGitFilter',
			'LazyGitFilterCurrentFile',
		},
		-- optional for floating window border decoration
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit toggle' },
		},
	},
	{
		'amitds1997/remote-nvim.nvim',
		event = 'VeryLazy',
		version = '*', -- Pin to GitHub releases
		dependencies = {
			'nvim-lua/plenary.nvim', -- For standard functions
			'MunifTanjim/nui.nvim', -- To build the plugin UI
			'nvim-telescope/telescope.nvim', -- For picking b/w different remote methods
			'Bekaboo/dropbar.nvim',
		},
		config = true,
	},
}
