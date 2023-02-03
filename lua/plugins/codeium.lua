-- Configuration for codeium, an AI code completion tool

-- Gets the module with the utilities
local utils = require("utils")

-- Function to set up codeium
local function codeium_setup()

    -- Use Ctrl + g to the accept the completion
    vim.keymap.set("i", "<C-g>", function () return vim.fn["codeium#Accept"]() end, { expr = true, desc = "Accepts the AI's autocompletion" })

end


-- Returns the codeium module for lazy.nvim
return {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    lazy = true,
    enabled = false,
    cond = utils.firenvim_not_active,
    config = codeium_setup
}

