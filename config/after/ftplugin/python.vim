setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
autocmd BufWritePre *.py :!black %
nnoremap <buffer> <leader>r :!python %<CR>
nnoremap <buffer> <leader>i :!ipython<CR>
let b:lsp_client = 'pylsp'
