" Get the list of currently installed dotfiles modules
let dotfiles_modules = split(readfile($DOTFILES . '/.selected')[0])

call plug#begin('~/.vim/plugged')

" Load plugs from installed dotfiles modules
for module in dotfiles_modules
  let plug = $DOTFILES . '/modules/' . module . '/vim.plug'
  if filereadable(plug)
    exec "source " . plug
  endif
endfor

Plug 'altercation/vim-colors-solarized'
Plug 'dense-analysis/ale'
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

let mapleader=','

"""""""""""
" Plugins "
"""""""""""

" vim-colors-solarized
syntax enable
set background=dark
colorscheme solarized
highlight Normal ctermbg=16 guibg=#000000
highlight TabHighlight ctermbg=16 guibg=#000000 ctermfg=235 guifg=#262626
match TabHighlight /\t/

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' ㏇:'
let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.maxlinenr = ''
let g:airline_powerline_fonts = 1
let g:airline_theme='angr'

set statusline+=%#warningmsg#
set statusline+=%*

" nercommenter
filetype plugin on
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = {}

" ale
let g:ale_fixers = {}
let g:ale_linters = {}
let g:ale_fix_on_save = 1

"""""""""""
" General "
"""""""""""

nnoremap ; :
set clipboard=unnamedplus   " use system clipboard
if has('mac')
  set clipboard=unnamed   " use system clipboard
endif
set directory-=.        " don't store swapfiles in current directory
set nocompatible        " no vi compatibility
set number              " show line numbers
set relativenumber      " relative line numbers
set mouse=a             " enable mouse use in all modes
set ttymouse=sgr        " set mouse codes for iterm2, no idea why xterm2 fails but sgr works
set textwidth=80        " limit text to 80 chars
set colorcolumn=+1      " highlight textwidth column
highlight ColorColumn ctermbg=236   " Highlight color
highlight clear SignColumn
set term=xterm-256color
set expandtab              " expand tabs to spaces
set shiftwidth=2           " the # of spaces for indenting
set tabstop=2              " tabs indent only 2 spaces
set softtabstop=2          " tab key results in 2 spaces
set list                   " show trailing whitespace
set listchars=tab:▸\ ,trail:· " set tab and trailing space charcters
set scrolloff=4            " scroll three lines before horizontal border of window
set showcmd                " show command in the last line of the screen
set ignorecase             " case-insensitive search by default
set smartcase              " case-sensitive if pattern starts with cap character
set hlsearch               " highlight search matches
set hidden                 " allow buffers to be hidden and not abandoned
set splitbelow             " new split goes below
set splitright             " new split goes right
set laststatus=2           " always display the status line
let g:netrw_banner=0       " remove banner
let g:netrw_liststyle=1    " wide view
" https://stackoverflow.com/questions/8730702/how-do-i-configure-vimrc-so-that-line-numbers-display-in-netrw-in-vim
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro' " show line numbers
" Disable clipboard for netrw if using over SSH
" https://github.com/vim/vim/issues/7259#issuecomment-908196361
if $SSH_CLIENT != ""
  let g:netrw_clipboard=0
endif

" Search/replace visually selected text
" https://vim.fandom.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR><S-n>
vnoremap //r y/\V<C-R>=escape(@",'/\')<CR><CR><S-n>cgn

autocmd FileType * setlocal expandtab textwidth=80

" Easier splits
nnoremap <C-\> :vsp<CR>
nnoremap <C-_> :sp<CR>

" More natural split navigation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nnoremap <leader>w :w<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>n :nohlsearch<CR>
nnoremap <leader>e :Explore<CR>

" ctags
nnoremap <leader>m :!ctags -R .<CR>

" x
nnoremap <expr> <leader>rx ':xrestore ' . $DISPLAY . '<CR>'

" pretty json
autocmd Filetype json nnoremap <leader>p :%!npx prettier --stdin-filepath _file.json<CR>

" sort
vnoremap <leader>s :sort<CR>
nnoremap <leader>s :%!jq --sort-keys<CR>

" Trim trailing whitespace with <leader><space>
function! StripTrailing()
  let previous_search=@/
  let previous_cursor_line=line('.')
  let previous_cursor_column=col('.')
  %s/\s\+$//e
  let @/=previous_search
  call cursor(previous_cursor_line, previous_cursor_column)
endfunction
nmap <leader><space> :call StripTrailing()<CR>


function! BlockComment()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)

  " Check if exiting block comment exists and strip it away
  if getline(line_start-1) =~ '^#\+$'
    exe line_start-1 . "d"
    let line_start -= 1
    let line_end -= 1
  endif
  if getline(line_start) =~ '^#\+$'
    exe line_start . "d"
    call remove(lines, 0)
    let line_end -= 1
  endif

  let is_block = 1
  for line in lines
    if ! line =~ '^#'
      let is_block = 0
      break
    endif
  endfor

  let i = 0
  if is_block == 1
    for line in lines
      let line = substitute(line, '^# ', '', 'g')
      let line = substitute(line, ' *#$', '', 'g')
      let lines[i] = line
      let i += 1
    endfor
  endif

  if getline(line_end) =~ '^#\+$'
    exe line_end . "d"
    call remove(lines, len(lines) - 1)
    let line_end -= 1
  endif

  if getline(line_end+1) =~ '^#\+$'
    exe line_end+1 . "d"
  endif

  " Calculate the max line length to know how much padding to add
  let max_len = 0
  for line in lines
    if len(line) > max_len
      let max_len = len(line)
    endif
  endfor

  " Create the separator string for before/after block
  let sep = ""
  let sep_len = max_len + 3
  while sep_len >= 0
    let sep .= "#"
    let sep_len -= 1
  endwhile

  " Insert separator before and adjust line numbers
  call append(line_start-1, sep)
  let line_start += 1

  " Comment and pad the lines
  let i = line_start
  for line in lines
    let line = "# " . line
    let pad_len = max_len - len(line) + 1
    while pad_len >= 0
      let line = line . " "
      let pad_len -= 1
    endwhile
    let line = line . " #"
    call setline(i, line)
    let i += 1
  endfor

  " Insert separator after
  call append(line_end+1, sep)
endfunction
vnoremap <silent> cc :<c-u>call BlockComment()<CR>

" Source vim config from any dotfiles module
for module in dotfiles_modules
  let vimrc = $DOTFILES . '/modules/' . module . '/.vimrc'
  if module != 'vim' && filereadable(vimrc)
    exec "source " . vimrc
  endif
endfor
