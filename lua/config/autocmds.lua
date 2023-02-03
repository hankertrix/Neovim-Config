-- Auto commands to run

-- Highlight yanked region
vim.cmd([[
    augroup highlight_yank
        autocmd!
            au TextYankPost * silent! lua vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
    augroup END
]])

-- The function to open nvim-tree on start up
-- if a [No Name] buffer or directory is opened
local function open_nvim_tree(data)

    -- Gets the utilities modules
    local utils = require("utils")

    -- If Neovim is started by firenvim, then immediately exit the function
    if not utils.firenvim_not_active() then return end

    -- Buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- Buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    -- If the buffer isn't a directory or a [No Name] then exit the function
    if not no_name and not directory then return end

    -- Change to the directory if a directory is passed
    if directory then vim.cmd.cd(data.file) end

    -- Opens nvim-tree only if the package is installed
    if utils.status_ok("nvim-tree") then
        require("nvim-tree.api").tree.open()
    end

end

-- Open nvim-tree on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


--[[ -- Function to check Neovim is inside a Git repositary
local function check_git_repo()
  local cmd = "git rev-parse --is-inside-work-tree"
  if vim.fn.system(cmd) == "true\n" then
    vim.api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
    return true  -- removes autocmd after lazy loading git related plugins
  end
end

-- Creates an auto command to check whether we are in a Git repositary when Neovim is entered or when the directory is changed
vim.api.nvim_create_autocmd(
  { "VimEnter", "DirChanged" },
  { callback = function() vim.schedule(check_git_repo) end }
) ]]

