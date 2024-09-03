local js_based_languages = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
}

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "microsoft/vscode-js-debug",
            -- After install, build it and rename the dist directory to out
            build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
            version = "1.*",
        },
        "mxsdev/nvim-dap-vscode-js",
        "rcarriga/nvim-dap-ui",
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },
    },
    -- stylua: ignore
    keys = {
        { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dd", function() require("dap").continue() end, desc = "Continue" },
        { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
        -- { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        -- { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
        local dap = require("dap")
        local dap_js = require("dap-vscode-js")

        dap_js.setup({
            node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"), -- Path to vscode-js-debug installation.
            adapters = {
                "pwa-node",
                "pwa-chrome",
            },
            log_file_path = "/tmp/vscode-js-debug.log", -- Path for file logging
            log_file_level = vim.log.levels.ERROR, -- Logging level for output to file. Set to false to disable file logging.
            log_console_level = vim.log.levels.ERROR, -- Logging level for output to console. Set to false to disable console output.
        })

        for _, language in ipairs(js_based_languages) do
            dap.configurations[language] = {
                -- Debug single nodejs files
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                },
                -- Debug nodejs processes (make sure to add --inspect when you run the process)
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require("dap.utils").pick_process,
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                },
                -- Debug web applications (client side)
                {
                    type = "pwa-chrome",
                    request = "launch",
                    name = "Launch & Debug Chrome",
                    url = function()
                        local co = coroutine.running()
                        return coroutine.create(function()
                            vim.ui.input({
                                prompt = "Enter URL: ",
                                default = "http://localhost:3000",
                            }, function(url)
                                if url == nil or url == "" then
                                    return
                                else
                                    coroutine.resume(co, url)
                                end
                            end)
                        end)
                    end,
                    webRoot = vim.fn.getcwd(),
                    protocol = "inspector",
                    sourceMaps = true,
                    userDataDir = false,
                },
                -- Divider for the launch.json derived configs
                {
                    name = "----- launch.json configs -----",
                    type = "",
                    request = "launch",
                },
            }
        end

        -- setup dap config by VsCode launch.json file
        local vscode = require("dap.ext.vscode")
        local json = require("plenary.json")
        vscode.json_decode = function(str)
            return vim.json.decode(json.json_strip_comments(str))
        end

        -- Extends dap.configurations with entries read from .vscode/launch.json
        if vim.fn.filereadable(".vscode/launch.json") then
            vscode.load_launchjs()
        end
    end,
}
