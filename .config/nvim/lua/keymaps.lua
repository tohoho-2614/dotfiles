vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "<Leader>o", "<C-w><C-w>")

vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "H", "^")
vim.keymap.set("v", "L", "$")
vim.keymap.set("v", "H", "^")
vim.keymap.set("s", "L", "L")
vim.keymap.set("s", "H", "H")

vim.keymap.set("n", "J", "5j")
vim.keymap.set("n", "K", "5k")
vim.keymap.set("v", "J", "5j")
vim.keymap.set("v", "K", "5k")
vim.keymap.set("s", "J", "J")
vim.keymap.set("s", "K", "K")

vim.keymap.set("n", "<Leader>P", "\"0P")
vim.keymap.set("n", "<Leader>p", "\"0p")
vim.keymap.set("n", "<Leader>r", "ciw<C-r>0<Esc>b")

vim.keymap.set("i", "<C-c>", "<C-[>")
vim.keymap.set("i", "<C-[>", "<C-c>")
