return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/nvim-cmp' },
            { 'j-hui/fidget.nvim' },
        },
        opts = function()
            return {
                diagnostics = {
                    underline = true,
                    update_in_insert = true,
                },
                inlay_hints = {
                    enabled = true
                },
            }
        end,

        config = function()
            --vim.pack.add{'https://github.com/neovim/nvim-lspconfig'}
            --local lspconf = require('lspconfig')

            vim.lsp.enable({"rust_analyzer"})
            vim.lsp.config["rust_analyzer"] = {
                settings = {
                    ['rust-analyzer'] = {
                        check = {
                            command = 'clippy',
                            invocationLocation = 'workspace',
                            features = 'all',
                            extraArgs = {
                                '--',
                                '--no-deps',
                                '-Dclippy::correctness',
                                '-Dclippy::complexity',
                                '-Wclippy::perf',
                                -- '-Wclippy::pedantic',
                            }
                        },
                        diagnostics = { styleLints = { enable = true } },
                        rustfmt = { rangeFormatting = { enable = true } },
                    }
                }
            }
            vim.lsp.enable({"gopls"})
            vim.lsp.enable({"clangd"})
            vim.lsp.enable({"lua_ls"})
            vim.lsp.config["lua_ls"] = {
                format = {
                    enable = true,

                    defaultconfig = {
                        indent_style = "space",
                        indent_size = "4"
                    }
                }
            }

            vim.diagnostic.config({
                virtual_text = true,
                update_in_insert = true,
                severity_sort = true,
                underline = true,
                --[[
                virtual_lines = {
                    current_line = true
                },
                ]]
            })
            --[[
            vim.keymap.set('n', '<leader>ck', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
            ]]
        end,
        keys = {
            { '<leader>ck', vim.lsp.buf.hover },
            { '<leader>ca', vim.lsp.buf.code_action },
            { '<leader>cf', vim.lsp.buf.format },
            { '<leader>cd', vim.diagnostic.open_float },
            { 'gd',         vim.lsp.buf.definition },
            { 'gD',         vim.lsp.buf.declaration },
            { 'gi',         vim.lsp.buf.implementation },
            { 'gr',         vim.lsp.buf.references },
        },
    },
}
