call plug#begin('~/.config/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'folke/which-key.nvim'
Plug 'numToStr/Comment.nvim'
call plug#end()
