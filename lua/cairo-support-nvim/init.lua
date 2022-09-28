print("cairo")
local autocmd = vim.api.nvim_create_autocmd
local utils = require("cairo-support-nvim.utils")

local M = {}
function M.setup()
	autocmd("BufWritePost", {
		pattern = "*.cairo",
		callback = function()
			local filePath = vim.fn.expand("%:p")

			local handle = io.popen("cairo-format " .. filePath)
			if not handle then
				return
			end

			local data = handle:read("*a")
			handle:close()
			print(data)
			-- local findFilePath = string.find(data, filePath)
			local actualContent = vim.api.nvim_buf_get_lines(0, 0, -1, false)

			if data ~= actualContent then
				local dataArr = utils.splitString(data)
				vim.api.nvim_buf_set_lines(0, 0, -1, false, dataArr)
				print("qlq")
			end
			-- vim.cmd("!cp " .. filePath .. " " .. filePath .. ".old")
			-- vim.cmd("!cairo-format " .. filePath .. ".old" .. " > " .. filePath)
			-- vim.cmd("!rm " .. filePath .. ".old")
		end,
	})
end
print(vim.fn.expand("%:.:h:h"))

return M
