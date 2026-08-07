return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                preset = "super-tab",
            },

            sources = {
                providers = {
                    -- 不使用 Friendly Snippets
                    -- 但保留 ~/.config/nvim/snippets/ 里的自己的 snippets
                    snippets = {
                        opts = {
                            friendly_snippets = false,
                        },
                    },
                    buffer = {
                        opts = {
                            max_sync_buffer_size = 50000,
                            max_async_buffer_size = 1000000,
                            max_total_buffer_size = 2000000,
                            use_cache = true,
                        },
                    },
                    lsp = {
                        fallbacks = {},
                        transform_items = function(_, items)
                            local ft = vim.bo.filetype

                            if ft ~= "verilog" and ft ~= "systemverilog" then
                                return items
                            end

                            local kind = require("blink.cmp.types").CompletionItemKind

                            return vim.tbl_filter(function(item)
                                -- 去掉 LazyVerilog 自己的：
                                --   keyword
                                --   structural snippets
                                --
                                -- 保留 Variable / Field / Module / Class ...
                                return item.kind ~= kind.Keyword and item.kind ~= kind.Snippet
                            end, items)
                        end,
                    },
                },
            },
        },
    },
}
