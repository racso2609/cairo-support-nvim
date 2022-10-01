local autocmd = vim.api.nvim_create_autocmd
local utils = require("cairo-support-nvim.utils")

function HandleErr(errorPos, errorString)
  local bnr = 0
  local ns_id = vim.api.nvim_create_namespace("cairo_erros")
  local line_num = tonumber(errorPos[1]) - 1

  local opts = {
    id = 1,
    virt_text = { { errorString } },
    virt_text_pos = "overlay",
  }

  vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num, -1, opts)
end

function GetErrorInfo(data)
  local errorNumberLine = string.match(data, "%d+%p%d+")
  local errorPos = vim.split(errorNumberLine, ":")

  local startIndex = string.find(data, "[.]%s")
  local finishIndex = string.find(data, "return")

  local errorString = string.sub(data, startIndex + 1, finishIndex - 1)
  local result = {}
  table.insert(result, errorPos)
  table.insert(result, " " .. errorString)

  return result
end

function Format()
  autocmd("BufWritePost", {
    pattern = "*.cairo",
    callback = function()
      local filePath = vim.fn.expand("%:p")
      local currentPos = vim.api.nvim_win_get_cursor(0)

      local data = vim.api.nvim_exec("!cairo-format " .. filePath, true)

      local errorData = GetErrorInfo(data)

      if errorData[2] then
        HandleErr(errorData[1], errorData[2])
        return
      end
      local actualContent = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      local dataArr = vim.split(data, "\n")

      table.remove(dataArr, 1)
      table.remove(dataArr, 1)

      local dataIsEqToActualContent = utils.isEqArr(dataArr, actualContent)
      if not dataIsEqToActualContent then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, dataArr)
        vim.api.nvim_win_set_cursor(0, currentPos)
        print("formated...")
      end
    end,
  })
end

function Compile()
  autocmd("BufWritePost", {
    pattern = "*.cairo",
    callback = function()
      local filePath = vim.fn.expand("%:p")
      local handle = io.popen("starknet-compile " .. filePath .. " | grep '[0-9]:*'")
      if not handle then
        return
      end
      local data = handle:read("*a")
      handle:close()
      print(data)

      -- local findData = string.gmatch(data, "*")
      -- print("compiling...")
      -- print(findData)
      -- print(data)
    end,
  })
end

local M = {}
function M.setup(config)
  if config.format then
    Format()
  end
  -- if config.compile then
  -- Compile()
  -- end
end

-- Collect all key-value pairs from the given string into a table

return M
