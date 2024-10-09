local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local theme = require 'configs.theme'
local wsl = require 'configs.wsl'
local options = require 'configs.options'

local module = {
    theme,
    wsl,
    options,
}

for index, value in ipairs(module) do
    wezterm.log_info('Loading module: ' .. index)
    value.apply(config)
end


return config
