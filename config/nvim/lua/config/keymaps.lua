-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local dap = require("dap")

-- Configure netcoredbg adapter
dap.adapters.coreclr = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
  args = { "--interpreter=vscode" },
}

-- Helper function to find the DLL automatically
local function find_dll()
  local cwd = vim.fn.getcwd()
  local dll_path = vim.fn.glob(cwd .. "/bin/Debug/net*/" .. "*.dll", 0, 1)
  if #dll_path > 0 then
    return dll_path[1]
  else
    return nil
  end
end

-- Configure C# debugging
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "Launch - NetCoreDbg",
    request = "launch",
    program = find_dll, -- dynamically find the DLL
    externalTerminal = true,
  },
}

-- Build & debug function
local function build_and_debug()
  local cwd = vim.fn.getcwd()
  -- Run dotnet build and capture output
  local handle = io.popen("cd " .. cwd .. " && dotnet build 2>&1")
  local result = handle:read("*a")
  handle:close()

  if result:match("Build succeeded.") then
    print("✅ Build succeeded! Launching debugger...")
    dap.continue()
  else
    -- Show errors in floating window
    vim.api.nvim_echo({ { "❌ Build failed, see errors below:", "ErrorMsg" } }, true, {})
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    --    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.6),
      row = math.floor(vim.o.lines * 0.2),
      col = math.floor(vim.o.columns * 0.1),
      style = "minimal",
      border = "rounded",
    })
  end
end

vim.keymap.set("n", "<leader>cd", build_and_debug, { desc = "Compile & Debug", noremap = true, silent = true })
