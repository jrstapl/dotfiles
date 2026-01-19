vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


require("config.lazy")

vim.opt.shiftwidth = 4
-- vim.opt.clipboard = "unnamedplus" -- for using system clip with P, otherwise use <C-V> for system and p/P for vim buffer
vim.opt.number = true
vim.opt.relativenumber = true


vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.schedule(function()
				pcall(Snacks.dashboard())
			end)
		end
	end,
})

local job_id = 0
vim.keymap.set("n", "<space>to", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 5)

	job_id = vim.bo.channel
end)

local current_command = ""
vim.keymap.set("n", "<space>te", function()
	current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<space>tr", function()
	if current_command == "" then
		current_command = vim.fn.input("Command: ")
	end

	vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup {}


-- conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		go = { "goimports", "gofmt" }
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	}
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("ruff")
vim.lsp.enable("ols")
vim.lsp.enable("clangd")
vim.lsp.enable("cmake")
