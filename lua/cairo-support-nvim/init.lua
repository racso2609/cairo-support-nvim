print("cairo")
local autocmd = vim.api.nvim_create_autocmd
local M = {}
function M.setup()
	autocmd("BufWritePost", {
		pattern = "*.cairo",
		callback = function()
			local filePath = vim.fn.expand("%:p")
			vim.cmd("!cp " .. filePath .. " " .. filePath .. ".old")
			vim.cmd("!cairo-format " .. filePath .. ".old" .. " > " .. filePath)
		end,
	})
end

return M
