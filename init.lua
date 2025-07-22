vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.g.mapleader = " "

-- Local config
vim.o.exrc = true

vim.opt.clipboard = "unnamedplus"

vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.list = true
vim.opt.listchars = { trail = '_', tab = '>~' }

vim.opt.signcolumn = "yes"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.wo.number = true
vim.wo.relativenumber = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "latte",
        transparent_background = true,
      })

      vim.cmd.colorscheme "catppuccin"
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      api = require("nvim-tree.api")

      vim.keymap.set('n', '<leader>tt', api.tree.toggle, {})

      require("nvim-tree").setup({})
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({})

      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

      vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
      vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, {})
      vim.keymap.set('n', 'gr', builtin.lsp_references, {})
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function()
      vim.api.nvim_set_keymap("n", "<C-\\>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
      vim.api.nvim_set_keymap("n", "<C-k>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
      vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
      vim.api.nvim_set_keymap("n", "<C-l>", [[<Cmd>lua require"fzf-lua".live_grep_glob()<CR>]], {})
      vim.api.nvim_set_keymap("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
      require("fzf-lua").setup({
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "go", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "rust" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {});
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {});
      vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, {});
      vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, {});

      lspconfig.gopls.setup({
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
        }),
        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
          },
          { { name = "buffer" } }
        ),
      })
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    "numToStr/Comment.nvim",
    opts = {
    },
    config = function()
      require('Comment').setup()
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    config = function()
      vim.lsp.inlay_hint.enable(true)
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              rustfmt = {
                extraArgs = { "+nightly" },
              },
            },
          },
        },
      }
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      if vim.loop.os_uname().sysname == "Darwin" then
        vim.g.vimtex_view_method = "skim"
      else
        vim.g.vimtex_view_method = "zathura"
      end
    end,
  },

  {
    "whonore/Coqtail",
  },
})
