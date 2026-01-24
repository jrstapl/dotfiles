vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require "config.lazy"

vim.opt.shiftwidth = 4
-- vim.opt.clipboard = "unnamedplus" -- for using system clip with P, otherwise use <C-V> for system and p/P for vim buffer
vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- save from insert mode
vim.keymap.set("i", "<C-w>", "<esc><Cmd>w<CR>")

-- nice highlight for yanking blocks
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- disable numbering on neovim terminals
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.snacks_dashboard_opened then
      vim.g.snacks_dashboard_opened = true
      vim.schedule(function()
        pcall(Snacks.dashboard.open)
      end)
    end
  end,
})

-- disable ruff hover capabilities [https://docs.astral.sh/ruff/editors/setup/#neovim]
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})

vim.diagnostic.config { virtual_text = true, virtual_lines = false }

vim.keymap.set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.keymap.set({ "n", "i", "s" }, "<esc>", function()
  vim.cmd "noh"
  return "<esc>"
end, { expr = true, desc = "Clear search highlighting from last search" })

local job_id = 0
vim.keymap.set("n", "<space>to", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
end)

local current_command = ""
vim.keymap.set("n", "<space>te", function()
  current_command = vim.fn.input "Command: "
end)

vim.keymap.set("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input "Command: "
  end

  vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup {}

--buffer keybinds
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- conform
require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    go = { "goimports", "gofmt" },
    odin = { "odinfmt" },
  },
  formatters = {
    odinfmt = {
      -- Change where to find the command if it isn't in your path.
      command = "odinfmt",
      args = { "-stdin" },
      stdin = true,
    },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
}

-- treesitter

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf }
  end,
})

vim.lsp.enable "lua_ls"
vim.lsp.enable "gopls"
vim.lsp.enable "ruff"
vim.lsp.enable "ols"
vim.lsp.enable "clangd"
vim.lsp.enable "cmake"
vim.lsp.enable "pyright"
