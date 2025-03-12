let g:ale_fixers.css = ['prettier']
let g:ale_fixers.javascript = ['prettier']
let g:ale_fixers.javascriptreact = ['prettier']
let g:ale_fixers.typescript = ['prettier']
let g:ale_fixers.typescriptreact = ['prettier']
let g:ale_linters.javascript = ['eslint']
let g:ale_linters.javascriptreact = ['eslint']
let g:ale_linters.typescript = ['tsserver']
let g:ale_linters.typescriptreact = ['tsserver']

autocmd Filetype html nnoremap <leader>p :%!tidy -config ~/.tidyrc<CR>
" augroup gjs
  " autocmd!
autocmd BufNewFile,BufRead *.gjs set filetype=javascriptreact
  " autocmd BufNewFile,BufRead *.gjs set =javascript
" augroup END
" autoBufNewFile,BufRead tox.ini let b:ale_fixers = ["tox-ini-fmt"]
