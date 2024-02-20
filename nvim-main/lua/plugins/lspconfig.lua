require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "clangd",
    "cmake",
    --"jsonls" -- should install npm 
  }
})

require('lspconfig').cmake.setup {}
require('lspconfig').clangd.setup {
  filetypes = { "c", "cpp", "objc", "objcpp" },
  cmd = {
    "clangd",
    "--header-insertion=never", -- 禁止在编辑时自动插入头文件
    "--pch-storage=memory", -- 在内存中存储预编译头信息
    "--background-index", -- 启用后台索引
    "--clang-tidy", -- 如果安装了clang-tidy，则启用代码风格检查和修复建议
    "--completion-style=detailed", -- 使用详细的补全提示
    --"--query-driver=/usr/bin/clang",
  },
  root_markers = { ".git/", "compile_commands.json",".clangd" },

  settings = {
    clangd = {
      --compileCommands = "${workspaceFolder}/build/compile_commands.json",
      -- 默认的索引路径
      index = {
        threads = 0, -- 使用所有可用的硬件线程
        background = true, -- 在后台进行索引
        c = true,
        cxx = true, -- 索引C++代码
        paths = { "${workspaceFolder}" }, -- 要索引的路径
      },
      -- 代码完成
      completion = {
        detailed = true, -- 显示详细的完成信息
        placeholder = true, -- 显示占位符
        signatures = true, -- 显示函数签名的补全
      },
      signatures = {
        enabled = true, -- 启用自动签名补全
        insertfullSignature = true, -- 插入完整的签名
        inserttrailingWhitespace = true, -- 在签名后插入空格
      },
      -- 诊断
      diagnostics = {
        enable = true, -- 启用诊断
        warningsAsErrors = "None", -- 将警告视为错误
        SuppressSystemWarnings = false, -- 抑制系统头文件中的警告
      },
      -- 格式化
      format = {
        style = "file", -- 使用文件中的风格设置
        fallbackStyle = "LLVM", -- 如果文件中没有风格设置，则使用LLVM风格
      },
      -- 其他设置...
    },
  },
  -- 可以根据需要添加其他 lspconfig 的选项
  -- 例如，on_attach 函数可以在这里定义
}




require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      hint = { enable = true },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}



-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- neovim 0.10.0 inlay hints
if vim.lsp.inlay_hint then
  vim.keymap.set(
  "n",
  "<leader>lh",
  function()
    if vim.lsp.inlay_hint.is_enabled(0) then
      vim.lsp.inlay_hint.enable(0, false)
      else
      vim.lsp.inlay_hint.enable(0, true)
    end
  end,
  { desc = "Toggle Inlay Hints" }
  )
end
