if true then
  return {}
end
return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- "jay-babu/mason-null-ls.nvim"
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")
      -- local mason_null_ls = require("mason-null-ls")
      mason.setup({})
      mason_lspconfig.setup({
        ensure_installed = {
          -- typescript
          "tsserver",
          "css-lsp",
          -- "cssmodule_ls",
          "emmet_ls",
          "astro",
          "graphql",
          "tailwindcss",
          -- yaml
          "hydra_lsp",
          -- toml
          "taplo",
          "svelte",
          "sqls",
          "html",
          "htmx",
          "prismals",
          -- json
          "biome",
          "lua",
          "gopls",
          "eslint",
        },
        automatic_installation = true,
      })
      mason_tool_installer.setup({
        ensure_installed = {
          "prismals",
          "prettier",
          "vimls",
          "stylua",
          "eslint_d",
          "oxlint",
        },
      })
    end,
  },
}
