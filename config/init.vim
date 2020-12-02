"
syntax enable
filetype plugin on
set t_Co=256
set background=dark
set mouse=a
set number
set ruler
set splitbelow 
set splitright
set nowrap

source /usr/share/doc/fzf/examples/fzf.vim

" toggle terminal
let s:term_buf = 0
let s:term_win = 0
function! TermToggle(height)
    if win_gotoid(s:term_win)
        hide
    else
        new terminal
        exec "resize " . a:height
        try
            exec "buffer " . s:term_buf
            exec "bd terminal"
        catch
            call termopen($SHELL, {"detach": 0})
            let s:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
            set nocursorline
        endtry
        startinsert!
        let s:term_win = win_getid()
    endif
endfunction
nnoremap <silent> <F2> :call TermToggle(12)<CR>
inoremap <silent> <F2> <Esc>:call TermToggle(12)<CR>
tnoremap <silent> <F2> <C-\><C-n>:call TermToggle(12)<CR>
