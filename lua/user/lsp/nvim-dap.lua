local config_status_ok, dap = pcall(require, "dap")
if not config_status_ok then
    return
end

-- dap-python is configured at the end

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-----------------------------------------------------------------------------------------------
-- nvim-dap

-- Start in a new window as terminal
dap.defaults.fallback.terminal_win_cmd = 'vsplit new'
dap.defaults.fallback.focus_terminal = true

-- This is also used for the setup of nvim-dap-python, which uses debugpy
local pythonvenv = os.getenv('HOME') .. '/.virtualenvs/debugpy/bin/python'

-- Get the AD7 debug adapter directly from Mason
local cpptools = os.getenv('HOME') .. '/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'

-- Likewise, codelldb will come from Mason
local codelldb = os.getenv('HOME') .. '/.local/share/nvim/mason/packages/codelldb/codelldb'

-- nvim-dap: debug adapters to launch / connect to debuggee
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = cpptools
}

dap.adapters.python = {
    id = 'python3',
    type = 'executable',
    command = pythonvenv,
    args = { '-m', 'debugpy.adapter' }
}

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb,
        args = { "--port", "${port}" },
    },
}

local function getpath()
    return vim.fn.input({ prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' })
end

-- configurations for the debug adapters
dap.configurations.cpp = {
    {
        name = "Launch file (LLDB)",
        type = "codelldb",
        request = "launch",
        program = getpath,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
    },
    {
        name = "Launch file (cpptools)",
        type = "cppdbg",
        request = "launch",
        program = getpath,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
    },
    -- cpptools makes more sense for gdb than codelldb 
    {
        name = 'Attach to gdb :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = getpath,
    },
    -- for embedded targets, cpptools works best
    {
        name = 'Attach to avr-gdb :4242',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:4242',
        miDebuggerPath = '/usr/bin/avr-gdb',
        cwd = '${workspaceFolder}',
        program = getpath,
    },
    -- Assumes a user configured symlink to the gcc-arm-none-eabi-xxx toolchain
    {
        name = 'Attach to arm-none-eabi-gdb :2331',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:2331',
        miDebuggerPath = 'arm-none-eabi-gdb',
        cwd = '${workspaceFolder}',
        program = getpath,
    },
}

dap.configurations.c = dap.configurations.cpp

dap.configurations.python = {
    {
        name = "Specify launch file",
        type = "python",
        request = 'launch',
        program = getpath,
        pythonPath = '/usr/bin/python3',
        cwd = '${workspaceFolder}',
        console = "integratedTerminal",
        stopAtEntry = true,
    }
}

-- Key bindings
keymap("n", "<F5>", "<cmd>DapContinue<cr>", opts)
keymap("n", "<F17>", "<cmd>DapTerminate<cr>", opts)
keymap("n", "<F6>", "<cmd>DapToggleBreakpoint<cr>", opts)
keymap("n", "<F10>", "<cmd>DapStepOver<cr>", opts)
keymap("n", "<F9>", "<cmd>DapStepInto<cr>", opts)
keymap("n", "<F21>", "<cmd>DapStepOut<cr>", opts)

-- We also want similar mappings for terminal mode, so we don't have to use <ESC> and i
local function terminalDebugKeymaps(ev)
    local keymapbuf = vim.api.nvim_buf_set_keymap
    keymapbuf(ev.buf, 't', "<F5>", "<C-\\><C-n><cmd>DapContinue<cr>i", opts)
    keymapbuf(ev.buf, 't', "<F17>", "<C-\\><C-n><cmd>DapTerminate<cr>", opts)
    keymapbuf(ev.buf, 't', "<F6>", "<C-\\><C-n><cmd>DapToggleBreakpoint<cr>i", opts)
    keymapbuf(ev.buf, 't', "<F9>", "<C-\\><C-n><cmd>DapStepInto<cr>i", opts)
    keymapbuf(ev.buf, 't', "<F23>", "<C-\\><C-n><cmd>DapStepOut<cr>", opts)
    keymapbuf(ev.buf, 't', "<F10>", "<C-\\><C-n><cmd>DapStepOver<cr>i", opts)
    -- as a general rule, if we actually enter the debug window, we want to enter console input
    --vim.cmd("startinsert")
end

-- DAP opens with [dap-terminal] in the buffer name; we call the mappings when the pattern matches
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { '\\[dap-terminal]*' },
    callback = terminalDebugKeymaps
})


-------------------------------------------------------------------------------------
-- nvim-dap-python
require('dap-python').setup(pythonvenv)

-------------------------------------------------------------------------------------
-- nvim-dap-ui

local dapui_status_ok, dapui = pcall(require, "dapui")
if not dapui_status_ok then
    return
end

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end

-- Key bindings
keymap("n", "<F7>", "<cmd>lua require('dapui').open()<cr>", opts)
keymap("n", "<F19>", "<cmd>lua require('dapui').close()<cr>", opts)
