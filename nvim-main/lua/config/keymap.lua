local map = vim.keymap.set

vim.g.mapleader = ' '

-- 在所有模式下生效的映射
map('i', 'jk', '<Esc>', {noremap = true}) -- 在插入模式下按下 jk 退出插入模式

-- 只在可视模式下生效的映射
map('v', '>', '>gv', {noremap = true}) -- 增强型右移操作：视觉选择后增加缩进并保持选择状态
map('v', '<', '<gv', {noremap = true}) -- 增强型左移操作：视觉选择后减少缩进并保持选择状态

--map('n', '<Space>w', ':w<CR>', {noremap = true})
--map('n', '<Space>q', ':q<CR>', {noremap = true})

-- NvimTree
map('n', '<Space>t', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
