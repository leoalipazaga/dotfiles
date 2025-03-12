-- below configuration is overrite <C-leader> keymap
return {
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = {
      "TSInstall",
      "TSBufEnable",
      "TSBufDisable",
      "TSModuleInfo",
      "TSInstallFromGrammar",
    },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "astro",
        "svelte",
        "css",
        "html",
        "javascript",
        "tsx",
        "typescript",
        "yaml",
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
      },
    },
  },
}
