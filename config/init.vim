set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set wrap
set mouse=a
set clipboard=unnamedplus
set termguicolors
set lazyredraw
set updatetime=300
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keymaps.vim
source ~/.config/nvim/lsp-config.vim
colorscheme gruvbox
set background=dark
set laststatus=2
set statusline=%F%m%r%h%w\ [%Y]\ [%{&ff}]\ [%{&ft}]\ %=%l/%L\ %p%%
augroup termuxvim
    autocmd!
    autocmd BufWritePre *.py,*.js,*.ts,*.go,*.rs :call FormatCode()
augroup END
function! FormatCode()
    if &ft == 'python'
        execute 'silent !black %'
    elseif &ft == 'javascript' || &ft == 'typescript'
        execute 'silent !prettier --write %'
    elseif &ft == 'go'
        execute 'silent !gofmt -w %'
    endif
    edit
endfunction
