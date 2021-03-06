set nocompatible

set shell=bash\ -i

noremap j gj
noremap k gk
map <C-e> :
" map <C-e><C-e> :
" imap <C-e> <esc>
imap <C-e> <esc>:

set mouse=a
set selectmode=
set mousehide

" no beeping!
set vb t_vb=
set number
set ruler

" Use old regex engine due to syntax lag in ruby...
" set re=1

syntax enable
set synmaxcol=200
set scrolloff=1
set lazyredraw

" Reload changing files
set autoread

" Whitespace stuff
set wrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·
set virtualedit=block

" Add symbols that count as part of Keywords...
set iskeyword+=!,?,@

" Code folding
set nofoldenable

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.scssc

set wildchar=<Tab> wildmenu wildmode=full

" Status bar
set laststatus=2

" Splits should be created in the same way as every other gui!
set fillchars=diff:⣿,vert:│
set splitright
set splitbelow

" When switching to a buffer move the first open window with the buffer
" in...
set switchbuf=useopen

" Set leader to <space> as it's the only key you have two
" dedicated digits for!
let mapleader = " "

" NERDTree configuration
let NERDTreeStatusline=split(getcwd(), '/')[-1]
let NERDTreeIgnore=['\.rbc$', '\~$']
let NERDTreeMapOpenExpl="E"
map <Leader>n :NERDTreeToggle<CR>


" Netrw Config
let g:netrw_preview=1
let g:netrw_liststyle=3
let g:netrw_altv = 0
let g:netrw_list_hide = ".git,.sass-cache,.jpg,.png,.svg"
let g:netrw_banner=0

" Stop ballooneval turning on in plugins!
let g:netrw_nobeval=1

" ZoomWin configuration
map § :ZoomWin<CR>

" CTags...
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
" Open tag
map <leader>o :exec("tag ".expand("<cword>"))<CR>zz
" map <leader>o :tj<CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
endif

function! s:setupWrapping()
set wm=2
set textwidth=72
endfunction

function! s:setupMarkup()
call s:setupWrapping()
map <buffer> <Leader>p :Mm <CR>
endfunction

" make and python use real tabs
au FileType make                                     set noexpandtab
au FileType python                                   set noexpandtab

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" jshint javascript files on save
" au BufWritePost *.js :JSHint

" Tern settings
map <Leader>* * :TernDefSplit<CR>zt
map <Leader>8 * :TernDefSplit<CR>zt

" wrap comments but not code
autocmd FileType javascript setlocal textwidth=80 formatoptions=croq
autocmd BufNewFile,BufRead *.json setf javascript

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
if has("gui_running")
  colorscheme sean_tm_twilight
  " colorscheme eddie

  " MacVIM shift+arrow-keys behavior (required in .vimrc)
  let macvim_hig_shift_movement = 1

  set cursorline
  " Move line highlighting with window focus
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
  set relativenumber

else
  set t_Co=256
  set background=dark
  let g:solarized_termtrans = 1
  let g:solarized_italic=1
  " colorscheme solarized

  " let g:molokai_original = 1
  let g:rehash256 = 1
  colorscheme molokai
  " let g:airline_powerline_fonts=1
  let g:airline_theme='molokai'


  " Copy to the system clipboard
  map <leader>c "+y
  " Paste...
  map <leader>v "+p
endif


if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif


" old vim-powerline symbols
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '│'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '│'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = 'ro'
let g:airline_symbols.linenr = '⭡'


" Open .vimrc in a new tab
nmap <leader>,v :tabedit $MYVIMRC<CR>
nmap <leader>,g :tabedit $MYGVIMRC<CR>
nmap <leader>,c :tabedit ~/.vim/colors/solarized.vim<CR>
" nmap <leader>,c :tabedit ~/.vim/colors/sean_tm_twilight_console.vim<CR>

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

if has("autocmd")
  " Source the vimrc file after saving it
  autocmd! bufwritepost .vimrc source  $MYVIMRC
  " autocmd! bufwritepost sean_tm_twilight.vim source ~/.vim/colors/sean_tm_twilight.vim
  autocmd! bufwritepost sean_tm_twilight.vim source ~/.vim/colors/solarized.vim

  " Strip trailing spaces from file
  "autocmd! bufwrite :%s/\s*$//g
  autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

endif

" Use Node.js for JavaScript interpretation
let $JS_CMD='node'


" Ruby stuff
" Insert HashRockets... :)
imap <C-l> <Space>=><Space>

" Alignment
map <Leader>l :Tabularize<space>

" set statusline+=set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Spelling stuff...
setlocal spell spelllang=en_gb
set spell
map z= ea<C-x>s

