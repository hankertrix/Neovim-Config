-- Completion engine configuration

-- Gets the module with the utilities
local utils = require("utils")

-- Function to set up nvim-cmp
local function cmp_setup()

    -- Stops executing if the package isn"t installed
    if not utils.status_ok("cmp") then return end

    -- Gets the nvim-cmp module
    local cmp = require("cmp")

    -- Gets the default sources
    local default_sources = require("shared_configs").default_cmp_sources

    -- The options for selection
    local select_opts = { behavior = "select" }


    -- The default mappings for nvim-cmp
    local cmp_mappings = {

        -- Confirm selection
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-y>"] = cmp.mapping.confirm({ select = false }),

        -- Navigate items on the list
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

        -- Scroll up and down in the completion documentation
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
        ["<C-b>"] = cmp.mapping.scroll_docs(-5),

        -- Toggle completion
        ["<C-e>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.abort()
            else
                cmp.complete()
            end
        end),

        -- Vim"s default to open the completion window
        ["<C-Space>"] = cmp.mapping.complete(),
    }


    -- The formatting for nvim-cmp
    local cmp_format = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)

            -- The menu name for the source of the completion
            local menu_name = require("shared_configs").source_names[entry.source.name] or utils.titlecase(entry.source.name)

            -- Sets the menu to the menu name enclosed in square brackets
            item.menu = string.format("[%s]", menu_name)

            -- Returns the item
            return item

        end
    }


    -- Sets up nvim-cmp with my own mappings
    cmp.setup({
        mapping = cmp_mappings,
        sources = default_sources,
        formatting = cmp_format
    })


    -- Command line mappings
    local cmp_cmdline_mappings = cmp.mapping.preset.cmdline({

        -- Confirms the selection
        ["<Tab>"] = { c = cmp.mapping.confirm({ select = true }) },
        ["<C-y>"] = { c = cmp.mapping.confirm({ select = false }) },

        -- Alternative button to select the next item in the completion window
        ["<C-f>"] =  {
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
        },

        -- Alternative button to select the previous item in the completion window
        ["<C-u>"] = {
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end,
        },

        -- Alternative button to select the previous item in the completion window
        ["<C-b>"] = {
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end,
        },
    })


    -- Sets up the slash search completion
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp_cmdline_mappings,
        sources = cmp.config.sources({
            { name = "nvim_lsp_document_symbol" },
            { name = "buffer" },
            { name = "cmdline_history" }
        })
    })


    -- Sets up the command line completion
    cmp.setup.cmdline(":", {
        mapping = cmp_cmdline_mappings,
        sources = cmp.config.sources({
            { name = "path" },
            {
                name = "cmdline",
                option = {
                    ignore_cmds = { "Man", "!" }
                }
            },
            { name = "cmdline_history" }
        })
    })


    -- Set up the completion sources for text and markdown files
    cmp.setup.filetype({ "text", "markdown" }, {
        sources = default_sources
    })

end

-- Returns the nvim-cmp module for lazy.nvim
return {
    "hrsh7th/nvim-cmp",
    config = cmp_setup,
    event = "InsertEnter",
    dependencies = {

        -- Regular completion within a buffer
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "ray-x/cmp-treesitter" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-calc" },
        { "f3fora/cmp-spell" },
        { "hrsh7th/cmp-emoji" },
        { "tzachar/cmp-tabnine", build = "powershell ./install.ps1" },

        -- Completion within the command line
        { "hrsh7th/cmp-cmdline" },
        { "dmitmel/cmp-cmdline-history" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
    }
}

