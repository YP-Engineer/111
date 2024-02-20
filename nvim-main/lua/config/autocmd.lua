vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.c',
  callback = function()
    local lines = {
      '#include <myselfc.h>',
      '',
      'int main(int argc, char *argv[]){',
      '    ',
      '    ',
      '    return 0;',
      '}',
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
    vim.cmd('normal! 3G')
    vim.cmd('startinsert!')
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end
})
