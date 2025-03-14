-- Check neovim version
if vim.fn.has("nvim-0.10.0") == 0 then
    vim.api.nvim_err_writeln("rookie_clangd.nvim requires at least nvim-0.10")
    return
end

-- Make sure this file is loaded only once
if vim.g.rookie_clangd_is_loaded == 1 then
    return
end
vim.g.rookie_clangd_is_loaded = 1

-- Setup
require("rookie_clangd").setup()

-- User commands
local api = require("rookie_clangd.api")
vim.api.nvim_create_user_command("RookieClangdGenerateCompileCommands", function()
    api.generate_compile_commands()
end, {})
vim.api.nvim_create_user_command("RookieClangdAddDefineSymbol", function()
    api.add_define_symbol()
    api.generate_compile_commands()
end, {})
vim.api.nvim_create_user_command("RookieClangdRemoveDefineSymbol", function()
    api.remove_define_symbol()
    api.generate_compile_commands()
end, {})
vim.api.nvim_create_user_command("RookieClangdChoosePreset", function()
    api.choose_preset()
    api.generate_compile_commands()
end, {})
