local wezterm = require 'wezterm'

local function apply(config)
    config.wsl_domains = {
        {
            name = "WSL:Ubuntu",
            distribution = "Ubuntu",
        }
    }
end

return {
    apply = apply,
}
