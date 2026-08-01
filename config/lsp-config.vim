lua << EOF
local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
})
local servers = {
    'pylsp',
    'tsserver',
    'gopls',
    'rust_analyzer',
    'jdtls',
    'bashls',
    'yamlls',
    'jsonls',
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })
end
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})
EOF
