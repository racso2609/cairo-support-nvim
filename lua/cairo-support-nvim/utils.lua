local utils = {}

function utils.showMessage(message)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, message)
	local opts = {
		relative = "cursor",
		width = 10,
		height = 2,
		col = 0,
		row = 1,
		anchor = "NW",
		style = "minimal",
	}
	local win = vim.api.nvim_open_win(buf, 0, opts)
	-- optional: change highlight, otherwise Pmenu is used
	vim.api.nvim_win_set_option(win, "winhl", "Normal:MyHighlight")
end

return utils
