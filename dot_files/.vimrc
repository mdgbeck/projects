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

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" set color to seoul256
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
