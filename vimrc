filetype plugin indent on
set whichwrap=b,s,<,>,[,]
syntax on
set ignorecase
set softtabstop=4 shiftwidth=4 expandtab
set autoindent
set laststatus=2

autocmd FileType make setlocal noexpandtab
function! LoadCscope()
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . $CTP_BUILDROOT . "/cscope.out"
    set cscopeverbose
endfunction
if !empty($CTP_BUILDROOT)
    au BufEnter /* call LoadCscope()
endif
set hlsearch
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"set background=dark
colorscheme asu1dark
if &diff
    colorscheme default
endif
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

map    <C-Tab>    :tabnext<CR>
imap   <C-Tab>    <C-O>:tabnext<CR>
map    <C-S-Tab>  :tabprev<CR>
imap   <C-S-Tab>  <C-O>:tabprev<CR>

autocmd BufEnter * call SetHighlight()
function! SetHighlight()
    highlight ExtraWhitespace ctermbg=red guibg=red
endfunction
