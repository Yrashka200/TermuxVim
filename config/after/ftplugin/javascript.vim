setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx :!prettier --write %
nnoremap <buffer> <leader>r :!node %<CR>
nnoremap <buffer> <leader>d :!npm run dev<CR>
