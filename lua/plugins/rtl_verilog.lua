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
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.servers = opts.servers or {}

            local function get_filename(x)
                if type(x) == "number" then
                    local name = vim.api.nvim_buf_get_name(x)
                    if name ~= "" then
                        return name
                    end
                    return vim.uv.cwd()
                end

                if type(x) == "string" and x ~= "" then
                    return x
                end

                return vim.uv.cwd()
            end

            local function verible_root_dir(x, on_dir)
                local fname = get_filename(x)
                local util = require("lspconfig.util")

                local root = util.root_pattern(
                    ".git",
                    ".svn",
                    "Makefile",
                    "makefile",
                    "filelist.f",
                    "flist.f",
                    "verible.filelist",
                    ".rules.verible_lint"
                )(fname)

                if not root then
                    root = vim.fs.dirname(fname) or vim.uv.cwd()
                end

                -- New nvim-lspconfig style may pass on_dir callback.
                if type(on_dir) == "function" then
                    on_dir(root)
                end

                -- Old style expects return value.
                return root
            end

            local ignored_verible_rules = {
                "no-trailing-spaces",
                "line-length",
                "module-filename",
                "explicit-parameter-storage-type",
                "parameter-name-style",
                "always-comb",
            }

            local verible_base_cmd = {
                "verible-verilog-ls",
                "--lsp_enable_hover",
                "--rules=-" .. table.concat(ignored_verible_rules, ",-"),
            }

            local function find_verible_flist(root_dir)
                local flists = vim.fn.globpath(root_dir, "*/rtl/*.flist", false, true)

                table.sort(flists)

                if #flists == 1 then
                    return flists[1]
                end

                if #flists == 0 then
                    vim.schedule(function()
                        vim.notify("Verible: 未找到 */rtl/*.flist\nroot: " .. root_dir, vim.log.levels.WARN)
                    end)

                    return nil
                end

                vim.schedule(function()
                    vim.notify(
                        "Verible: 找到多个 *.flist，无法确定使用哪个：\n" .. table.concat(flists, "\n"),
                        vim.log.levels.WARN
                    )
                end)

                return nil
            end

            opts.servers.verible = {
                mason = false,

                cmd = vim.deepcopy(verible_base_cmd),

                filetypes = {
                    "verilog",
                    "systemverilog",
                },

                root_dir = verible_root_dir,

                on_new_config = function(new_config, new_root_dir)
                    -- 每个工程都重新生成启动命令，避免继承上一个工程的 flist
                    new_config.cmd = vim.deepcopy(verible_base_cmd)

                    local flist = find_verible_flist(new_root_dir)

                    if flist then
                        table.insert(new_config.cmd, "--file_list_path=" .. flist)

                        vim.schedule(function()
                            vim.notify("Verible 使用 filelist：\n" .. flist, vim.log.levels.INFO)
                        end)
                    end
                end,
            }
        end,
    },

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
