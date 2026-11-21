-- START VIM OPT HELL

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- fallback to tabstop

-- -- use system clipboard, but do this to not increase startup-time
-- vim.api.nvim_create_autocmd('UIEnter', {
--     callback = function()
--         vim.opt.clipboard = 'unnamedplus'
--     end,
-- })

vim.opt.scrolloff = 10

vim.opt.wrap = true

vim.o.list = true

vim.opt.virtualedit = "block"

-- vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.g.mapleader = ','


-- END VIM OPT HELL
-- extra highlight
vim.filetype.add({
    extension = {
        rgbasm = "rgbds",
    }
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("core.lazy")
require("config.extra-keybinds")

vim.cmd("colorscheme onehalfdark")


print("thats so vimcore")
