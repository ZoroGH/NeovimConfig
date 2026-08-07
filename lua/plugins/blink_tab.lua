return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                preset = "super-tab",
            },

            sources = {
                providers = {
                    lsp = {
                        transform_items = function(_, items)
                            -- 只对 Verilog / SystemVerilog 生效
                            local ft = vim.bo.filetype
                            if ft ~= "verilog" and ft ~= "systemverilog" then
                                return items
                            end

                            local kind = require("blink.cmp.types").CompletionItemKind

                            -- 去掉 LSP 提供的 Keyword
                            -- 例如 begin / end / if / always_ff ...
                            return vim.tbl_filter(function(item)
                                return item.kind ~= kind.Keyword
                            end, items)
                        end,
                    },
                },
            },
        },
    },
}
