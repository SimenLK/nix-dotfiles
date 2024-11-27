-- My lsp configs...

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities =
  vim.tbl_deep_extend(
    "force",
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
  )
local lsp_zero = require("lsp-zero")
local cmp = require("cmp")

lsp_zero.on_attach(function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil

  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.setup_servers({
  'clangd',
  'dagger',
  'dhall_lsp_server',
  'gopls',
  'marksman',
  -- 'nil_ls',
  'pyright',
  'ts_ls',
})

local capabilities = lsp_zero.get_capabilities()

local lua_opts = lsp_zero.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)

require('lspconfig').fsautocomplete.setup {
  capabilities = capabilities
}

require('lspconfig').cssls.setup {
  capabilities = capabilities,
}

require('lspconfig').yamlls.setup {
  -- other configuration for setup {}
  settings = {
    yaml = {
      -- other settings. note this overrides the lspconfig defaults.
      schemas = {
        kubernetes = "*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      },
    },
  }
}

require('lspconfig').helm_ls.setup {
  -- other configuration for setup {}
  settings = {
    ["helm-ls"] = {
      logLevel = "info",
      valuesFiles = {
        mainValuesFile = "values.yaml",
        lintOverlayValuesFile = "values.lint.yaml",
        additionalValuesFilesGlobPattern = "values*.yaml"
      },
    },
    yamlls = {
      enabled = true,
      path = "yaml-language-server",
      config = {
        schemas = {
          kubernetes = "templates/**",
        },
      },
    },
  }
}

require('lspconfig').rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true
        },
      },
      procMacro = {
        enable = true
      },
    }
  }
})

-- lspconfig.nil_ls.setup({
--   settings = {
--     ["nil"] = {
--       nix = {
--         binary = "/run/current-system/sw/bin/nix",
--       }
--     },
--   }
-- })

require('lspconfig').nixd.setup({
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
        },
        home_manager = {
          expr = "(import <home-manager/modules> { configuration = ~/.dotfiles/home.nix; pkgs = import <nixpkgs> {}; }).options"
        },
        serit_platform_manifests = {
          expr = '(builtins.getFlake ("git+file://home/simkir/serit/k8s/serit-platform-manifests")).options'
        },
      },
    },
  },
})

local cmp_format = lsp_zero.cmp_format()

cmp.setup({
  formatting = cmp_format,
  snippet = {
    expand = function (args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp', },
    { name = 'luasnip' },
  }, {
    { name = 'buffer', },
  }),
  mapping = cmp.mapping.preset.insert({}),
})
