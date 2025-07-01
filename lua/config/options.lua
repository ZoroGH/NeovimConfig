-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.list = true
opt.listchars = {}
opt.wrap = true
opt.relativenumber = false

-- ===================================================================
--  Tab 和缩进设置 (解决您的问题)
-- ===================================================================

-- 1. 设置Tab键的行为为插入空格
opt.expandtab = true

-- 2. 设置Tab的宽度和缩进宽度为4个空格
opt.tabstop = 4 -- 定义一个Tab字符占用的空格数 (用于显示现有文件)
opt.shiftwidth = 4 -- 定义自动缩进时使用的空格数 (例如, 按 >>)
opt.softtabstop = 4 -- 定义按Tab键和Backspace键时操作的空格数，让操作更流畅

-- 3. 美化不可见字符的显示 (解决 `^I` 的问题)
opt.list = true -- 开启此选项以显示不可见字符
opt.listchars = {
    tab = "│ ", -- 将Tab显示为一个竖线和1个空格，比`^I`美观得多
    trail = "·", -- 将行尾多余的空格显示为点
    extends = "»", -- 当行内容超出屏幕时，在行尾显示 `»`
    precedes = "«", -- 当行内容超出屏幕时，在行首显示 `«`
    nbsp = "×", -- 显示不间断空格
    space = "·",
}

-- (可选) 搭配缩进线插件，效果更佳
-- 如果您使用了 `lukas-reineke/indent-blankline.nvim` 这类插件，
-- 可以让上面的'│'符号和插件的缩进线对齐，非常美观。
