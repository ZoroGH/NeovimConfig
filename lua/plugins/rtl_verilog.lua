return {
    -- =========================================================
    -- Filetype: Verilog / SystemVerilog
    -- =========================================================
    {
        "LazyVim/LazyVim",
        init = function()
            vim.filetype.add({
                extension = {
                    v = "verilog",
                    vh = "verilog",
                    sv = "systemverilog",
                    svh = "systemverilog",
                },
            })

            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.v", "*.vh", "*.sv", "*.svh" },
                callback = function()
                    vim.bo.commentstring = "// %s"
                    vim.bo.tabstop = 4
                    vim.bo.shiftwidth = 4
                    vim.bo.softtabstop = 4
                    vim.bo.expandtab = true

                    -- Use Vim built-in Verilog syntax for now.
                    -- Do not use treesitter for Verilog/SV yet.
                    vim.cmd("syntax on")
                    vim.bo.syntax = "verilog"
                end,
            })
        end,
    },

    -- =========================================================
    -- Treesitter:
    -- Do not install/use verilog parser for now.
    -- Your current nvim-treesitter reports verilog unsupported.
    -- =========================================================
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}

            opts.ensure_installed = vim.tbl_filter(function(lang)
                return lang ~= "verilog" and lang ~= "systemverilog"
            end, opts.ensure_installed)

            opts.highlight = opts.highlight or {}
            opts.highlight.enable = true

            local old_disable = opts.highlight.disable

            opts.highlight.disable = function(lang, bufnr)
                if lang == "verilog" or lang == "systemverilog" then
                    return true
                end

                if type(old_disable) == "function" then
                    return old_disable(lang, bufnr)
                end

                if type(old_disable) == "table" then
                    return vim.tbl_contains(old_disable, lang)
                end

                return false
            end
        end,
    },

    -- =========================================================
    -- LSP: Verible
    -- Requires verible-verilog-ls in PATH
    -- =========================================================
    -- {
    --     "neovim/nvim-lspconfig",
    --     opts = function(_, opts)
    --         opts.servers = opts.servers or {}
    --
    --         local function get_filename(x)
    --             if type(x) == "number" then
    --                 local name = vim.api.nvim_buf_get_name(x)
    --                 if name ~= "" then
    --                     return name
    --                 end
    --                 return vim.uv.cwd()
    --             end
    --
    --             if type(x) == "string" and x ~= "" then
    --                 return x
    --             end
    --
    --             return vim.uv.cwd()
    --         end
    --
    --         local function verible_root_dir(x, on_dir)
    --             local fname = get_filename(x)
    --             local start_dir = vim.fs.dirname(fname)
    --
    --             -- 优先寻找我们生成的唯一工程 filelist
    --             local filelist = vim.fs.find("verible.filelist", {
    --                 path = start_dir,
    --                 upward = true,
    --                 type = "file",
    --             })[1]
    --
    --             local root
    --
    --             if filelist then
    --                 root = vim.fs.dirname(filelist)
    --             else
    --                 -- 没找到时，才退回 SVN / Git 根目录
    --                 local util = require("lspconfig.util")
    --
    --                 root = util.root_pattern(".svn", ".git")(fname) or start_dir or vim.uv.cwd()
    --             end
    --
    --             -- 兼容新版 nvim-lspconfig 的回调形式
    --             if type(on_dir) == "function" then
    --                 on_dir(root)
    --             end
    --
    --             return root
    --         end
    --
    --         local ignored_verible_rules = {
    --             "no-trailing-spaces",
    --             "line-length",
    --             "module-filename",
    --             "explicit-parameter-storage-type",
    --             "parameter-name-style",
    --             "always-comb",
    --         }
    --
    --         local verible_base_cmd = {
    --             "verible-verilog-ls",
    --             "--lsp_enable_hover",
    --             "--rules=-" .. table.concat(ignored_verible_rules, ",-"),
    --         }
    --
    --         opts.servers.verible = {
    --             mason = false,
    --
    --             cmd = vim.deepcopy(verible_base_cmd),
    --
    --             filetypes = {
    --                 "verilog",
    --                 "systemverilog",
    --             },
    --
    --             root_dir = verible_root_dir,
    --
    --             on_new_config = function(new_config, new_root_dir)
    --                 new_config.cmd = vim.deepcopy(verible_base_cmd)
    --
    --                 local filelist = new_root_dir .. "/verible.filelist"
    --
    --                 if vim.fn.filereadable(filelist) == 1 then
    --                     table.insert(new_config.cmd, "--file_list_path=" .. filelist)
    --
    --                     vim.schedule(function()
    --                         vim.notify("Verible filelist:\n" .. filelist, vim.log.levels.INFO)
    --                     end)
    --                 else
    --                     vim.schedule(function()
    --                         vim.notify(
    --                             "Verible: 未找到 verible.filelist\nroot: " .. new_root_dir,
    --                             vim.log.levels.WARN
    --                         )
    --                     end)
    --                 end
    --             end,
    --         }
    --     end,
    -- },

    -- =========================================================
    -- Formatter: Verible
    -- Requires verible-verilog-format in PATH
    -- =========================================================
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}

            opts.formatters_by_ft.verilog = { "verible_verilog_format" }
            opts.formatters_by_ft.systemverilog = { "verible_verilog_format" }

            opts.formatters = opts.formatters or {}

            opts.formatters.verible_verilog_format = {
                command = "verible-verilog-format",
                args = {
                    "--column_limit=300",
                    "--indentation_spaces=4",
                    "--wrap_spaces=4",

                    -- 列表使用固定层级缩进
                    "--port_declarations_indentation=indent",
                    "--formal_parameters_indentation=indent",
                    "--named_port_indentation=indent",
                    "--named_parameter_indentation=indent",

                    -- 按列进行表格化对齐
                    "--assignment_statement_alignment=align",
                    "--named_port_alignment=align",
                    "--port_declarations_alignment=align",
                    "--module_net_variable_alignment=align",

                    "--port_declarations_right_align_packed_dimensions=true",
                    "--port_declarations_right_align_unpacked_dimensions=true",

                    "--wrap_end_else_clauses=false",

                    -- 空行和分隔注释切断对齐组
                    "--alignment_group_boundary=blank-lines-and-separator-comments",
                    "-",
                },
                stdin = true,
            }
        end,
    },
}
