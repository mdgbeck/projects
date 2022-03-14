
" add vim-plug
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" " Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
" Plug 'ycm-core/YouCompleteMe'
Plug 'ajh17/VimCompletesMe'
Plug 'tmsvg/pear-tree'
Plug 'wincent/terminus', {'frozen': 1}
Plug 'sillybun/vim-repl', { 'frozen': 1}
Plug 'mattn/emmet-vim', { 'for': ['html', 'xml'] }

" " List ends here. Plugins become visible to Vim after this call.
call plug#end()

" set global leader key
nnoremap <SPACE> <Nop>
let mapleader=" "
let localleader="\\"

nnoremap <leader>d :NERDTreeToggle<cr>
" let g:sendtorepl_invoke_key = "<leader>e"

" add true color support
if (has("termguicolors"))
    set termguicolors
endif

" switched for easy toggle
if &background ==# 'dark'
    " colo base16-atelier-dune-light
    colo base16-solarized-light
else
    colo base16-gruvbox-dark-pale
endif

nnoremap <leader>b :set background=light<cr>:source $MYVIMRC<cr>
nnoremap <leader>n :set background=dark<cr>:source $MYVIMRC<cr>

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
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

set cursorline

" change search settings
set incsearch " search as characters are typed

" set indention settings
" set smartindent
" set autoindent
filetype indent on

" set split to open below and right
set splitbelow
set splitright

" omni completion
filetype plugin on
" set omnifunc=syntaxcomplete#Complete

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
    
" set emmet leaderkey
let g:user_emmet_leader_key=','

" set f2 to insert date
inoremap <F2> <C-R>=strftime('%Y-%m-%d')<CR>


" set - to move line down one line and _ to move up
nnoremap - ddp 
nnoremap _ ddkP

" map ctrl d to delete current line in insert mode
inoremap <c-d> <esc>ddi
inoremap <c-f> <esc><c-w>za

nnoremap <leader>vv :split $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

iabbrev adn and
iabbrev @@ mdgbeck@gmail.com

" inoremap jk <esc>
" vnoremap jk <esc>  

