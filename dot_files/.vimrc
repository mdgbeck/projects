

" add vim-plug
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" " Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'morhetz/gruvbox'
Plug 'christoomey/vim-tmux-navigator'

" " List ends here. Plugins become visible to Vim after this call.
call plug#end()

set termguicolors
set background=light
let g:gruvbox_contrast_light = 'medium'
let g:gruvbox_contrast_dark = 'light'
let g:gruvbox_bold = 0
colorscheme gruvbox
nnoremap <silent> <leader>bg :let &background = (&background == 'dark' ? 'light' : 'dark') \| colorscheme gruvbox<cr>

" cursor shape per mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" set global leader key
nnoremap <SPACE> <Nop>
let mapleader=" "
let localleader="\\"


set statusline=
set statusline+=%#PmenuSel#
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c

" enable syntax processing
syntax enable

" display line numbers
set number
set relativenumber
nnoremap <leader>m :set relativenumber!<cr>

" remove underline from current line number and current line highlight
hi CursorLineNr cterm=bold
hi CursorLine cterm=NONE

" display command in corner
set showcmd

set mouse=a

" highlight current line
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

set cursorline

" change search settings
set incsearch " search as characters are typed

nnoremap <leader>s :set hlsearch! hlsearch?<CR>

" set indention settings
filetype indent on

" set split to open below and right
set splitbelow
set splitright

" omni completion
filetype plugin on

" function that remove whitespace on saves
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfun

augroup whitespace
    autocmd!
    autocmd FileType php,ruby,python,r autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
augroup end

" set - to move line down one line and _ to move up
nnoremap - ddp
nnoremap _ ddkP

" map ctrl d to delete current line in insert mode
inoremap <c-d> <esc>ddi

nnoremap <leader>vv :tabnew $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

iabbrev adn and
iabbrev @@ mdgbeck@gmail.com


augroup filetype_html
    autocmd!
    autocmd FileType html setlocal
        \ tabstop=2
        \ shiftwidth=2
        \ softtabstop=2
        \ expandtab
augroup END

augroup filetype_python
    autocmd!
    autocmd FileType python syntax keyword PythonBuiltin NA
    autocmd FileType python setlocal tabstop=4
    autocmd FileType python setlocal shiftwidth=4
    autocmd FileType python setlocal softtabstop=4
    autocmd FileType python setlocal expandtab
augroup END

augroup allfiles
    autocmd!
    " sets files with no extension to be treated as text
    " allows resourcing of vimrc and files keeping their settings
    " if tab behavior set outside group sets all filetypes to that on resource
    autocmd BufNewFile,BufRead *.conf set syntax=text
    autocmd FileType text,sh,conf,vim,javascript setlocal tabstop=4
    autocmd FileType text,sh,conf,vim,javascript setlocal shiftwidth=4
    autocmd FileType text,sh,conf,vim,javascript setlocal softtabstop=4
    autocmd FileType text,sh,conf,vim,javascript setlocal expandtab
augroup END

nnoremap <leader>= <c-w>5+
nnoremap <leader>- <c-w>5-
nnoremap <leader>_ <c-w>5<
nnoremap <leader>+ <c-w>5>
nnoremap <leader>T :term<cr>



" make jumps larger than 3 counts as jumps
nnoremap <expr> j v:count ? (v:count > 2 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 2 ? "m'" . v:count : '') . 'k' : 'gk'

nnoremap <leader>c :cd %:h<cr>

" set tab switching to F3 - F4
tnoremap <F4> :tabnext<cr>
inoremap <F4> <esc>:tabnext<cr>
nnoremap <F4> :tabnext<cr>

tnoremap <F3> :tabprevious<cr>
inoremap <F3> <esc>:tabprevious<cr>
nnoremap <F3> :tabprevious<cr>

" move last y to xclipboard (copy paste)
nnoremap <silent> <leader>y :let @+=@"<cr>

" create mapping to print current directory
nnoremap <leader>p :pwd<cr>
nnoremap <leader>d :!cp % /run/media/michael/CIRCUITPY/code.py<cr>
