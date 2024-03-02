autocmd Filetype html nnoremap <leader>p :%!tidy -config ~/.tidyrc<CR>
" augroup gjs
  " autocmd!
autocmd BufNewFile,BufRead *.gjs set filetype=javascriptreact
  " autocmd BufNewFile,BufRead *.gjs set =javascript
" augroup END
" autoBufNewFile,BufRead tox.ini let b:ale_fixers = ["tox-ini-fmt"]
