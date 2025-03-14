local utils = require("rookie_clangd.utils")
local generator = require("rookie_clangd.generator")
local loader = require("rookie_clangd.loader")

local function generate_compile_commands()
    -- Get the current working directory
    local current_dir = vim.fn.getcwd()
    current_dir = current_dir:gsub("\\", "/")

    -- Load config
    local excludes = loader.load_exclude_dir(current_dir)
    local extra_flags = loader.load_extra_flags(current_dir)
    local compiler = loader.load_compiler(current_dir)
    local source_pattern = loader.load_source_pattern(current_dir)
    local header_pattern = loader.load_header_pattern(current_dir)
    local define = loader.load_define(current_dir)
    local include = loader.load_include(current_dir)
    local hooks = loader.load_hooks(current_dir)

    -- Concat
    local sources = {}
    for _, pattern in ipairs(source_pattern) do
        for _, v in ipairs(utils.get_filepath_recursive(current_dir, pattern)) do
            table.insert(sources, v)
        end
    end
    for _, pattern in ipairs(header_pattern) do
        for _, v in ipairs(utils.get_container_dirs(current_dir, excludes, pattern)) do
            table.insert(include, v)
        end
    end
    for _, v in ipairs(vim.g.rookie_clangd_define_symbols) do
        table.insert(define, v)
    end

    -- Before
    if hooks and hooks.before_generation_callback then
        hooks.before_generation_callback()
    end

    -- Generate
    if generator.init(current_dir) == true then
        generator.set_build_dir(current_dir)
        generator.set_sources(sources)
        generator.set_compiler(compiler)
        generator.set_extra_flags(extra_flags)
        generator.set_includes(include)
        generator.set_defines(define)
        generator.finish()
        print("rookie_clangd: compile_commands.json has been created in [" .. current_dir .. "]")
    end

    -- After
    if hooks and hooks.after_generation_callback then
        hooks.after_generation_callback()
    end
end

local function add_define_symbol()
    local current_word = vim.fn.expand("<cword>") -- Get the word under the cursor
    if utils.is_in_table(vim.g.rookie_clangd_define_symbols, current_word) == false then
        table.insert(vim.g.rookie_clangd_define_symbols, current_word)
        generate_compile_commands() -- Regenerate the "compile_commands.json"
    end
end

local function remove_define_symbol()
    local current_word = vim.fn.expand("<cword>") -- Get the word under the cursor
    if utils.is_in_table(vim.g.rookie_clangd_define_symbols, current_word) == true then
        local index = utils.get_element_index(vim.g.rookie_clangd_define_symbols, current_word)
        table.remove(vim.g.rookie_clangd_define_symbols, index)
        generate_compile_commands() -- Regenerate the "compile_commands.json"
    end
end

local function choose_preset() end

return {
    add_define_symbol = add_define_symbol,
    generate_compile_commands = generate_compile_commands,
    choose_preset = choose_preset,
    remove_define_symbol = remove_define_symbol,
}
