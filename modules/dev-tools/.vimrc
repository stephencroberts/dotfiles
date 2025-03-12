" vivify
nmap <leader>mp :Vivify<CR>

function SetMarkdownOptions()
  set expandtab
  set textwidth=80
endfunction
autocmd Filetype md call SetMarkdownOptions()

" Use default mappings
let GtagsCscope_Auto_Map = 1
" Ignore case for tag search
let GtagsCscope_Ignore_Case = 1
let GtagsCscope_Auto_Load = 1
" Use 'vim -t', ':tag' and '<C-]>'
set cscopetag

" Enable incremental updates
let g:Gtags_Auto_Update = 1

" Source plugins
let gtags = $DOTFILES . '/modules/dev-tools/gtags.vim'
if filereadable(gtags)
  exec "source " . gtags
endif

let gtagscscope = $DOTFILES . '/modules/dev-tools/gtags-cscope.vim'
if filereadable(gtagscscope)
  exec "source " . gtagscscope
endif
