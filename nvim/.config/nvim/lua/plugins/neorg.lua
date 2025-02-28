-- Define a function to commit changes in the hardcoded Git project path
function git_commit_and_push()
    local git_project_path = "~/neorg/notes"

    -- Stage all changes
    local add_result = vim.fn.system("git -C " .. git_project_path .. " add .")
    if vim.v.shell_error ~= 0 then
        print("Error staging changes: " .. add_result)
        return
    end

    -- Commit changes
    local commit_message = "Auto-commit: Changes detected"
    local commit_result = vim.fn.system("git -C " .. git_project_path .. " commit -m '" .. commit_message .. "'")
    if vim.v.shell_error ~= 0 then
        print("Error committing changes: " .. commit_result)
        return
    end

    -- Push changes to the remote repository
    local push_result = vim.fn.system("git -C " .. git_project_path .. " push origin main") -- Change "main" to your branch name
    if vim.v.shell_error ~= 0 then
        print("Error pushing changes: " .. push_result)
        return
    end

    print("Changes committed and pushed successfully: " .. commit_message)
end

return {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    keys = {
        {
            "<leader>nn",
            ":Neorg<CR>",
            desc = "Open Neorg",
        },
        {
            "<leader>ni",
            ":Neorg index<CR>",
            desc = "Neorg index",
        },
        {
            "<leader>nr",
            ":Neorg return<CR>",
            desc = "Return back from Neorg",
        },
        {
            "<leader>nc",
            "<cmd>lua git_commit_and_push()<CR>",
            desc = "Commit changes",
        },
    },
    config = function()
        require("neorg").setup({
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/neorg/notes",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        })

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
    end,
}
