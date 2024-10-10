-- load defaults i.e lua_lsp
require('nvchad.configs.lspconfig').defaults()

local lspconfig = require 'lspconfig'
local nvconfigs = require 'nvchad.configs.lspconfig'

local mason_registry = require 'mason-registry'
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path()
	.. '/node_modules/@vue/language-server'

local css_capabilities = vim.lsp.protocol.make_client_capabilities()
css_capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
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
	yamlls = {},
	taplo = {},
}

-- lsps with default config
for name, opts in pairs(servers) do
	opts.on_init = nvconfigs.on_init
	opts.on_attach = function(client, bufnr)
		nvconfigs.on_attach(client, bufnr)

		if client.name == 'eslint' then
			client.server_capabilities.documentFormattingProvider = true
		elseif client.name == 'tsserver' or client.name == 'ts_ls' then
			client.server_capabilities.documentFormattingProvider = false
		end

		vim.keymap.set({ 'n', 'v' }, '<leader>ca', function()
			require('tiny-code-action').code_action()
		end, { desc = 'LSP Code action advanced', buffer = bufnr })

		--#region Mappings that must execute on lsp attaching
		--#endregion
	end

	opts.capabilities = nvconfigs.capabilities

	lspconfig[name].setup(opts)
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
