-- Configuration for nvim-tree

-- Gets the module with the utilities
local utils = require("utils")

-- Keymap to open nvim-tree
vim.keymap.set("n", "<Leader>pw", vim.cmd.NvimTreeToggle, { silent = true, desc = "Toggle nvim-tree" })

-- Function to set up nvim-tree
local function nvim_tree_setup()

    -- Stops executing if the package isn't installed
    if not utils.status_ok("nvim-tree") then return end

    -- Set up nvim-tree
    require("nvim-tree").setup({

        renderer = {
            indent_markers = {
                enable = true
            }
        },

        update_focused_file = {
            enable = true,
        },

        diagnostics = {
            enable = false,
            icons = require("shared_configs").lsp_diagnostic_icons("warning")
        },
    })

end


-- Returns the nvim-tree module for lazy.nvim
return {
    "nvim-tree/nvim-tree.lua",
    cond = utils.firenvim_not_active,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = nvim_tree_setup
}

