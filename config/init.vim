"
syntax enable
filetype plugin on

" vim-plug
call plug#begin('~/.config/nvim/autoload/plugged')

    "Color Theme
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Better Syntax Support
    " Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    " Plug 'jiangmiao/auto-pairs'

call plug#end()

" set t_Co=256
set background=dark
set mouse=a
set number
set ruler
set splitbelow 
set splitright
set nowrap
set colorcolumn=80
set hidden

" checkhealth - python, ruby and nodejs modules
let g:python_host_prog = expand("/usr/bin/python2.7")
let g:python3_host_prog = expand("/usr/bin/python3.7")
let g:loaded_ruby_provider = 0

source /usr/share/doc/fzf/examples/fzf.vim

syntax on
if (has("termguicolors"))
 set termguicolors
endif
" set notermguicolors
" let g:gruvbox_termcolors='16'
let g:gruvbox_italic='1'
let g:gruvbox_contrast_dark='hard'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16_gruvbox_dark_hard'
colorscheme gruvbox

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
