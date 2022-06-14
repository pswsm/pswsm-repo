" pswsm config
" 
let g:ale_completion_enabled = 1
" source plugs
so ~/.config/nvim/plug.vim

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

let g:dashboard_default_executive ='fzf'

let g:python3_host_prog = '/home/pswsm/.virtualenvs/nvim/bin/python'
"remaps
tnoremap <Esc> <C-\><C-n>

nmap <A-t> :sp term://zsh<CR>i

nmap <A-h> :w<CR>:bdelete<CR>:Dashboard<CR>

set smarttab
set tabstop=4
set shiftwidth=4
set expandtab

"moviments
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

lua << EOF
require"fidget".setup{}
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        'bash',
        'css',
        'html',
        'javascript',
        'markdown',
        'cpp',
        'rust',
        'python',
        'typescript'
        },
    highlight = { enable = true },
})

EOF
