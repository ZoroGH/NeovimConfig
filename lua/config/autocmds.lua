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

-- 鼠标/光标停止多久后触发 CursorHold
vim.opt.updatetime = 500

vim.api.nvim_create_autocmd("CursorHold", {
    pattern = {
        "*.v",
        "*.sv",
        "*.svh",
    },

    callback = function()
        -- 只在普通模式触发
        if vim.fn.mode() ~= "n" then
            return
        end

        local clients = vim.lsp.get_clients({
            bufnr = 0,
            method = "textDocument/hover",
        })

        if #clients == 0 then
            return
        end

        vim.lsp.buf.hover({
            border = "rounded",
            focusable = false,
        })
    end,
})
