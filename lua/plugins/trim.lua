return {
    {
        "cappyzawa/trim.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- 保存时自动 trim
            trim_on_write = false,

            -- 删除行尾空格
            trim_trailing = true,

            -- 删除文件末尾多余空行
            trim_last_line = true,

            -- 删除文件开头多余空行
            trim_first_line = true,

            -- 高亮行尾空格
            highlight = false,

            -- markdown 行尾两个空格有换行语义，先排除
            ft_blocklist = {
                "markdown",
            },
        },
    },
}
