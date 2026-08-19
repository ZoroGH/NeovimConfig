return {
    {
        "0xferrous/ansi.nvim",
        config = function()
            require("ansi").setup({
                auto_enable = true,
                auto_enable_stdin = true,
                theme = "dracula",
                filetypes = {
                    "log",
                },
            })
        end,
    },
}
