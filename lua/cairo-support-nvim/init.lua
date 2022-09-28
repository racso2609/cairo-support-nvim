print("cairo")
local autocmd = vim.api.nvim_create_autocmd
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

			-- vim.cmd("!cp " .. filePath .. " " .. filePath .. ".old")
			-- vim.cmd("!cairo-format " .. filePath .. ".old" .. " > " .. filePath)
			-- vim.cmd("!rm " .. filePath .. ".old")
		end,
	})
end

print(vim.fn.expand("%:.:h:h"))

return M
