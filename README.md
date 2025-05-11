# rookie_clangd.nvim

This is for who want to browse the C project with the power of Clangd, but without building it with
CMake.

The language-server-protocol Clangd is good, however it requires **compile_commands.json** to index
the codes, which is sometimes annoying when the project is not originally built by CMake or you just
simply want to read the codes.

## How it works?

This plugin generate a "fake" `compile_commands.json` file in the project root. It simply loops
through all the directories and add the directory that contains header files. Yes, rookie style,
simple but it works.

## Install

-   With `lazy.nvim`

```lua
    require("lazy").setup(
        {
            "modulo-medito/rookie_clangd.nvim",
            config = function()

                -- Config the user shorter command
                vim.api.nvim_create_user_command("Xgec", function()
                    require("rookie_clangd").api.generate_compile_commands()
                end, {})
                vim.api.nvim_create_user_command("Xads", function()
                    require("rookie_clangd").api.add_define_symbol()
                end, {})
                vim.api.nvim_create_user_command("Xrms", function()
                    require("rookie_clangd").api.remove_define_symbol()
                end, {})

                -- You configuration here
                require("rookie_clangd").setup({
                })

            end,
        },
        -- ... your other lazy plugins
    )
```

## Configuration

T.B.D

## Commands

| Command                             | Description                                                               |
| ----------------------------------- | ------------------------------------------------------------------------- |
| RookieClangdGenerateCompileCommands | Generate `compile_commands.json` in project root                          |
| RookieClangdAddDefineSymbol         | Add define symbol under cursor and re-generate `compile_commands.json`    |
| RookieClangdRemoveDefineSymbol      | Remove define symbol under cursor and re-generate `compile_commands.json` |

## Doc

No vim-style help doc offering, view this doc again by `:h rookie_clangd.nvim` in neovim.
