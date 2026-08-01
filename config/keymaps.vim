let mapleader = " "
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh :Telescope help_tags<CR>
nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>l :LspInfo<CR>
nnoremap gd :lua vim.lsp.buf.definition()<CR>
nnoremap gr :lua vim.lsp.buf.references()<CR>
nnoremap K :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>t :split term://bash<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>/ :CommentToggle<CR>
vnoremap <leader>/ :CommentToggle<CR>
