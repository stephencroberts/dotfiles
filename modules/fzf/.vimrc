" call plug#begin('~/.vim/plugged')
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
" call plug#end()

let g:fzf_layout = { 'down': '40%' }
nmap <leader>t :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>f :Rg<CR>
