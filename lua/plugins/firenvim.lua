-- Configuration for firenvim

local local_settings = {
    [".*"] = {
        cmdline = "neovim",

        -- Never automatically use firenvim
        takeover = "never"
    }
}

vim.g.firenvim_config = {
    localSettings = local_settings
}

-- Returns the firenvim module for lazy.nvim
return {
    "glacambre/firenvim",
    build = function() vim.fn["firenvim#install"](0) end,
    cond = not require("utils").firenvim_not_active()
}

