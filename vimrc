runtime bundle/pathogen/autoload/pathogen.vim


execute pathogen#infect()
call pathogen#helptags()

syntax on

filetype plugin indent on

set number
set mouse=a
set tags=tags
set list listchars=tab:>-,trail:~,extends:>

highlight WhitespaceEOL ctermfg=white ctermbg=red guifg=white guibg=red
    match WhitespaceEOL /\s\+$/

let g:hlstate=1
let g:spaces_indenting=1
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

function! s:GoForError(partcmd)
    try
        try
            exec "l". a:partcmd
         catch /:E776:/
             " No location list
             exec "c". a:partcmd
         endtry
     catch
         echohl ErrorMsg
         echomsg matchstr(v:exception, ':\zs.*')
         echohl None
     endtry
endfunc

function! TabsSpacesToggle()
    if(bufwinnr(1))
        if(g:spaces_indenting==0)
            set noexpandtab
            set copyindent
            set preserveindent
            set softtabstop=0
            set shiftwidth=4
            set tabstop=4
            let g:spaces_indenting=1
            echo 'TABS INDENTING ON'
        else
            set expandtab
            set shiftwidth=4
            set softtabstop=4
            let g:spaces_indenting=0
            echo 'SPACES INDENTING ON'
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

"todo the ctags command generated right now tags for definition and
"declaration this shall be changed to the definition only or give some
"possibility of choice for the user
function! CreateTags()
    cs kill -1
    if has("win32")
        :silent !ctags -R --c++-kinds=+p --fields=+iaS --extra=+qf .
        :silent !del cscope.out
        :silent !cscope -bR
    else
        :silent !/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+qf .
        :silent !rm cscope.out
        :silent !/usr/bin/cscope -bR
    endif
    cs add cscope.out
    :redraw!
endfunction

call TabsSpacesToggle()
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

"Syntastic plugin config
let g:syntastic_debug=0
let g:syntastic_c_checkers=['gcc', 'oclint', 'splint', 'cppcheck', 'sparse']
let g:syntastic_aggregate_errors=1
let g:syntastic_auto_loc_list=0
let g:syntastic_always_populate_loc_list =0
let g:syntastic_c_check_header=1
let g:syntastic_id_checkers=1
let g:syntastic_enable_balloons= 1
let g:syntastic_check_on_wq=0
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1

"Taglist plugin config
let Tlist_Use_Right_Window = 1
let Tlist_Inc_Winwidth = 0
let Tlist_WinWidth = 45
let Tlist_GainFocus_On_ToggleOpen= 1
let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Show_One_File = 1

"Grep plugin config
let Grep_Default_Filelist = '*.c *h'
if has("win32")
    let Grep_Find_Path = '"C:\Program Files\GnuWin32\bin\find.exe"'
    let Grep_Skip_Files = '"*.bak *~ *.swp"'
    let Grep_Find_Use_Xargs = 0
else
    let Grep_Skip_Files = '*.bak *~ *.swp'
endif

com! -bar NextError  call s:GoForError("next")
com! -bar PrevError  call s:GoForError("previous")
com! -bar OlderError  call s:GoForError("older")
com! -bar NewerError  call s:GoForError("newer")

map <F2> :NERDTreeToggle<CR>
inoremap <F2> <C-O>:NERDTreeToggle<CR>
map <F3> :set number!<CR>

if has("win32")
    map <F11> :!cls<CR>
else
    map <F11> :!clear<CR>
endif

map <F12> :call CreateTags()<CR>
nnoremap <Leader>f :ls<CR>:buffer<Space>
map ,a :A<CR>
map ,av :AV<CR>
map ,at :AT<CR>
map ,ah :AS<CR>
nnoremap <silent> <F5> :source $MYVIMRC<CR>
nnoremap <silent> <F8> :GundoToggle<CR>
nnoremap <silent> <F9> :<C-U>call TabsSpacesToggle()<CR>
nnoremap <silent> <F10> :<C-U>call SplitToggle()<CR>
nnoremap <silent> <Leader>i :TlistToggle<CR>
nnoremap <silent> <Leader>j :NextError<CR>
nnoremap <silent> <Leader>k :PrevError<CR>
nnoremap <silent> <Leader>h :OlderError<CR>
nnoremap <silent> <Leader>l :NewerError<CR>
nnoremap <silent> <Leader><C-]> <C-w><C-]><C-w>T
nnoremap <silent> <C-L> :<C-U>call HlSearchToggle()<CR>
nnoremap <silent><C-J> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
