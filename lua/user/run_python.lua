M = {}
M.run_python_and_paste_output_into_buffer = function()
  if vim.bo.filetype ~= "python" then
    print "Current buffer is not a Python file!"
    return
  end

  local file_contents = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Write to a temp file and run that file, saving output
  local temp_file = vim.fn.tempname() .. ".py"
  local temp_output = vim.fn.tempname()
  vim.fn.writefile(file_contents, temp_file)

  local cmd = "python3 " .. temp_file .. " > " .. temp_output .. " 2>&1"
  os.execute(cmd)

  local output = vim.fn.readfile(temp_output) -- Read the output
  vim.fn.delete(temp_file)
  vim.fn.delete(temp_output)

  -- Append the output as comments to the buffer
  if #output > 0 then
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { "", "# Output:" })
    for _, line in ipairs(output) do
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { "# " .. line })
    end
  end
end
return M