" let g:syntastic_enable_signs=1
" let g:syntastic_auto_jump=1
" let g:syntastic_auto_loc_list=1
" let g:syntastic_javascript_checkers = ['jshint']
"
" " go ahead and check files when we open them
" let g:syntastic_check_on_open=1
"
" " use fancy symbols for errors and warnings
" let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'


" Gundo
" let g:gundo_width=120
" function! TabGundo()
"   tab split
"   GundoToggle
" endfunction
"
" command! -complete=command TabGundo call TabGundo()
"
" nnoremap <F5> :TabGundo<CR><c-w>=
"

" Persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=100 "maximum number of changes that can be undone
set undoreload=100 "maximum number lines to save for undo on a buffer reload



" The Silver Searcher
" Ag shortcut...
map <leader>f y:Ag --literal '<C-R>=expand("<cword>")<CR>'
vmap <leader>f y:Ag --literal '<C-R>0'<space>

map <leader>b :CtrlPBuffer<cr>
let g:ctrlp_match_window_reversed = 0

" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript']

" ctrl p
let g:ctrlp_root_markers = ['Capfile']
" let g:ctrlp_max_files = 0

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0
endif

nnoremap <silent> <C-W>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_custom_ignore = '\v\.(jpeg|jpg|JPG|png)$'

" Delete buffers in Ctrlp buffer mode
let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }

func! MyCtrlPMappings()
nnoremap <buffer> <silent> <c-@> :call <sid>DeleteBuffer()<cr>
endfunc

func! s:DeleteBuffer()
exec "bd" fnamemodify(getline('.')[2:], ':p')
exec "norm \<F5>"
endfunc


" Show (partial) command in the status line
set showcmd

" Pipes the output of Ex to a buffer in a new tab...
function! TabMessage(cmd)
redir => message
silent execute a:cmd
redir END
tabnew
silent put=message
set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)


" Qargs populates the args list with the files in the quickfix list...
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
" Building a hash ensures we get each buffer only once
let buffer_numbers = {}
for quickfix_item in getqflist()
  let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
endfor
return join(values(buffer_numbers))
endfunction

function! BufferDelete()
if &modified
  echohl ErrorMsg
  echomsg "No write since last change. Not closing buffer."
  echohl NONE
else
  let s:total_nr_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

  echohl ErrorMsg
  echomsg "No write since last change. Not closing buffer."
  echohl NONE
else
  let s:total_nr_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

  if s:total_nr_buffers == 1
    bdelete
    echo "Buffer deleted. Created new buffer."
  else
    bprevious
    bdelete #
    echo "Buffer deleted."
  endif
endif
endfunction
command! -nargs=0 -complete=command BufCleaner call BufferDelete()
map <esc><BS> :silent BufCleaner<cr>

" Regexps...
" Change '<word>' to "<word>"
map <leader>' :%s/\v'([^ ]*)'/"\1"/gc<cr>

au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino
au BufNewFile,BufRead *.ldg,*.ledger setf ledger

" Macros...
" Format SQL
let @s=':%s/where/where/g :%s/from/from/g :%s/inner/inner/g :%s/and/and/g :%s/order/order/g :%s/\s*$//g :set syntax=sql'
" Update hash format
map <leader>h :%s/:\(\w*\) =>/\1:/gc<CR>


let g:ctrlp_prompt_mappings = {
      \ 'PrtBS()':              ['<c-h>', '<bs>', '<c-]>'],
      \ 'PrtDelete()':          ['<del>'],
      \ 'PrtDeleteWord()':      ['<c-w>'],
      \ 'PrtClear()':           ['<c-u>'],
      \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
      \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
      \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
      \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
      \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
      \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
      \ 'PrtHistory(-1)':       ['<c-n>'],
      \ 'PrtHistory(1)':        ['<c-p>'],
      \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
      \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
      \ 'AcceptSelection("t")': ['<c-t>'],
      \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
      \ 'ToggleFocus()':        ['<s-tab>'],
      \ 'ToggleRegex()':        ['<c-r>'],
      \ 'ToggleByFname()':      ['<c-d>'],
      \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
      \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
      \ 'PrtExpandDir()':       ['<tab>'],
      \ 'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
      \ 'PrtInsert()':          ['<c-\>'],
      \ 'PrtCurStart()':        ['<c-a>'],
      \ 'PrtCurEnd()':          ['<c-e>'],
      \ 'PrtCurLeft()':         [ '<left>', '<c-^>'],
      \ 'PrtCurRight()':        ['<c-l>', '<right>'],
      \ 'PrtClearCache()':      ['<F5>'],
      \ 'PrtDeleteEnt()':       ['<F7>'],
      \ 'CreateNewFile()':      ['<c-y>'],
      \ 'MarkToOpen()':         ['<c-z>'],
      \ 'OpenMulti()':          ['<c-o>'],
      \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
      \ }
