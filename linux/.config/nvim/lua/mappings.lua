require 'nvchad.mappings'

-- add yours here

local map = vim.keymap.set

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')

-- Code Line move
map('n', '<A-Up>', ':m .-2<CR>==', { desc = 'Move line up' }) -- move line up(n)
map('n', '<A-Down>', ':m .+1<CR>==', { desc = 'Move line down' }) -- move line down(n)
map('v', '<A-Up>', ":m '>-2<CR>gv=gv", { desc = 'Move line selection up' }) -- move line up(v)
map('v', '<A-Down>', ":m '<+2<CR>gv=gv", { desc = 'Move line selection down' }) -- move line down(v)

-- Noice
map('c', '<S-Enter>', function()
	require('noice').redirect(vim.fn.getcmdline())
end, { desc = 'Redirect Cmdline' })

-- Copilot chat

map({ 'n', 'v' }, '<leader>cch', function()
	local actions = require 'CopilotChat.actions'
	require('CopilotChat.integrations.telescope').pick(actions.help_actions())
end, { desc = 'Copilot Chat - Help Actions' })

map({ 'n', 'v' }, '<leader>ccp', function()
	local actions = require 'CopilotChat.actions'
	require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
end, { desc = 'Copilot Chat - Prompt Actions' })

map({ 'n', 'v' }, '<leader>ccq', function()
	local input = vim.fn.input 'Quick Chat: '
	if input ~= '' then
		require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
	end
end, { desc = 'Copilot Chat - Quick Chat' })

-- Nvchad volt framework
--- Keyboard users
vim.keymap.set('n', '<C-t>', function()
	require('menu').open 'default'
end, {})

-- mouse users + nvimtree users!
vim.keymap.set('n', '<RightMouse>', function()
	vim.cmd.exec '"normal! \\<RightMouse>"'

	local options = vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default'
	require('menu').open(options, { mouse = true })
end, {})

-- -- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
