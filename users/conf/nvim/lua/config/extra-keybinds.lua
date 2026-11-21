-- system clipboard keybinds
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y') -- will probably go unused, but nice to have all of them.
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p')
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P')

-- switch buffer keybinds
vim.keymap.set('n', '<leader>tn', vim.cmd.bnext)
vim.keymap.set('n', '<leader>tp', vim.cmd.bprevious)

-- delete and switch buffer
vim.keymap.set('n', '<leader>tq', function()
    vim.cmd('b#')
    vim.cmd('bd! #')
end)

-- just kill buffer
vim.keymap.set('n', '<leader>q', function()
    vim.cmd('bd!')
end)

-- neotree stuff
vim.keymap.set('n', '<leader>f', '<Cmd>Neotree float toggle<CR>')
vim.keymap.set('n', '<leader>b', '<Cmd>Neotree float toggle buffers<CR>')
--vim.keymap.set('n', '<leader>fg', '<Cmd>Neotree float git_status toggle<CR>')

-- switch from terminal 
vim.keymap.set('t', '<C-w><C-w>', "<C-\\><C-n><C-w>h", {silent = true})
