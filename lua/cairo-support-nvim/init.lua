print("cairooooo")
local autocmd = vim.api.nvim_create_autocmd
local utils = require("cairo-support-nvim.utils")
local FORMAT_COMMAND = "!cairo-format "
local COMPILE_COMMAND = "!starknet-compile "

function HandleErr(errorPos, errorString)
  local bnr = 0
  local ns_id = vim.api.nvim_create_namespace("cairo_erros")
  local line_num = errorPos[1] - 1

  local opts = {
    id = 1,
    virt_text = { { errorString, vim.api.nvim_get_hl_id_by_name("error") } },
  }

  vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num, -1, opts)
end

function GetErrorInfo(data)
  local existPyenv = string.find(data, "pyenv")
  if existPyenv then
    local result = {}
    local errorPos = {}
    table.insert(errorPos, 1)
    table.insert(errorPos, 1)
    table.insert(result, errorPos)
    table.insert(result, "Active pyenv")
    return result
  end
  local errorNumberLine = string.match(data, "%d+[:]%d+")
  if not errorNumberLine then
    return
  end
  -- print("numberLine", errorNumberLine)
  local errorSplit = vim.split(errorNumberLine, ":")
  local errorPos = {}
  for _, value in ipairs(errorSplit) do
    table.insert(errorPos, tonumber(value))
  end

  local startIndex = string.find(data, "[.]%s")
  local finishIndex = string.find(data, "[.]\n")

  if not startIndex or not finishIndex then
    return
  end

  local result = {}
  table.insert(result, errorPos)
  local errorString = string.sub(data, startIndex + 1, finishIndex - 1)
  table.insert(result, " " .. errorString)
  -- print("errorString", errorString)

  return result
end

function Format()
  autocmd("BufWritePost", {
    pattern = "*.cairo",
    callback = function()
      local filePath = vim.fn.expand("%:p")
      local currentPos = vim.api.nvim_win_get_cursor(0)

      local data = vim.api.nvim_exec(FORMAT_COMMAND .. filePath, true)

      local errorData = GetErrorInfo(data)

      if errorData then
        -- HandleErr(errorData[1], errorData[2])
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
      print("compiling...")
      local data = vim.api.nvim_exec(COMPILE_COMMAND .. filePath, true)
      local errorData = GetErrorInfo(data)
      if errorData then
        HandleErr(errorData[1], errorData[2])
        return
      end
    end,
  })
end

local M = {}
function M.setup(config)
  if config.format then
    Format()
  end
  if config.compile then
    Compile()
  end
end

-- Collect all key-value pairs from the given string into a table

return M
