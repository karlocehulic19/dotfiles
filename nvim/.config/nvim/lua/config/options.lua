-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use LF in dap-back while preserving EditorConfig rules for other projects.
local dap_back_root = vim.fs.normalize(vim.fn.expand("~/work/dap-back")) .. "/"
local editorconfig = require("editorconfig")
local apply_end_of_line = editorconfig.properties.end_of_line

editorconfig.properties.end_of_line = function(bufnr, value, opts)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
  if vim.startswith(path, dap_back_root) then
    value = "lf"
  end
  apply_end_of_line(bufnr, value, opts)
end
