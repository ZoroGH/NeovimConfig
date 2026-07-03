-- lua/plugins/mini.lua

return {
    "nvim-mini/mini.nvim",
    version = "*", -- 建议锁定到最新的稳定版
    config = function()
        -- 在这里启用并配置你想要的 mini 模块
        -- 例如，启用并配置 mini.surround 和 mini.align

        -- 启用 mini.surround (添加、删除、修改包围符号)
        require("mini.surround").setup()

        -- 启用 mini.align (对齐文本)
        require("mini.align").setup()

        -- 如果你还想用其他模块，在这里继续添加...
        -- require('mini.comment').setup()
        -- require('mini.pairs').setup()

        print("mini.nvim modules loaded!") -- 这行可以帮你确认配置是否生效
    end,
}
