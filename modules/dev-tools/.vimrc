" markdown preview
let g:mkdp_echo_preview_url = 1
let g:mkdp_port = '9038'
nmap <leader>mp :MarkdownPreview<CR>
nmap <leader>mps :MarkdownPreviewStop<CR>

" Use default mappings
let GtagsCscope_Auto_Map = 1
" Ignore case for tag search
let GtagsCscope_Ignore_Case = 1
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
