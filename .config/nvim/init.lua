
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

vim.opt.termguicolors = true
require("bufferline").setup{}

local wanted_lsp = {"lua_ls", "gopls", "ruff", "ols", "clangd", "cmake"}



local ex_is_available = function(ex)

  local which = "which"
  if  this_sys == "windows" then 
    which = "where"
  end
  
  local output = vim.fn.system(which .. " " .. ex)
  if vim.v.shell_error == 0 then 
    return true 
  else
    return false 
  end 
end


local set_installer = function()
  local installer = "brew"
  if this_sys == "Windows" then
    if ex_is_available("scoop") then 
      installer = "scoop"
    elseif ex_is_available("choco") then 
      installer = "choco"
    else
      print("No package manager available for windows, please install or use dedicated tool {i.e. go -> gopls, cargo -> ruff, etc...}")
      return nil 
    end
  end
  if this_sys == "Linux" then 
    if ex_is_available("brew") then 
      goto continue
    elseif ex_is_available("pacman") then
      installer = "pacman"
    elseif ex_is_available("apt") then 
      installer = "apt"
    elseif ex_is_available("dnf") then 
      installer = "dnf"
    elseif ex_is_available("yum") then 
      installer = "yum"
    else
      print("No recognized package manager available")
      return nil
    end
    ::continue::
  end
  return installer
end

local ensure_installed = function(lsp)
  local uv = vim.uv 
  if uv == nil then uv = vim.loop end
  local this_sys = uv.os_uname().sysname

  if lsp == "lua_ls" then 
    lsp = "lua-language-server"
  end

  if ex_is_available(lsp) then 
    if lsp == "lua-language-server" then 
      lsp = "lua_ls"
    end
    vim.lsp.enable(lsp)
  else 
    print(lsp .. " is not available attempting to install...")
    local installer = set_installer()
    if installer == nil then 
      return nil
    end
    local install_cmd = installer
    if installer == "pacman" then 
      install_cmd = install_cmd .. " -Syu"
    else 
      install_cmd = install_cmd .. " install"
    end 

    local output = vim.fn.system(install_cmd .. " " .. lsp)

    if vim.v.shell_error ~= 0 then 
      print("Unable to install " .. lsp)
      print(output)
    end
  end
end 

for i, lsp in ipairs(wanted_lsp) do
  ensure_installed(lsp)
end




