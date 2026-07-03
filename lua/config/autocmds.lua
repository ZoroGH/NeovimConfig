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
