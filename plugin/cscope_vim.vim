let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
"let g:CscopeVim = 1
" control the tree level
let g:cscope_vim_level_limit = 4

" store content
let s:buffer = ''

python3 << EOF
import sys
from os.path import normpath, join
import vim
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import srcxray
#vim.current.buffer.append(buffer)
EOF


let s:MAIN_BUF_NAME = "CSCOPE_VIM"

function! CallTree(args, ...) abort
    let s:current_query = expand('<cword>')
python3 << EOF
buffer = srcxray.call_tree_wrapper()
vim.command("let s:buffer = '%s'"% buffer)
EOF
    let s:caller_win = {
                \ 'bufnr' : bufnr('%'),
                \ 'winid' : win_getid(winnr())}
    let winsize = 10
    let openpos = 'botright'

    "exec 'silent keepalt ' . openpos . winsize . 'split' .
                "\ (bufnr('CSCOPE_VIM') != -1 ? '+b'.bufnr('CSCOPE_VIM') : 'CSCOPE_VIM')
    "let cmd = 'silent keepalt' . openpos . winsize . 'split'
    exec 'silent keepalt topleft vertical 60 split ' .
        \ (bufnr('CSCOPE_VIM') != -1 ? '+b'.bufnr('CSCOPE_VIM') : 'CSCOPE_VIM')
    setl noreadonly
    setl buftype=acwrite
    setl cursorline
    "setbufvar(s:MAIN_BUF_NAME, '&modifiable', 1)

    "silent! undojoin | keepjumps 
    let modifiable_bak = getbufvar('%', '&modifiable')
    setl modifiable
    silent %delete _
    silent 0put = s:buffer
    silent $delete _
    call setbufvar('%', '&modifiable', modifiable_bak)
    call setbufvar('%', '&modified', 0)
    "call setqflist("ZX test\n")
endfunction

function! RefTree()
    python3 srcxray.referers_tree_wrapper("mm_init")
endfunction

func! s:SearchCwordCmd(type, word_boundary, to_exec)
    let cmd = ":\<C-U>" . a:type
    let cmd .= " " . expand('<cword>')
    let cmd .= a:to_exec ? "\<CR>" : " "
    echo cmd
    return cmd
    "if a:word_boundary
        "let cmd .= ' -R \b' .expand('<cword>') . '\b'
    "endif
endfunc

command! -nargs=* CallTree call CallTree(<q-args>)
command! -nargs=* RefTree call RefTree()



nnoremap <expr> <Plug>CscopeCallTree <SID>SearchCwordCmd('CallTree', 0, 0)

:nmap <leader>ct <Plug>CscopeCallTree <CR>
":map <Leader>ct :CallTree<CR>
":map <Leader>rt :RefTree<CR>
