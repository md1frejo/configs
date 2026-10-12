vim.lsp.enable({
    "lua_ls",
    "tsgo",
		"clojure",
		"pyright",
		"calngd",
		"bashls",
    "html",
		"cssls",
		"svelte",
		"rust_analyzer"
})

vim.diagnostic.config({ virtual_text = true, })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true,
            })
        end
    end,
})

vim.cmd("set completeopt+=noselect")
