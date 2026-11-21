return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function()
        require("lualine").setup({
            tabline = {
                lualine_a = {
                    {
                        'buffers',
                        symbols = { alternate_file = '' },
                    }
                },

            },
            options = {
                globalstatus = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                theme = "auto",
            }
        })
    end,
}
