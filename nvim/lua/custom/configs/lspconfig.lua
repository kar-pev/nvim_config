local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
}

if not configs.golangcilsp then
    configs.golangcilsp = {
        cmd = { "golangci-lint-langserver" },
        default_config = {
            root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
            init_options = {
                command = { "golangci-lint", "run", "--out-format", "json" },
            },
        },
    }
end

lspconfig.gopls.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        gopls = {
            gofumpt = true,
            experimentalPostfixCompletions = true,
            staticcheck = true,
            usePlaceholders = true,
        },
    },
}

lspconfig.golangcilsp.setup {
    filetypes = { "go" },
}

lspconfig.pylsp.setup {
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                pyflakes = {
                    ignore = { "E501" }
                },
                pycodestyle = {
                    ignore = { "W503" },
                    maxLineLength = 100,
                }
            }
        }
    }
}

-- lspconfig.pyright.setup {
--    capabilities = capabilities,
--    filetypes = { "python" },
--    settings = {
--        python = {
--            analysis = {
--                diagnosticSeverityOverrides = {
--                }
--            }
--        }
--    }
--}


lspconfig.tsserver.setup {
    capabilities = capabilities,
}
