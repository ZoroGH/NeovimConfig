return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                virtual_text = {
                    severity = {
                        min = vim.diagnostic.severity.ERROR,
                        max = vim.diagnostic.severity.ERROR,
                    },
                    prefix = "●",
                    source = "if_many",
                    spacing = 4,
                },
                virtual_lines = false,
            },
        },
    },
}
