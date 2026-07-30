-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here-- Insert mode: jj -> Esc
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })
-- Shift + Backspace：按普通 Backspace 处理
vim.keymap.set("i", "<S-Del>", "<BS>", {
    remap = false,
    desc = "Shift Backspace",
})

-- 命令行模式也生效
vim.keymap.set("c", "<S-Del>", "<BS>", {
    remap = false,
    desc = "Shift Backspace",
})
