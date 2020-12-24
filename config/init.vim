"
" vim python, ruby and nodejs modules - :checkhealth
let g:python_host_prog = expand("/usr/bin/python2.7")
let g:python3_host_prog = expand("/usr/bin/python3.7")
let g:loaded_ruby_provider = 0

" vim-plug
call plug#begin('~/.config/nvim/autoload/plugged')

    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'preservim/nerdtree'

call plug#end()

" vim-plug automatically executes both these settings
" filetype plugin indent on
" syntax enable
" syntax on - not required

" FZF plugin
source /usr/share/doc/fzf/examples/fzf.vim

"UI and layout settings
set number
set ruler
set splitbelow 
set splitright
set nowrap
set colorcolumn=80

"tabs and indenting
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent

"searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"buffer
set hidden

"system
"change directory to current file path in the buffer
set autochdir
" enable mouse
set mouse=a
" Yank and paste with the system clipboard
set clipboard=unnamed

"color themes
set termguicolors
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16_gruvbox_dark_hard'

" terminal toggle function
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
        endtry
        startinsert!
        let s:term_win = win_getid()
    endif
endfunction
nnoremap <silent> <F2> :call TermToggle(12)<CR>
inoremap <silent> <F2> <Esc>:call TermToggle(12)<CR>
tnoremap <silent> <F2> <C-\><C-n>:call TermToggle(12)<CR>
