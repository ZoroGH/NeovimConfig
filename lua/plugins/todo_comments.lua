return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        highlight = {
            keyword = "wide", -- 高亮NOTE: this is note
            after = "bg", -- 高亮 NOTE 后面的说明文字
            multiline = false,
        },

        keywords = {
            SEC = { --  this is a SEC: line
                icon = "󰅂 ",
                color = "#F2AF68",
            },
        },
    }, -- SEC: line
}
