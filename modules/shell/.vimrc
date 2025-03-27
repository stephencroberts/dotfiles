let g:ale_fixers.sh = ['shfmt']
let g:ale_linters.sh = ['shellcheck']

autocmd FileType sh setlocal expandtab textwidth=80
