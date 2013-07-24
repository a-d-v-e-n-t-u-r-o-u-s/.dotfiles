runtime bundle/pathogen/autoload/pathogen.vim

execute pathogen#infect()
call pathogen#helptags()

syntax on

filetype plugin indent on

set expandtab
set shiftwidth=4
set softtabstop=4
set number
set mouse=a
set tags=tags
set list listchars=tab:>-,trail:~,extends:>

highlight WhitespaceEOL ctermfg=white ctermbg=red guifg=white guibg=red
    match WhitespaceEOL /\s\+$/

let g:hlstate=1
let g:vertical_toggle=0
let mapleader=","

function! SplitToggle()
  if bufwinnr(1)
    if(g:vertical_toggle==0) 
      nnoremap + <C-W>+
      nnoremap - <C-W>-
      let g:vertical_toggle=1
      echo 'Horizontal split resizing ON'
   else
      nnoremap + <C-W>>
      map - <C-W><
      let g:vertical_toggle=0
      echo 'Vertical split resizing ON'
   endif
 endif
endfunction

function! HlSearchToggle()
    if(g:hlstate==0)
        set nohlsearch
        let g:hlstate=1
    else
        set hlsearch
        let g:hlstate=0
    endif
endfunction

function! CreateTags()
    :silent !/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+qf .
    :silent !/usr/bin/cscope -bR
    cs kill -1
    cs add cscope.out
    :redraw!
endfunction

call SplitToggle()
call HlSearchToggle()

set ofu=syntaxcomplete#Complete
let OmniCpp_GlobalScopeSearch   = 1
let OmniCpp_DisplayMode         = 1
let OmniCpp_ShowScopeInAbbr     = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess          = 1
let OmniCpp_SelectFirstItem     = 1
let OmniCpp_MayCompleteScope    = 1
set completeopt=menu,longest

"Taglist plugin config
let Tlist_Use_Right_Window = 1
let Tlist_Inc_Winwidth = 0
let Tlist_WinWidth = 45
let Tlist_GainFocus_On_ToggleOpen= 1
let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Show_One_File = 1

map <F2> :NERDTreeToggle<CR>
inoremap <F2> <C-O>:NERDTreeToggle<CR>
map <F3> :set number!<CR>
map <F12> :call CreateTags()<CR>
nnoremap ,b :ls<CR>:buffer<Space>
nnoremap <silent> <F10> :<C-U>call SplitToggle()<CR>
nnoremap <silent> <Leader>t :TlistToggle<CR>
nnoremap <silent> <C-L> :<C-U>call HlSearchToggle()<CR>
nnoremap <silent><C-J> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

