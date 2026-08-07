-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--

local function set_cursor_highlights()
    vim.api.nvim_set_hl(0, "cursor", {
        fg = "#000000",
        bg = "#ffcc00",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "cursorinsert", {
        fg = "#000000",
        bg = "#00d7ff",
        bold = true,
    })

    vim.api.nvim_set_hl(0, "cursorline", {
        bg = "#3a3f4b",
    })

    vim.api.nvim_set_hl(0, "cursorlinenr", {
        fg = "#ff79c6",
        bold = true,
    })
end

set_cursor_highlights()

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    callback = set_cursor_highlights,
})

local function keep_view(fn)
    local view = vim.fn.winsaveview()
    local search = vim.fn.getreg("/")
    fn()
    vim.fn.setreg("/", search)
    vim.fn.winrestview(view)
end

vim.api.nvim_create_user_command("StripSvComments", function(opts)
    keep_view(function()
        vim.cmd([[silent! keeppatterns %s#/\*\_.\{-}\*/##ge]])
        vim.cmd([[silent! keeppatterns %s#//.*$##ge]])

        if opts.bang then
            vim.cmd([[silent! keeppatterns g#^\s*$#d]])
        end
    end)
end, {
    bang = true,
    desc = "Remove Verilog/SystemVerilog comments. Use ! to also remove empty lines",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.name == "verible" then
            -- 语义导航交给 LazyVerilog
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.renameProvider = false
        end
    end,
})



local inlay_group = vim.api.nvim_create_augroup("SvInlayHintsInsert", {
    clear = true,
})

-- 进入 Insert：暂时关闭 inlay hints
vim.api.nvim_create_autocmd("InsertEnter", {
    group = inlay_group,
    callback = function(args)
        local ft = vim.bo[args.buf].filetype

        if ft ~= "verilog" and ft ~= "systemverilog" then
            return
        end

        local filter = { bufnr = args.buf }

        -- 记录进入 Insert 前是否开启
        vim.b[args.buf].inlay_was_enabled =
            vim.lsp.inlay_hint.is_enabled(filter)

        if vim.b[args.buf].inlay_was_enabled then
            vim.lsp.inlay_hint.enable(false, filter)
        end
    end,
})

-- 离开 Insert：如果原本开启，则恢复
vim.api.nvim_create_autocmd("InsertLeave", {
    group = inlay_group,
    callback = function(args)
        local ft = vim.bo[args.buf].filetype

        if ft ~= "verilog" and ft ~= "systemverilog" then
            return
        end

        if vim.b[args.buf].inlay_was_enabled then
            vim.lsp.inlay_hint.enable(true, {
                bufnr = args.buf,
            })
        end

        vim.b[args.buf].inlay_was_enabled = false
    end,
})
