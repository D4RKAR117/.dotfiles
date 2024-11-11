local lspconfig = require 'lspconfig'
local nvlsp = require 'nvchad.configs.lspconfig'

dofile(vim.g.base46_cache .. 'lsp')
require('nvchad.lsp').diagnostic_config()

local mason_registry = require 'mason-registry'
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path()
	.. '/node_modules/@vue/language-server'

local css_capabilities = vim.lsp.protocol.make_client_capabilities()
css_capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { 'vim' },
				},
				workspace = {
					library = {
						vim.fn.expand '$VIMRUNTIME/lua',
						vim.fn.expand '$VIMRUNTIME/lua/vim/lsp',
						vim.fn.stdpath 'data' .. '/lazy/ui/nvchad_types',
						vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
						'${3rd}/luv/library',
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	},
	html = {
		filetypes = { 'html', 'vue', 'javascriptreact', 'typescriptreact' },
	},
	cssls = {
		capabilities = css_capabilities,
		filetypes = { 'css', 'scss', 'less', 'postcss', 'html', 'vue', 'javascriptreact', 'typescriptreact' },
	},
	css_variables = {
		filetypes = { 'css', 'scss', 'less', 'postcss', 'html', 'vue', 'javascriptreact', 'typescriptreact' },
	},
	cssmodules_ls = {
		filetypes = { 'css', 'scss', 'less', 'postcss', 'html', 'vue', 'javascriptreact', 'typescriptreact' },
	},
	bashls = {},
	volar = {
		filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
	},
	tailwindcss = {},
	ts_ls = {
		init_options = {
			plugins = {
				{
					name = '@vue/typescript-plugin',
					location = vue_language_server_path,
					languages = { 'javascript', 'typescript', 'vue' },
				},
			},
		},
		filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
	},

	rust_analyzer = {
		filetypes = { 'rust' },
		root_dir = lspconfig.util.root_pattern 'Cargo.toml',
		settings = {
			['rust-analyzer'] = {
				cargo = { allFeatures = true },
			},
		},
	},
	jsonls = {},
	emmet_language_server = {
		filetypes = {
			'astro',
			'css',
			'eruby',
			'html',
			'htmldjango',
			'javascriptreact',
			'less',
			'pug',
			'sass',
			'scss',
			'svelte',
			'typescriptreact',
			'vue',
			'htmlangular',
		},
	},
	yamlls = {
		settings = {
			yaml = {
				schemas = {
					['https://raw.githubusercontent.com/jesseduffield/lazygit/master/schema/config.json'] = {
						'.lazygit.yml',
						'/.git/lazygit.yml',
					},
					['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
				},
			},
		},
	},
	taplo = {},
}

-- lsps with default config

local attach = function(client, bufnr)
	nvlsp.on_attach(client, bufnr)
	vim.keymap.set({ 'n', 'v' }, '<leader>ca', function()
		require('tiny-code-action').code_action()
	end, { desc = 'LSP Code action (Tiny)', buffer = bufnr, silent = true })

	if client.name == 'eslint' then
		client.server_capabilities.documentFormattingProvider = true
	elseif client.name == 'tsserver' or client.name == 'ts_ls' then
		client.server_capabilities.documentFormattingProvider = false
	end
end

for name, opts in pairs(servers) do
	opts.on_init = nvlsp.on_init
	opts.on_attach = attach
	opts.capabilities = nvlsp.capabilities

	lspconfig[name].setup(opts)
end
