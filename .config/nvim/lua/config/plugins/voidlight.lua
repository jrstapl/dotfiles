return {
  "christerso/voidlight-lazyvim-theme",
  name = "voidlight",
  lazy = false,
  priority = 1000,
  config = function()
    require("voidlight").setup()
    vim.cmd.colorscheme "voidlight"
  end,
}
