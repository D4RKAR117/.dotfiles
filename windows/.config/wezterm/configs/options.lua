local wezterm = require 'wezterm'

local gpus = wezterm.gui.enumerate_gpus()

local preffered_backend = 'Vulkan'
local preffered_device_type = 'DiscreteGpu'

local function get_gpu()
    for _, gpu in ipairs(gpus) do
        if gpu.backend == preffered_backend and gpu.device_type == preffered_device_type then
            return gpu
        end
    end
end

local function apply(config)
    config.default_domain = "WSL:Ubuntu"
    config.webgpu_preferred_adapter = get_gpu()
    config.front_end = "WebGpu"
end

return {
    apply = apply,
}
