return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            local function encoding()
                local enc = vim.bo.fileencoding
                if enc == "" then
                    enc = vim.o.encoding
                end
                return enc:upper()
            end

            local function filetype()
                local ft = vim.bo.filetype
                if ft == "" then
                    return "no ft"
                end
                return ft
            end

            opts.sections = opts.sections or {}
            opts.sections.lualine_y = opts.sections.lualine_y or {}

            table.insert(opts.sections.lualine_y, {
                "fileformat",
                symbols = {
                    unix = "LF",
                    dos = "CRLF",
                    mac = "CR",
                },
            })

            table.insert(opts.sections.lualine_y, encoding)
            table.insert(opts.sections.lualine_y, filetype)
        end,
    },
}
