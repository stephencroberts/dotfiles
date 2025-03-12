let g:ale_fixers.sh = ['shfmt']
let g:ale_linters.sh = ['shellcheck']

function SetShellOptions()
  set expandtab
  set textwidth=80
endfunction
autocmd Filetype sh call SetShellOptions()
