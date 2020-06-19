" first vimrc file

" add vim-plug
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'ajh17/VimCompletesMe'
Plug 'mattn/emmet-vim', { 'for': ['html', 'xml'] }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" set color to gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colo gruvbox

" set lightline color
let g:lightline = {'colorscheme': 'seoul256'}
" enable syntax processing
syntax enable

" display line numbers
set number

" display command in corner
set showcmd

" highlight current line
set cursorline

" change search settings
set incsearch " search as characters are typed

" set tab behavior
set tabstop=4 " number of displayed spaces when reading
set softtabstop=4 " number of inserted spaces when editing
set shiftwidth=4
set expandtab " sets tab to use spaces

" set indention settings
set smartindent
set autoindent

" set split to open below and right
set splitbelow
set splitright

" set global leader key
nnoremap <SPACE> <Nop>
let mapleader=" "
let localleader="\\"

" set emmet leaderkey
let g:user_emmet_leader_key=','

" set f5 to insert date
inoremap <F5> <C-R>=strftime('%Y-%m-%d')<CR>

" set - to move line down one line and _ to move up
nnoremap - ddp 
nnoremap _ ddkP

" map ctrl d to delete current line in insert mode
inoremap <c-d> <esc>ddi

" map ctrl i to upper
noremap <c-u> viwUlel
inoremap <c-u> <esc>viwU<esc>leli

nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" place current work in quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel


nnoremap <leader>w <c-w>w

iabbrev adn and
iabbrev @@ mdgbeck@gmail.com

vnoremap <leader>' <esc>`<i'<esc>`>i'<esc>
vnoremap <leader>" <esc>`<i"<esc>`>i"<esc>

inoremap jk <esc>
vnoremap jk <esc>  

" html features

augroup filetype_html
    autocmd!
    autocmd FileType html setlocal 
        \ tabstop=2
        \ shiftwidth=2
        \ softtabstop=2
        \ expandtab
    autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END




" python features
augroup filetype_python
    autocmd!
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType python iabbrev <buffer> iff if:<left>
augroup END

" operator mappings from book
" sets p to select in paranthesis
onoremap p i( 

" inside next / last paranthesis
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>

onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
