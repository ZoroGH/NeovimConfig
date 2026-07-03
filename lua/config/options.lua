-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
-- Cursor style and blinking
vim.opt.guicursor = {
  "n-v-c:block-Cursor-blinkwait300-blinkon500-blinkoff300",
  "i-ci-ve:ver25-CursorInsert-blinkwait300-blinkon500-blinkoff300",
  "r-cr:hor20-Cursor-blinkwait300-blinkon500-blinkoff300",
  "o:hor50-Cursor-blinkwait300-blinkon500-blinkoff300",
}

-- Make cursor line easier to locate
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