" add html tag on both sides of list
vnoremap <leader>l I<li><esc><c-v>`>$A</li><esc>

" commands to write data files to csvs
command! -nargs=1 Rdata1 execute 
	\ "normal o<space>%>%<space>write_csv('~/.data/d1.csv')<esc>0i<args><esc><leader>w?d1.csv<cr>ddk"
command! -nargs=1 Rdata2 execute 
	\ "normal o<space>%>%<space>write_csv('~/.data/d2.csv')<esc>0i<args><esc><leader>w?d2.csv<cr>ddk"
command! -nargs=1 Rdata3 execute 
	\ "normal o<space>%>%<space>write_csv('~/.data/d3.csv')<esc>0i<args><esc><leader>w?d3.csv<cr>ddk"
command! -nargs=1 Rdata4 execute 
	\ "normal o<space>%>%<space>write_csv('~/.data/d4.csv')<esc>0i<args><esc><leader>w?d4.csv<cr>ddk"

command! -nargs=1 Pydata1 execute 
	\ "normal o.to_csv(r'~/.data/d1.csv')<esc>^i<args><esc><leader>w?d1.csv<cr>ddk"
command! -nargs=1 Pydata2 execute 
	\ "normal o.to_csv(r'~/.data/d2.csv')<esc>^i<args><esc><leader>w?d2.csv<cr>ddk"
command! -nargs=1 Pydata3 execute 
	\ "normal o.to_csv(r'~/.data/d3.csv')<esc>^i<args><esc><leader>w?d3.csv<cr>ddk"
command! -nargs=1 Pydata4 execute 
	\ "normal o.to_csv(r'~/.data/d4.csv')<esc>^i<args><esc><leader>w?d4.csv<cr>ddk"
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
    autocmd!
    autocmd FileType python syntax keyword PythonBuiltin NA 
    autocmd FileType python setlocal tabstop=4
    autocmd FileType python setlocal shiftwidth=4
    autocmd FileType python setlocal softtabstop=4
    autocmd FileType python setlocal expandtab
    "autocmd FileType python setlocal textwidth=80
    " autocmd FileType python nnoremap <leader>rw <c-w>j.to_csv(r'~/data_view.csv')<home>
    autocmd FileType python nnoremap <leader>1 :Pydata1<space>
    autocmd FileType python nnoremap <leader>2 :Pydata2<space>
    autocmd FileType python nnoremap <leader>3 :Pydata3<space>
    autocmd FileType python nnoremap <leader>4 :Pydata4<space>
    autocmd FileType python nnoremap <leader>rq <c-w>j<c-r>to_csv<cr><cr><c-w>k
augroup END

augroup filetype_r
    autocmd!
    autocmd FileType r setlocal 
        \ tabstop=2
        \ shiftwidth=2
        \ softtabstop=2
        \ expandtab
    autocmd FileType r inoremap -- <space><-<space>
    autocmd FileType r inoremap ,, <space>%>%<space>
    " autocmd FileType r nnoremap <leader>rw <c-w>j<esc>i<space>%>%<space>write_csv("~/data_view.csv")<esc>0i
    autocmd FileType r nnoremap <leader>1 :Rdata1<space>
    autocmd FileType r nnoremap <leader>2 :Rdata2<space>
    autocmd FileType r nnoremap <leader>3 :Rdata3<space>
    autocmd FileType r nnoremap <leader>4 :Rdata4<space>
    " space-rq rewrites last dataframe
    autocmd FileType r nnoremap <leader>rq <c-w>j<c-r>write_csv<cr><c-w>k
    autocmd FileType r nnoremap <silent> <leader>rw 
	\ :execute "normal Gols_env_dfs()<C-v><esc><space>wdd``"<cr>
    autocmd FileType r nnoremap <silent> <leader>rd 
	\ :execute "normal Gols_env_global()<C-v><esc><space>wdd``"<cr>

augroup END

augroup allfiles
    autocmd!
    " sets files with no extension to be treated as text
    " allows resourcing of vimrc and files keeping their settings
    " if tab behavior set outside group sets all filetypes to that on resource
    autocmd BufNewFile,BufRead *.conf set syntax=text
    autocmd BufNewFile,BufRead * if expand('%:t') !~ '\.' | set ft=sh | endif
    " copy current bash line into registry
    autocmd BufNewFile,BufRead *.bash_history nnoremap o "+yy
    autocmd BufNewFile,BufRead *.bash_history nnoremap p ZQ
    autocmd BufNewFile,BufRead *.bash_history :silent g/^$/d
    autocmd FileType text,sh,conf,vim,javascript setlocal tabstop=4
    autocmd FileType text,sh,conf,vim,javascript setlocal shiftwidth=4
    autocmd FileType text,sh,conf,vim,javascript setlocal softtabstop=4
    autocmd FileType text,sh,conf,vim,javascript setlocal expandtab
augroup END

" commands to send code to console
nnoremap <silent> <leader>rr :execute "normal }Vgg<space>w"<cr>
nnoremap <silent> <leader>re :execute "normal V{<space>w"<cr>
nnoremap <silent> <leader>e :execute "normal {V}<space>w"<cr>

nnoremap <leader>r1 :! libreoffice ~/.data/d1.csv &<cr><cr>
nnoremap <leader>r2 :! libreoffice ~/.data/d2.csv &<cr><cr>
nnoremap <leader>r3 :! libreoffice ~/.data/d3.csv &<cr><cr>
nnoremap <leader>r4 :! libreoffice ~/.data/d4.csv &<cr><cr>
nnoremap <leader>= <c-w>5+
nnoremap <leader>- <c-w>5-
nnoremap <leader>_ <c-w>5<
nnoremap <leader>+ <c-w>5>
nnoremap <leader>t :REPLToggle<Cr>
nnoremap <leader>T :term<cr>


" set terminal settings
" set termwinkey=<space>
" nnoremap <leader>t :term<cr>

nnoremap <leader>' :execute "normal \<Plug>Ysurround$'"<cr>
nnoremap <leader>" :execute "normal \<Plug>Ysurround$\""<cr>
nnoremap <leader>) :execute "normal \<Plug>Ysurround$)"<cr>
nnoremap <leader>( :execute "normal \<Plug>Ysurround$("<cr>

nnoremap <leader>h ^
nnoremap <leader>H 0


" set in plugin files since re sourcing vimrc breaks call
let g:repl_program = {
    \   'python': 'ipython3',
    \   'r': 'R --no-save',
    \ }

" let g:repl_exit_commands = {
"     \   'radian': 'q()'
"   \ }

" let NERDTreeMapActivateNode = 'e'
" let NERDTreeMapOpenExpl = 'E'

" make jumps larger than 3 counts as jumps
nnoremap <expr> j v:count ? (v:count > 2 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 2 ? "m'" . v:count : '') . 'k' : 'gk'

nnoremap <leader>c :cd %:h<cr>

tnoremap <F5> <c-w>h
inoremap <F5> <esc><c-w>h
nnoremap <F5> <c-w>h

tnoremap <F6> <c-w>j
inoremap <F6> <esc><c-w>j
nnoremap <F6> <c-w>j

tnoremap <F7> <c-w>k
inoremap <F7> <esc><c-w>k
nnoremap <F7> <c-w>k

tnoremap <F8> <c-w>l
inoremap <F8> <esc><c-w>l
nnoremap <F8> <c-w>l

tnoremap <F1> <c-w>w
inoremap <F1> <esc><c-w>w
nnoremap <F1> <c-w>w

let g:repl_height = 20
let g:repl_position = 3

" move last y to xclipboard (copy paste)
nnoremap <silent> <leader>y :let @+=@"<cr>

