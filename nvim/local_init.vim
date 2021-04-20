" Always autosave everything
au FocusLost * silent! :wa
set autowriteall
set relativenumber
set clipboard+=unnamedplus

" Set transparant background vim
"hi Normal guibg=NONE ctermbg=NONE

" Show replace as you type
set inccommand=nosplit

" Split to right and bottom
set splitbelow
set splitright

" So that I can see `` in markdown files
let g:indentLine_fileTypeExclude = ['markdown']

set smarttab
set smartindent

set tabstop=2
set shiftwidth=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" Delimitemate settings
let delimitMate_expand_cr = 2
imap <C-j> <Plug>delimitMateS-Tab
imap <C-l> <Plug>delimitMateJumpMany

" yaml settings
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
