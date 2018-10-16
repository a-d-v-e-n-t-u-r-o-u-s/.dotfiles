runtime bundle/pathogen/autoload/pathogen.vim


execute pathogen#infect()
call pathogen#helptags()

syntax on
color dracula

filetype plugin indent on

set number
set showcmd
set mouse=a
set tags=tags
set list listchars=tab:>-,trail:~,extends:>
set statusline=%F\ -\ FileType:\ %y\ FileEncoding:\ %{&fenc}%=%P\ 0x%02B\ %3c

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%101v', 100)

highlight WhitespaceEOL ctermfg=white ctermbg=red guifg=white guibg=red
    match WhitespaceEOL /\s\+$/

highlight BookmarkLine ctermbg=21 ctermfg=NONE
highlight BookmarkAnnotationLine ctermbg=22 ctermfg=NONE

let g:hlstate=1
let g:spaces_indenting=1
let g:linux_kernel_tabs=0
let g:vertical_toggle=0
let g:vim_diff_on=0
let mapleader=","

function! VimDiffToggle()
    if bufwinnr(1)
        if(g:vim_diff_on==0)
            :silent windo diffthis
            let g:vim_diff_on=1
        else
            :silent windo diffoff
            let g:vim_diff_on=0
        endif
    endif
endfunction

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
            if(g:linux_kernel_tabs==0)
                set noexpandtab
                set copyindent
                set preserveindent
                set softtabstop=0
                set shiftwidth=4
                set tabstop=4
                let g:linux_kernel_tabs=1
                echo 'TABS INDENTING ON'
            else
                set tabstop=8
                set shiftwidth=8
                set softtabstop=8
                set noexpandtab
                let g:linux_kernel_tabs=0
                let g:spaces_indenting=1
                echo 'LINUX KERNEL INDENTING ON'
            endif
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
    if has("win32")
        :silent !ctags -R --c++-kinds=+p --fields=+iaS --extra=+qf .
    else
        :silent !/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+qf .
    endif
    :redraw!
endfunction

function! Clear()
    if has("win32")
        :!cls
    else
        :!clear
    endif
endfunction

call TabsSpacesToggle()
call SplitToggle()
call HlSearchToggle()


let NERDTreeDirArrows=0

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
let Grep_Default_Filelist = '*.c *.h *.cpp *.hpp'
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
map <F11> :call Clear()<CR>
map <F12> :call CreateTags()<CR>

"A plugin mappings
map <Leader>a :A<CR>
map <Leader>av :AV<CR>
map <Leader>at :AT<CR>
map <Leader>as :AS<CR>

"vim-bookmarks mappings
let g:bookmark_manage_per_buffer = 1
let g:bookmark_auto_save = 1
let g:bookmark_highlight_lines = 1

"CommandT options
let g:CommandTAcceptSelectionSplitCommand = 'sp'
let g:CommandTAcceptSelectionVSplitCommand = 'vs'
let g:CommandTGitScanSubmodules = 1
let g:CommandTTraverseSCM ='pwd'

"cscope settings and mappings
let g:cscope_silent = 1


if has("cscope")
    set csprg=/usr/bin/cscope
    " change this to 1 to search ctags DBs first
    set csto=1
    set cst
    set nocsverb
    "add any database in current directory
    if filereadable("cscope.out")
        echo "Adding user cscope db"
        cs add cscope.out
    "else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        echo "Adding default cscope db"
        cs add $CSCOPE_DB
    endif
set csverb
endif

let g:cscope_interested_files = '\.c$\|\.h$\|\.mk$\|Makefile|makefile'
let g:cscope_ignored_dir = 'docs$\|.build$'

let g:ycm_max_diagnostics_to_display = 200

nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>


" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>

nnoremap <silent> <F4> :<C-U>call VimDiffToggle()<CR>
nnoremap <silent> <F5> :source $MYVIMRC<CR>
nnoremap <silent> <C-F5> :e!<CR>
nnoremap <silent> <F7> :Rgrep -w<CR>
nnoremap <silent> <F8> :GundoToggle<CR>
nnoremap <silent> <F9> :<C-U>call TabsSpacesToggle()<CR>
nnoremap <silent> <F10> :<C-U>call SplitToggle()<CR>
nnoremap <silent> <Leader>i :TlistToggle<CR>
nnoremap <silent> <Leader>j :NextError<CR>
nnoremap <silent> <Leader>k :PrevError<CR>
nnoremap <silent> <Leader>h :OlderError<CR>
nnoremap <silent> <Leader>l :NewerError<CR>
nnoremap <silent> <Leader>yf :YcmCompleter FixIt<CR>
nnoremap <silent> <Leader>yd :YcmDiag<CR>
nnoremap <silent> <Leader>yr ::YcmRestartServer<CR>
nnoremap <silent> <Leader><C-]> <C-w><C-]><C-w>T
nnoremap <silent> <C-L> :<C-U>call HlSearchToggle()<CR>
nnoremap <silent><C-J> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
