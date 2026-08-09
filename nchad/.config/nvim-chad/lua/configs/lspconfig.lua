-- Load NvChad's default LSP configuration hook
require("nvchad.configs.lspconfig").defaults()

-- Helper to dynamically find the python executable (Native Nvim 0.11+)
local function get_python_path(workspace)
  -- 1. Check if a virtual environment is already activated in the terminal
  if vim.env.VIRTUAL_ENV then
    return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- 2. Check for uv's default `.venv` inside the project root
  local venv = vim.fs.joinpath(workspace, ".venv")
  if vim.fn.isdirectory(venv) == 1 then
    local python_path = vim.fs.joinpath(venv, "bin", "python")
    -- Fallback for Windows machines
    if vim.fn.executable(python_path) ~= 1 then
      python_path = vim.fs.joinpath(venv, "Scripts", "python.exe")
    end
    return python_path
  end

  -- 3. Fallback to the system python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- Configure basedpyright using the new Nvim 0.11 API
vim.lsp.config("basedpyright", {
  on_new_config = function(new_config, new_root_dir)
    -- Inject the uv python path before the server starts
    new_config.settings = new_config.settings or {}
    new_config.settings.python = new_config.settings.python or {}
    new_config.settings.python.pythonPath = get_python_path(new_root_dir)
  end,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard", -- Options: "off", "basic", "standard", "strict"
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
    python = {
      pythonPath = "", -- Populated dynamically by on_new_config
    },
  },
})

-- Enable the server so it attaches to your Python buffers
vim.lsp.enable("basedpyright")
