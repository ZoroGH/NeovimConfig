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

local opt = vim.opt
-- Make cursor line easier to locate
opt.cursorline = true
opt.cursorlineopt = "number,line"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.list = true
opt.wrap = true

-- 1. 设置Tab键的行为为插入空格
opt.expandtab = true

-- 2. 设置Tab的宽度和缩进宽度为4个空格
opt.tabstop = 4 -- 定义一个Tab字符占用的空格数 (用于显示现有文件)
opt.shiftwidth = 4 -- 定义自动缩进时使用的空格数 (例如, 按 >>)
opt.softtabstop = 4 -- 定义按Tab键和Backspace键时操作的空格数，让操作更流畅

-- 3. 美化不可见字符的显示 (解决 `^I` 的问题)
opt.listchars = {
    tab = "│ ", -- 将Tab显示为一个竖线和1个空格，比`^I`美观得多
    trail = "·", -- 将行尾多余的空格显示为点
    extends = "»", -- 当行内容超出屏幕时，在行尾显示 `»`
    precedes = "«", -- 当行内容超出屏幕时，在行首显示 `«`
    nbsp = "×", -- 显示不间断空格
    space = "·",
}

-- SystemVerilog 文件使用 Verilog Tree-sitter parser
vim.treesitter.language.register("verilog", { "systemverilog" })
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
-- 默认展开所有折叠
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
