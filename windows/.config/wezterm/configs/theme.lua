local wezterm = require 'wezterm'

local function apply(config)
    config.color_scheme = "OneDark"
    config.font = wezterm.font("FiraCode Nerd Font")
    config.font_size = 12.0
    config.window_background_opacity = 0.5
    config.text_background_opacity = 0.5
    config.win32_system_backdrop = 'Acrylic'
end

return {
    apply = apply,
}
