local utils = require("rookie_clangd.utils")

local function util_get_dirs_with_extension(root_path, exclude_dirs, extension)
    local directories = {}

    local function scan_dir(dir)
        for file_or_dir in vim.fs.dir(dir) do
            local full_path = vim.fs.joinpath(dir, file_or_dir)
            local stat = vim.loop.fs_stat(full_path) -- Get file_or_dir stats
            if stat and stat.type ~= "directory" then -- Check if it's a directory
                local ext = vim.fn.fnamemodify(file_or_dir, ":e")
                local folder = vim.fn.fnamemodify(full_path, ":p:h")
                if
                    ext == extension
                    and utils.is_in_table(exclude_dirs, folder) == false
                    and utils.is_in_table(directories, folder) == false
                then
                    -- Also insert the parent folder
                    local parent = folder
                    while parent ~= root_path do
                        parent = vim.fn.fnamemodify(parent, ":h")
                        if
                            utils.is_in_table(directories, parent) == false
                            and parent ~= root_path
                        then
                            table.insert(directories, parent)
                        end
                    end
                    -- print(folder)
                    table.insert(directories, folder)
                    scan_dir(full_path) -- Recursively scan subdirectories
                end
            else
                scan_dir(full_path) -- Recursively scan subdirectories
            end
        end
    end

    scan_dir(root_path)
    return directories -- Ensure this returns a table
end

local function generate_compile_commands(define_symbols)
    local root_path = vim.fn.getcwd() -- Get the current working directory
    local excludes = { ".git", "build", ".cache", ".github", ".gitlab" }
    local directories = {}
    directories = util_get_dirs_with_extension(root_path, excludes, "h")

    -- Open the file for writing
    local file = io.open("compile_commands.json", "w")
    if not file then
        print("Could not open compile_flags.txt for writing.")
        return
    end

    -- First line bracket
    file:write("[\n")

    local c_files = utils.get_file_full_path_recursive(root_path, "*.c")

    -- local build_directory = root_path .. "/build"
    local build_directory = root_path
    build_directory = build_directory:gsub("\\", "/")

    for index, c_file in ipairs(c_files) do
        c_file = c_file:gsub("\\", "/")
        -- Write {
        file:write("  {\n")
        file:write('    "directory": "' .. build_directory .. '",')
        file:write("\n") -- New line
        file:write('    "command": "\\"gcc\\" ')
        file:write('\\"-ferror-limit=3000\\" ')
        for _, dir in ipairs(directories) do
            dir = dir:gsub("\\", "/")
            file:write('\\"-I' .. dir .. '\\" ') -- Add -I flag for clangd
        end
        if define_symbols ~= {} then
            for _, define_symbol in ipairs(define_symbols) do
                file:write('\\"-D' .. define_symbol .. '\\" ') -- Add -D flag for clangd
            end
        end
        file:write(c_file .. '",')
        file:write("\n") -- New line
        file:write('    "file": "' .. c_file .. '",')
        file:write("\n") -- New line
        file:write('    "output": "' .. c_file .. '.o"')
        file:write("\n") -- New line
        if index == #c_files then
            file:write("  }\n")
        else
            file:write("  },\n")
        end
    end

    -- Last line bracket
    file:write("]")

    -- Close the file
    file:close()

    print("rookie_clangd: compile_commands.json has been created in [" .. root_path .. "]")
end

local function add_define_symbol()
    local current_word = vim.fn.expand("<cword>") -- Get the word under the cursor
    if utils.is_in_table(vim.g.rookie_clangd_define_symbols, current_word) == false then
        table.insert(vim.g.rookie_clangd_define_symbols, current_word)
    end
end

local function remove_define_symbol()
    local current_word = vim.fn.expand("<cword>") -- Get the word under the cursor
    if utils.is_in_table(vim.g.rookie_clangd_define_symbols, current_word) == true then
        local index = utils.get_element_index(vim.g.rookie_clangd_define_symbols, current_word)
        table.remove(vim.g.rookie_clangd_define_symbols, index)
    end
end

return {
    generate_compile_commands = generate_compile_commands,
    add_define_symbol = add_define_symbol,
    remove_define_symbol = remove_define_symbol,
}
