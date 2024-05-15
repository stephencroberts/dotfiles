" let g:ale_fixers['rust'] = ['rustfmt']
let g:ale_linters['rust'] = []
" let g:ale_rust_rustfmt_options = '--edition 2021'
" let g:ale_rust_analyzer_config = {
"   \ 'diagnostics': { 'disabled': ['unresolved-import'] },
"   \ 'cargo': { 'loadOutDirsFromCheck': v:true },
"   \ 'procMacro': { 'enable': v:true },
"   \ 'checkOnSave': { 'command': 'clippy', 'enable': v:true }
"   \ }

" Stuff to try
" let g:ale_completion_enabled = 1 
" let g:ale_linters = {'rust': ['analyzer', 'cargo']}
" let g:ale_fixers = { 
"     \'rust': ['rustfmt'],
"     \'javascript': ['prettier'],
" \}
" let g:ale_rust_rustfmt_options = '--edition 2018'
" let g:ale_rust_cargo_use_clippy = 1
" let g:ale_rust_cargo_check_tests = 1 
" let g:ale_rust_cargo_check_examples = 1

" nmap <silent> <Leader>f <Plug>(ale_fix)
" nmap <silent> <Leader>l <Plug>(ale_lint)
" nmap <silent> <Leader>r <Plug>(ale_find_references
"
" Set edition for rustfmt based on cargo.toml
" let b:rust_default_edition = '2018'
" let b:rust_edition = trim(system('cargo get --edition 2>/dev/null'))
" if v:shell_error > 0 || len(b:rust_edition) == 0
"     let b:rust_edition = b:rust_default_edition
" endif

" let g:ale_rust_rustfmt_options = '--edition ' .. b:rust_edition
