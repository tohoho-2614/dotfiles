local telescope = require('telescope')
local actions = require('telescope.actions')
local opt = { silent=true, noremap=true}

require("telescope").load_extension "file_browser"

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["<C-c>"] = actions.close
      },
    },
  },
}

vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<CR>", opt)
vim.keymap.set("n", "<Leader>gf", ":Telescope git_files<CR>", opt)
vim.keymap.set("n", "<Leader>gs", ":Telescope git_status<CR>", opt)
vim.keymap.set("n", "<Leader>gr", ":Telescope live_grep<CR>", opt)
vim.keymap.set("n", "<Leader>fe", ":Telescope file_browser hidden=true initial_mode=normal<CR>", opt)
vim.keymap.set("n", "<Leader>h", ":Telescope oldfiles<CR>", opt)
