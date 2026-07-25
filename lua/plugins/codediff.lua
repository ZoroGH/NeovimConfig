return {
    {
        "esmuellert/codediff.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = "CodeDiff",
        opts = {
            highlights = {
                -- 整行背景：适当加强
                line_insert = "#20452f",
                line_delete = "#512b34",

                -- 真正发生变化的字符：使用更深、更明显的颜色
                char_insert = "#347a50",
                char_delete = "#a34755",
            },

            -- highlights = {
            --     line_insert = "#28583a",
            --     line_delete = "#63313c",
            --
            --     char_insert = "#3f8f5e",
            --     char_delete = "#bd4b5c",
            -- },
            --
            diff = {
                filler_text = "",
                layout = "side-by-side",

                -- 防止高亮被其他 extmark/LSP 高亮压住
                highlight_priority = 150,
            },
        },
    },
}
