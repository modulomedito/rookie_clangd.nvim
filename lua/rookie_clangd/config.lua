local default_config = {
    preset = {
        {
            name = "",
            project_dir = {},
            define = {},
            include = {},
            extra_flags = {},
        },
    },
    project_dir_pattern = { ".git", ".gitignore", "Cargo.toml", "package.json", "go.mod" },
    compiler_name = "gcc",
    hooks = {
        before_callback = function() end,
        after_callback = function() end,
    },
}

vim.g.rookie_clangd_config = default_config

local M = {}

M.setup = function(user_config)
    local previous_config = vim.g.rookie_clangd_config or default_config
    vim.g.rookie_clangd_config = vim.tbl_deep_extend("force", previous_config, user_config or {}) or default_config
end

return M
