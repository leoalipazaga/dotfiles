-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client.name == "biome" then
      local ft = vim.bo[args.buf].filetype
      local js_ts = {
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
      }
      if js_ts[ft] then
        vim.lsp.buf_detach_client(args.buf, client.id)
      end
    end
  end,
})
