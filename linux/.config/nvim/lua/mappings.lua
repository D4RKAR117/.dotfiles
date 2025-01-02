require 'nvchad.mappings'

-- add yours here

local map = vim.keymap.set

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')

-- Code Line move
map('v', '<A-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move line selection down' })
map('v', '<A-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move line selection up' })
map('n', '<A-Down>', ':m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-Up>', ':m .-2<CR>==', { desc = 'Move line up' })
map('i', '<A-Down>', ':m .+1<CR>==gi', { desc = 'Move line down' })
map('i', '<A-Up>', ':m .-2<CR>==gi', { desc = 'Move line up' })

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
map('n', '<C-t>', function()
	require('menu').open 'default'
end, {})

-- mouse users + nvimtree users!
map('n', '<RightMouse>', function()
	vim.cmd.exec '"normal! \\<RightMouse>"'

	local options = vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default'
	require('menu').open(options, { mouse = true })
end, {})
