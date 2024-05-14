set number relativenumber

syntax on

" ====
" search highlights
set incsearch
set hlsearch
" clear highlights
" https://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting
nmap <silent><esc><esc> :nohlsearch<CR>

" ====
" search ignore case
set ignorecase

" ====
" search smart case
set smartcase

" ====
" reload vimrc
map <silent> <leader>r :source $MYVIMRC<CR>

" ====
" select all
" nnoremap <D-a> ggVG
" vnoremap <D-a> ggVG
map <silent> <Leader>a ggVG
map <silent> <Leader>a ggVG

" ====
" insert new line below/above in normal mode without entering insert
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" ====
" insert new line using enter, at cursorabove in normal mode without entering insert
" https://superuser.com/questions/607163/inserting-a-blank-line-in-vim
" https://stackoverflow.com/a/42461580/1979530
" nnoremap <CR> o<Esc>
nnoremap <CR> i<CR><Esc>

" ====
" esc in insert and visual mode
inoremap jj <Esc>
vnoremap jj <Esc>

" ====
" Move current line contents up and and down
" Ctrl+j/k move current line contents up and down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Opt+j/k move current line contents up and down
" note on macos we avoid remapping opt to alt (esc) keys
" however that means we cannot use this in insert mode
" Using sed -n l to capture what actually Alt+j or j brings
" nnoremap ķ :m .-2<CR>==
" nnoremap ∆ :m .+1<CR>==
" vnoremap ķ :m '<-2<CR>gv=gv
" vnoremap ∆ :m '>+1<CR>gv=gv


" Opt+Up/Down move current line contents up and down
" Up
" ^[[1;3A
" \033[1;3A
" Down
" ^[[1;3B
" \033[1;3B
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

" Move 1 more lines up or down in normal and visual selection modes.
" nnoremap A-k :m .-2<CR>==
" nnoremap A-j :m .+1<CR>==
" vnoremap A-k :m '<-2<CR>gv=gv
" vnoremap A-j :m '>+1<CR>gv=gv


" ====
