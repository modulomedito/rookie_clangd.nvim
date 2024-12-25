local function is_in_table(tbl, element)
    for _, value in ipairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

local function get_element_index(tbl, element)
    for i, value in ipairs(tbl) do
        if value == element then
            return i
        end
    end
    return 0
end

local function get_file_full_path_recursive(dir, pattern)
    local files = {}
    -- Get all files in the current directory
    for _, file in ipairs(vim.fn.glob(dir .. "/" .. pattern, true, true)) do
        table.insert(files, file)
    end
    -- Get all subdirectories
    for _, subdir in ipairs(vim.fn.glob(dir .. "/*", true, true)) do
        if vim.fn.isdirectory(subdir) == 1 then
            -- Recursively get files from subdirectories
            for _, file in ipairs(get_file_full_path_recursive(subdir, pattern)) do
                table.insert(files, file)
            end
        end
    end
    return files
end

-- local rookie_clangd_default_config = {
--     preset = {
--         {
--             name = "ti c2000",
--             project_dirs = {
--                 "d:/user_chc/3_prj/3_gitlab/product/dht_punch/dht_punch_app/dht_punch",
--             },
--             search_excludes = { ".git", "build", ".cache", ".github", ".gitlab" },
--             search_extension = { "h" },
--             compiler = "gcc",
--             include = {
--                 "d:/user_chc/4_app/ccs/2_ws/ti/ccs1271/ccs/tools/compiler/ti-cgt-c2000_22.6.1.lts/include",
--             },
--             define = {},
--             extra_flags = {},
--             hooks = {
--                 before_gen = function() end,
--                 after_gen = function() end,
--             },
--         },
--     },
--     also_include_header_parents = true,
--     global_search_excludes = { ".git", "build", ".cache", ".github", ".gitlab" },
--     global_search_extension = { "h" },
--     global_hooks = {
--         before_gen = function() end,
--         after_gen = function() end,
--     },
-- }
--
-- vim.g.rookie_clangd_define_symbols = {}
-- local rookie_clangd_config = rookie_clangd_default_config
--
-- local function rookie_clangd_get_preset_index(presets, dir)
--     if presets == nil or dir == nil then
--         return 0
--     end
--     for i, preset in ipairs(presets) do
--         if preset.project_dirs == nil then
--             for _, value in ipairs(preset.project_dirs) do
--                 if value == dir then
--                     return i
--                 end
--             end
--         end
--     end
--     return 0
-- end
--
-- local function rookie_clangd_search_dir_preset(config, root_path, idx)
--     local excludes = {}
--     if config.preset[idx].search_excludes ~= {} then
--         excludes = config.preset[idx].search_excludes
--     else
--         excludes = config.global_search_excludes
--     end
--
--     local ext = {}
--     if config.preset[idx].search_extension ~= {} then
--         ext = config.preset[idx].search_extension
--     else
--         ext = config.global_search_extension
--     end
--
--     local directories = util_get_dirs_with_extension(root_path, excludes, ext)
--     return directories
-- end
--
-- local function rookie_clangd_search_dir_general(config, root_path)
--     local excludes = config.global_search_excludes
--     local ext = config.global_search_extension
--     local directories = util_get_dirs_with_extension(root_path, excludes, ext)
--     return directories
-- end
--
-- local function rookie_clangd_write_compile_commands()
--     -- Open the file for writing
--     local file = io.open("compile_commands.json", "w")
--     if not file then
--         print("rookie_clangd: Could not open compile_flags.txt for writing.")
--         return
--     end
-- end
--
-- local function rookie_clangd_generate_compile_commands(config)
--     -- Get the current working directory
--     local current_dir = vim.fn.getcwd()
--     local preset_idx = rookie_clangd_get_preset_index(config.preset, current_dir)
--     local include_directories = {}
--     local define_symbol = vim.g.rookie_clangd_define_symbols
--
--     if preset_idx == 0 then
--         include_directories = rookie_clangd_search_dir_general(config, current_dir)
--     else
--         include_directories = rookie_clangd_search_dir_preset(config, current_dir, preset_idx)
--     end
--
--     rookie_clangd_write_compile_commands()
--
--     -- function util_is_element_exist(tbl, element)
--     --     for _, value in ipairs(tbl) do
--     --         if value == element then
--     --             return true -- Element found
--     --         end
--     --     end
--     --     return false -- Element not found
--     -- end
-- end
--
-- function Rookie_clangd_main()
--     rookie_clangd_generate_compile_commands(rookie_clangd_config)
-- end

return {
  is_in_table = is_in_table,
  get_element_index = get_element_index,
  get_file_full_path_recursive = get_file_full_path_recursive,
}
