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

local function get_filepath_recursive(dir, pattern)
    local files = {}
    -- Get all files in the current directory
    for _, file in ipairs(vim.fn.glob(dir .. "/*." .. pattern, true, true)) do
        table.insert(files, file)
    end
    -- Get all subdirectories
    for _, subdir in ipairs(vim.fn.glob(dir .. "/*", true, true)) do
        if vim.fn.isdirectory(subdir) == 1 then
            -- Recursively get files from subdirectories
            for _, file in ipairs(get_filepath_recursive(subdir, pattern)) do
                table.insert(files, file)
            end
        end
    end
    return files
end

local function get_extension(path)
    return vim.fn.fnamemodify(path, ":e")
end

local function get_folder(path)
    return vim.fn.fnamemodify(path, ":p:h")
end

local function get_container_dirs(root_path, exclude_dirs, extension)
    local directories = {}
    local function scan_dir(dir)
        for file_or_dir in vim.fs.dir(dir) do
            local full_path = vim.fs.joinpath(dir, file_or_dir)
            local stat = vim.loop.fs_stat(full_path) -- Get file_or_dir stats
            if stat and stat.type ~= "directory" then -- Check if it's a directory
                local ext = get_extension(file_or_dir)
                local folder = get_folder(full_path)
                if
                    ext == extension
                    and is_in_table(exclude_dirs, folder) == false
                    and is_in_table(directories, folder) == false
                then
                    -- Also insert the parent folder
                    local parent = folder
                    while parent ~= root_path do
                        parent = vim.fn.fnamemodify(parent, ":h")
                        if is_in_table(directories, parent) == false and parent ~= root_path then
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

local function print_table(tbl)
    print("Table printing: ")
    for _, value in ipairs(tbl) do
        print(value)
    end
end

local function deep_copy(original)
  local copy = {}
  for k, v in pairs(original) do
    if type(v) == "table" then
      copy[k] = deep_copy(v)
    else
      copy[k] = v
    end
  end
  return copy
end

return {
    get_container_dirs = get_container_dirs,
    get_element_index = get_element_index,
    get_filepath_recursive = get_filepath_recursive,
    is_in_table = is_in_table,
    print_table = print_table,
    deep_copy = deep_copy,
}
