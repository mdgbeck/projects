
" add vim-plug
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/seoul256.vim'
Plug 'scrooloose/nerdtree'
Plug 'ajh17/VimCompletesMe'
Plug 'sillybun/vim-repl'
Plug 'wincent/terminus'
Plug 'mattn/emmet-vim', { 'for': ['html', 'xml'] }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" set global leader key
nnoremap <SPACE> <Nop>
let mapleader=" "
let localleader="\\"

nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <leader>q <c-w>w
" let g:sendtorepl_invoke_key = "<leader>e"

" add true color support
if (has("termguicolors"))
    set termguicolors
endif

if &background ==# 'dark'
    colo base16-gruvbox-dark-pale
else
    " colo base16-atelier-dune-light
    colo base16-solarized-light
endif


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

" remove underline from current line number
hi CursorLineNr cterm=bold

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


" set emmet leaderkey
let g:user_emmet_leader_key=','

" set f5 to insert date
inoremap <F5> <C-R>=strftime('%Y-%m-%d')<CR>

" set - to move line down one line and _ to move up
nnoremap - ddp 
nnoremap _ ddkP

" map ctrl d to delete current line in insert mode
inoremap <c-d> <esc>ddi
inoremap <c-f> <esc><c-w>za

nnoremap <leader>ve :split $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" place current work in quotes



iabbrev adn and
iabbrev @@ mdgbeck@gmail.com


" inoremap jk <esc>
" vnoremap jk <esc>  

" add html tag on both sides of list
vnoremap <leader>l I<li><esc><c-v>`>$A</li><esc>


" html features

augroup filetype_html
    autocmd!
    autocmd FileType html setlocal 
        \ tabstop=2
        \ shiftwidth=2
        \ softtabstop=2
        \ expandtab
    autocmd FileType html iabbrev <buffer> jalepeno jalepe&ntilde;o
    autocmd FileType html iabbrev <buffer> Jalepeno Jalepe&ntilde;o
    autocmd FileType html iabbrev <buffer> saute saut&eacute;
    autocmd FileType html iabbrev <buffer> Saute Saut&eacute;
augroup END

augroup filetype_python
    autocmd FileType python nnoremap <leader>c 0i#<space><esc>
augroup END

augroup filetype_r
    autocmd FileType r inoremap -- <space><-<space>
    autocmd FileType r inoremap ,, <space>%>%<space>
augroup END

" commands to send code to console
nnoremap <silent> <leader>rr :execute "normal Vgg<space>w"<cr>
nnoremap <silent> <leader>re :execute "normal V{<space>w"<cr>
nnoremap <silent> <leader>e :execute "normal {V}<space>w"<cr>

nnoremap <leader>= <c-w>5+
nnoremap <leader>- <c-w>5-
nnoremap <leader>t :REPLToggle<Cr>

" set terminal settings
" set termwinkey=<space>
" nnoremap <leader>t :term<cr>

nnoremap <leader>' :execute "normal \<Plug>Ysurround$'"<cr>
nnoremap <leader>" :execute "normal \<Plug>Ysurround$\""<cr>
nnoremap <leader>) :execute "normal \<Plug>Ysurround$)"<cr>
nnoremap <leader>( :execute "normal \<Plug>Ysurround$("<cr>

nnoremap <leader>h ^
nnoremap <leader>H 0
nnoremap <leader>l $

nnoremap <leader>n :set background=light<cr>:source $MYVIMRC<cr>
nnoremap <leader>b :set background=dark<cr>:source $MYVIMRC<cr>

" set in plugin files since re sourcing vimrc breaks call
" let g:repl_program = {
"     \   'python': 'ipython3',
"     \   'r': 'R --no-save',
"     \ }

" let g:repl_exit_commands = {
"     \   'radian': 'q()'
    \ }
" let NERDTreeMapActivateNode = 'e'
" let NERDTreeMapOpenExpl = 'E'

" make jumps larger than 3 counts as jumps
nnoremap <expr> j v:count ? (v:count > 3 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 3 ? "m'" . v:count : '') . 'k' : 'gk'

nnoremap <leader>p yy``P
nnoremap <leader>c :cd %:h<cr>
" test comment
