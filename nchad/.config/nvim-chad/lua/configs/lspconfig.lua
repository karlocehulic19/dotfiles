-- lua/configs/lspconfig.lua

require("nvchad.configs.lspconfig").defaults()

local function get_python_path(workspace)
  -- 1. Check if a virtual environment is already activated in the terminal
  if vim.env.VIRTUAL_ENV then
    return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- 2. SAFETY GUARD: workspace can be nil when doing `:e` or opening single files
  if workspace then
    local venv = vim.fs.joinpath(workspace, ".venv")
    if vim.fn.isdirectory(venv) == 1 then
      local python_path = vim.fs.joinpath(venv, "bin", "python")
      if vim.fn.executable(python_path) ~= 1 then
        python_path = vim.fs.joinpath(venv, "Scripts", "python.exe")
      end
      return python_path
    end
  end

  -- 3. Fallback to the system python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

vim.lsp.config("basedpyright", {
  -- Explicitly tell Nvim 0.11 how to run and attach the server
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  
  -- Essential for `uv` projects: tells Neovim how to find the root on `:e`
  root_markers = { "uv.lock", "pyproject.toml", "setup.py", ".git" },
  
  on_new_config = function(new_config, new_root_dir)
    new_config.settings = new_config.settings or {}
    new_config.settings.python = new_config.settings.python or {}
    new_config.settings.python.pythonPath = get_python_path(new_root_dir)
  end,
  
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard", 
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
    python = {
      pythonPath = "", 
    },
  },
})

vim.lsp.enable("basedpyright")
