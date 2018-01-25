"Vimrc file maintained by Marek Tkaczyk for personal use
"With corrections from Damian Michalski,
"who based his vimrc from me

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
 
Plugin 'VundleVim/Vundle.vim'
Plugin 'jaawerth/nrun.vim'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-commentary'
 
 "js plugins
"based on https://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'othree/javascript-libraries-syntax.vim'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Raimondi/delimitMate'
Plugin 'neomake/neomake'
Plugin 'Valloric/YouCompleteMe'
Plugin 'yegappan/grep'
Plugin 'ternjs/tern_for_vim'

call vundle#end()
 
let g:ycm_extra_conf_globlist = ['~/*']
 
filetype indent plugin on
syntax on
 
"solarized color scheme
syntax enable
set background=dark
set t_Co=16     "needed to work in ubuntu terminal
"let g:solarized_termcolors=256

colorscheme solarized
"air-line
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"YouCompleteMe settings
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
"vim-javascript settings
let g:javascript_plugin_jsdoc = 1 
"javascript-libraries-syntax settings
let g:used_javascript_libs = 'underscore,jquery,react'
"ternjs
"enable keyboard shortcuts
let g:tern_map_keys=1
"show argument hints
let g:tern_show_argument_hints='on_hold'

"vim-indent-guides settings
"let g:indent_guides_enable_on_vim_startup = 1
"set ts=2 sw=2 et
"let g:indent_guides_start_level = 2
 
"neomake linting
let g:neomake_typescript_enabled_makers = ['tslint']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_warning_sign = {
\ 'text': '>',
\ 'texthl': 'WarningMsg',
\ }
let g:neomake_error_sign = {
\ 'text': '>>',
\ 'texthl': 'ErrorMsg',
\ }
let g:neomake_open_list=0
let g:neomake_verbose=1

set virtualedit="block" " In visual selection mode, you can move even when there are no spaces

set completeopt-=preview
"Must have options, highly recommended by community
set hidden
set wildmenu

set showcmd

set hlsearch
set incsearch

"Smart options, good for programming

set ignorecase
set smartcase

set backspace=indent,eol,start
set smarttab autoindent

set ruler

set laststatus=2
set confirm

set cmdheight=2

"show line numbers, as well as distances
set number
set relativenumber


set clipboard=unnamedplus

"ctags optimalization
set autochdir
set tags=tags;

"Indentation options, i prefer to use hard tabs
"For js programming i need spaces(17.03.17r)
set expandtab
set shiftwidth=4
set softtabstop=4
filetype plugin indent on

"for webpack to catch all writes
set backupcopy=yes

"Setting .swp files to be centralized, not clutter the edit folder
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

let g:netrw_banner = 0  "Disable useless directory banner
let g:netrw_liststyle = 3   "set view to tree
let g:netrw_browse_split = 3 "1 - horizontal, 2 - vertical, 3 - new tab, 4 - prev window
let g:netrw_winsize = 20 "20% of screen

nnoremap <C-f> :vimgrep <c-r>" /** 
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
noremap <silent> <C-l> <c-w>l
noremap <silent> <C-h> <c-w>h
noremap <silent> <C-k> <c-w>k
noremap <silent> <C-j> <c-w>j
nnoremap ; :
nnoremap : ;

" visual mode block moving
vnoremap L gv><C-v>
vnoremap H gv<<C-v>

"option toggles
nnoremap <F5> :set invpaste paste?<Enter>
nnoremap <silent> <F2> :call WindowOrTab()<cr>
nnoremap <silent> <F3> :call DeleteCursor()<cr>
nnoremap <silent> <F4> :call AddCursor()<cr>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

function! WindowOrTab()
    if g:netrw_browse_split == 3 
        echom "Files open in previous window ONLY to PREVIEW :)"
        let g:netrw_browse_split = 4
    else
        echom "Files open in new tab :>"
        echom "You can edit now"
        let g:netrw_browse_split = 3
    endif
endfunction

highlight InsertedByCursors ctermfg=2

function! AddCursor()
    if !exists("b:cursors")
        let b:cursors = []
    endif
    let cursor = nr2char(getchar())
    let l:cursorIndex = index(b:cursors, cursor)
    if l:cursorIndex > -1
        execute "normal! m" . cursor
        echom "Changed " . cursor . " cursor!"
    else
        call add(b:cursors, cursor)
        echom "Added " . cursor " to cursors!"
        execute "normal! m" . cursor
    endif
endfunction

function! DeleteCursor()
    if !exists("b:cursors")
        return
    endif
    let cursor = nr2char(getchar())
    if cursor ==? '-' 
        unlet b:cursors
        echom "Deleted all cursors!"
        return
    endif
    let l:cursorIndex = index(b:cursors, cursor)
    if l:cursorIndex > -1
        unlet b:cursors[l:cursorIndex]
        echom "Cursor " . cursor . " deleted!"
    endif
endfunction

function! MultipleLines()
    if !exists("b:cursors")
        return
    endif

    let myText = @.
    for cursor in b:cursors
       execute "normal! `" . cursor . ".<cr>"
    endfor

    if exists("b:highlightedTextFromCursors")
        call matchdelete(b:highlightedTextFromCursors)
        unlet b:highlightedTextFromCursors
    endif
    let b:highlightedTextFromCursors = matchadd('InsertedByCursors', myText, -1)
endfunction

function! ReturnToFileSelect()
    if g:netrw_browse_split == 4
        execute "normal! \<c-w>h"
        echom "return to window on LEFT"
    endif
endfunction

function! DoMake()
    let currentDirectory = expand('%:p:h')
    echom currentDirectory
    lcd ..
    make
    execute 'lcd ' . currentDirectory
endfunction

"Suffixes for 'gf' command to associate filetypes with extensions (for files jumping)
augroup suffixes
    autocmd!
    let associations = [
                \["javascript", ".js,.jsx"],
                \["typescript", ".ts"],
                \]

    for ft in associations
        execute "autocmd FileType " . ft[0] . " setlocal suffixesadd=" . ft[1]
    endfor
augroup END

augroup general
    autocmd!
    autocmd VimEnter * :Vexplore
    autocmd BufEnter * let b:neomake_javascript_eslint_exe = nrun#Which('eslint')
    autocmd BufEnter * let b:neomake_typescript_tslint_exe = nrun#Which('tslint')
    autocmd BufWinEnter,BufWritePost * Neomake
    autocmd BufEnter * :call ReturnToFileSelect()
    autocmd InsertLeave * :call MultipleLines()
augroup END

augroup latex_files
    autocmd!
augroup END

augroup js_files
    autocmd!    
    autocmd FileType javascript let maplocalleader = ";"
    autocmd FileType javascript setlocal commentstring=\/\/%s
augroup END

augroup cpp_files
    autocmd!
    autocmd FileType cpp let maplocalleader = "`"
    autocmd FileType cpp nnoremap <buffer> <localleader>c :call DoMake()<cr> 
augroup END

