if true then
  return {}
end
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure opts exists
      opts.servers = opts.servers or {}
      -- Default capabilities applied to ALL servers
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].capabilities = opts.servers["*"].capabilities or vim.lsp.protocol.make_client_capabilities()

      -- This is the important part for the Position Encodings warning
      opts.servers["*"].capabilities.general = opts.servers["*"].capabilities.general or {}
      opts.servers["*"].capabilities.general.positionEncodings = { "utf-16" }

      return opts
    end,
  },
}
