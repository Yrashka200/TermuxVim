setlocal tabstop=4
setlocal shiftwidth=4
setlocal noexpandtab
autocmd BufWritePre *.go :!gofmt -w %
nnoremap <buffer> <leader>r :!go run %<CR>
nnoremap <buffer> <leader>b :!go build<CR>
nnoremap <buffer> <leader>t :!go test<CR>
