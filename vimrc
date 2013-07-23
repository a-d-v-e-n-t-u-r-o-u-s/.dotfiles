runtime bundle/pathogen/autoload/pathogen.vim

execute pathogen#infect()
call pathogen#helptags()

syntax on

filetype plugin indent on

set expandtab
set shiftwidth=4
set softtabstop=4
set number

map <F2> :NERDTreeToggle<CR>
inoremap <F2> <C-O>:NERDTreeToggle<CR>
map <F3> :set number!<CR>
