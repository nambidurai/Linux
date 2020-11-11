" vim-plug
call plug#begin('~/.config/nvim/autoload/plugged')
	
    Plug 'morhetz/gruvbox'
	" Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    " Plug 'jiangmiao/auto-pairs'

call plug#end()

" basic setup
set ruler         			            " Show the cursor position all the time
set cmdheight=1                         " More space for displaying messages
set iskeyword+=-                      	" treat dash separated words as a word text object"
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=4                           " Insert 2 spaces for a tab
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=0 						" Always display the status line
set number                              " Line numbers
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
"set noshowmode                          " We don't need to see things like -- INSERT -- anymore
"set noshowcmd
"set shortmess+=F
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
set colorcolumn=81
set nowrap
set guioptions+=b

" checkhealth - python, ruby and nodejs modules
let g:python_host_prog = expand("/usr/bin/python3.8")
let g:python3_host_prog = expand("/usr/bin/python3.8")
let g:loaded_ruby_provider = 0

syntax on
if (has("termguicolors"))
 set termguicolors
endif
set notermguicolors
let g:gruvbox_italic='1'
"let g:gruvbox_termcolors='16'
let g:gruvbox_contrast_dark='hard'
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

