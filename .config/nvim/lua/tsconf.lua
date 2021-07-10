require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    ignore_install = {
        "yaml",
    },
    highlight = {
        enable = true,
        disable = { "yaml" },
    },
}
