" First install vim-plug:
" /home/sadegh/.config/nvim/init.vim
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Note Skip initialization for vim-tiny or vim-small.
if 0 | endif
if &compatible
  set nocompatible
endif

let g:mapleader = ","

" deoplete
set completeopt=longest,menuone " auto complete setting
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns['default'] = '\h\w*'
let g:deoplete#omni#input_patterns = {}
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'


" neomake
autocmd BufWritePost * Neomake
let g:neomake_error_sign   = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '∆', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign    = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
let g:neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
let g:neomake_go_gometalinter_maker = {
  \ 'args': [
  \   '--tests',
  \   '--enable-gc',
  \   '--concurrency=3',
  \   '--fast',
  \   '-D', 'aligncheck',
  \   '-D', 'dupl',
  \   '-D', 'gocyclo',
  \   '-D', 'gotype',
  \   '-E', 'errcheck',
  \   '-E', 'misspell',
  \   '-E', 'unused',
  \   '%:p:h',
  \ ],
  \ 'append_file': 0,
  \ 'errorformat':
  \   '%E%f:%l:%c:%trror: %m,' .
  \   '%W%f:%l:%c:%tarning: %m,' .
  \   '%E%f:%l::%trror: %m,' .
  \   '%W%f:%l::%tarning: %m'
  \ }

let g:neomake_python_flake8_maker = {
    \ 'args': ['--ignore=E221,E241,E272,E251,W702,E203,E201,E202',  '--format=default'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#',
    \ }
let g:neomake_python_enabled_makers = ['flake8']

" vim-go
let g:go_def_mapping_enabled = 0
let g:go_snippet_case_type = "camelcase"
let g:go_fmt_command = 'goimports'
let g:go_fmt_fail_silently = 1
let g:go_term_mode = "split"
let g:go_term_enabled = 1
" performance !!!
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1


" use real tabs in .go files, not spaces
autocmd FileType go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
autocmd FileType py setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

" plugins
call plug#begin()

Plug 'neomake/neomake'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'zchee/deoplete-jedi'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jreybert/vimagit'
Plug 'majutsushi/tagbar'
Plug 'jmcantrell/vim-virtualenv'
Plug 'mhartington/oceanic-next'
" Plug 'airblade/vim-gitgutter'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'fatih/molokai'
Plug 'jodosha/vim-godebug'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'pseewald/vim-anyfold'
Plug 'jiangmiao/auto-pairs'
Plug 'ihacklog/HiCursorWords'

" Add plugins to &runtimepath
call plug#end()

" install missing plugins on start
autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall
  \| endif

call deoplete#custom#set('_', 'converters',
      \ ['converter_auto_paren',
      \  'converter_auto_delimiter',
      \  'converter_remove_overlap'])

" mappings

" deoplete
imap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
imap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<tab>"
imap <expr> <cr>    pumvisible() ? deoplete#close_popup() : "\<cr>"

" vim-go mappings
autocmd FileType go nmap <buffer> <leader>r <plug>(go-run)
autocmd FileType go nmap <buffer> <leader>b <plug>(go-build)
autocmd FileType go nmap <buffer> <leader>t <plug>(go-test)
autocmd FileType go nmap <buffer> <leader>e <plug>(go-rename)
autocmd FileType go nmap <buffer> <leader>c <plug>(go-coverage)
autocmd FileType go nmap <buffer> gd <plug>(go-def-split)
autocmd FileType go nmap <buffer> <leader>i <plug>(go-info)

" highligh 80 char
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" nerdtree
nmap <C-n> :NERDTreeTabsToggle<CR>
let g:NERDTreeWinPos = "right"
let NERDTreeMinimalUI = 1
let NERDTreeIgnore=['\~$', '\.pyc$', '^\.DS_Store$', '^node_modules$', '.ropeproject', '__pycache__']
let NERDTreeDirArrows = 1
let NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeWinSize = 25
autocmd VimEnter * if argc() == 0 | NERDTree | endif
" Auto close if NERDTree is the last thing open
autocmd bufenter *
   \ if (winnr("$") == 1 && exists("b:NERDTree")
   \ && b:NERDTree.isTabTree()) | q | endif

set laststatus=2

let g:nerdtree_tabs_open_on_console_startup = 1

" copy to clipboard
noremap <C-c> "+y
let g:loaded_matchparen = 1

" startup with number
set number

" cursor word
let g:HiCursorWords_delay = 900

" fold
filetype plugin indent on
let anyfold_fold_comments=1
syntax on
let anyfold_activate=1
set foldlevel=0

" gitgutter
  let g:gitgutter_map_keys = 0

" Aireline theme
let g:airline_powerline_fonts = 1
let g:airline_theme='oceanicnext'

" tagbar
nmap <C-T> :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_width = 25

" theme
syntax enable
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

" fonts and devicons
set encoding=utf8
let g:webdevicons_enable = 0
"let g:webdevicons_enable_nerdtree = 0
"let g:webdevicons_enable_airline_statusline = 0

" spell check
setlocal spell spelllang=en_us
set nospell

" Translate Bye Google
"

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

