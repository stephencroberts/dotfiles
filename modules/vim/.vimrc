call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dense-analysis/ale'
Plug 'edkolev/tmuxline.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdcommenter'
Plug 'skwp/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'yuezk/vim-js'
call plug#end()

let mapleader=','


"""""""""""
" Plugins "
"""""""""""

" vim-colors-solarized
syntax enable
set background=dark

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='papercolor'

set statusline+=%#warningmsg#
set statusline+=%*

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" nercommenter
filetype plugin on
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'

" fzf
nmap <leader>t :FZF<CR>
nmap <leader>b :Buffers<CR>

" vim-gitgutter
nmap <leader>g :GitGutterToggle<CR>

" ale
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'css': ['prettier'],
\}

let g:ale_fix_on_save = 1

"""""""""""
" General "
"""""""""""

nnoremap ; :
set clipboard=unnamed   " use system clipboard
set directory-=.        " don't store swapfiles in current directory
set nocompatible        " no vi compatibility
set number              " show line numbers
set relativenumber      " relative line numbers
set mouse=a             " enable mouse use in all modes
set ttymouse=xterm2     " set mouse codes for iterm2
set textwidth=80        " limit text to 80 chars
set colorcolumn=+1      " highlight textwidth column
highlight ColorColumn ctermbg=236   " Highlight color
set term=screen-256color
set expandtab           " expand tabs to spaces
set shiftwidth=2        " the # of spaces for indenting
set tabstop=2           " tabs indent only 2 spaces
set softtabstop=2       " tab key results in 2 spaces
set list                " show trailing whitespace
set listchars=tab:▸\ ,trail:· " set tab and trailing space charcters
set scrolloff=4         " scroll three lines before horizontal border of window
set showcmd             " show command in the last line of the screen
set ignorecase          " ignore case in a pattern
set smartcase           " case-sensitive if pattern starts with cap character
set hlsearch            " highlight search matches
set hidden              " allow buffers to be hidden and not abandoned
set splitbelow          " new split goes below
set splitright          " new split goes right
set laststatus=2        " always display the status line
let g:netrw_banner=0    " remove banner
let g:netrw_liststyle=3 " tree view

function SetDefaultOptions()
  set expandtab
  set textwidth=80
endfunction
autocmd Filetype * call SetDefaultOptions()

function SetShellOptions()
  set expandtab
  set textwidth=80
endfunction
autocmd Filetype sh call SetShellOptions()

function SetGoOptions()
  set noexpandtab
  set textwidth=100
endfunction
autocmd Filetype go call SetGoOptions()

function SetMarkdownOptions()
  set expandtab
  set textwidth=80
endfunction
autocmd Filetype md call SetMarkdownOptions()

function SetDockerfileOptions()
  set expandtab
  set textwidth=0
endfunction
autocmd BufNewFile,BufRead Dockerfile call SetDockerfileOptions()

" Easier splits
nnoremap <C-\> :vsp<CR>
nnoremap <C-_> :sp<CR>

" More natural split navigation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nnoremap <leader>w :q<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>n :nohlsearch<CR>
nnoremap <leader>e :Explore<CR>

" ctags
nnoremap <leader>m :!ctags -R .<CR>

" pretty json
nnoremap <leader>p :%!python -c "import json, sys, collections; print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=2)"<CR>

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
