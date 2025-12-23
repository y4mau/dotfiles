" ----------------------------------------
" editor settings
" ----------------------------------------
" replace tab input with spaces
set expandtab
" width of tab
set tabstop=2
" auto shift width
set shiftwidth=2
" cursor speed on series of space
set softtabstop=2
" continue previous line's indent
set autoindent
" adjust next indeniton to the tail of the last line
set smartindent

" ----------------------------------------
" search settings
" ----------------------------------------
" highlight matched text
set hlsearch
" ignore case
set ignorecase

" ----------------------------------------
" display settings
" ----------------------------------------
" display line numbers
set number
" syntax highlight
syntax on
" increase redrawtime for complex syntax (e.g., TSX files)
set redrawtime=10000
" limit syntax highlighting to first 300 columns (prevents regex backtracking)
set synmaxcol=300
" use old regex engine (avoids backtracking issues with complex syntax)
set re=1
" expand Tab
set expandtab
" enable cursole to move forward of EOL
set virtualedit=onemore

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
