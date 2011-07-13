set nocompatible

" Colemak remapping...
noremap <esc>n <C-w>j
noremap <esc>h <C-w>h
noremap <esc>e <C-w>k
noremap <esc>i <C-w>l
noremap <esc>c <C-w>c
noremap <esc>v <C-w>v
noremap <esc>s <C-w>s
noremap <esc>p <C-w>p

noremap n gj
noremap e gk
noremap k n
noremap K N
noremap j e
noremap i l
noremap l i


set mouse=a
set mousehide

set number
set ruler
syntax on

" Load the matchit plugin
runtime macros/matchit.vim

" Whitespace stuff
set wrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

" Status bar
set laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways


" Toggle window wrapping
" should be alt-shift-W but due to the funny macmeta thing it's „
" instead
map „ :set nowrap!<CR>
" Fix for macmeta remapping the # symbol
" set macmeta
"imap ³ #

" Set leader to <space> as it's the only key you have two
" dedicated digits for!
let mapleader = " "

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
let NERDTreeMapOpenExpl="E"
map <Leader>n :NERDTreeToggle<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" Taglist
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_Use_SingleClick=1
let Tlist_WinWidth=40
let Tlist_Sort_Type = "name"
let Tlist_Close_On_Select=1
let Tlist_GainFocus_On_ToggleOpen=1

" CTags...
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
" Open tag
map <leader>o :exec("tag ".expand("<cword>"))<CR>
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

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
" map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
" map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
set t_Co=256
" color sean_tm_twilight
" colorscheme xoria256
colorscheme wombat256
" colorscheme seans_wombat256

" Open .vimrc in a new tab
nmap <leader>,v :tabedit $MYVIMRC<CR>
nmap <leader>,g :tabedit $MYGVIMRC<CR>
nmap <leader>,c :tabedit ~/.vim/colors/sean_tm_twilight.vim<CR>

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

if has("autocmd")
	" Source the vimrc file after saving it
  autocmd! bufwritepost .vimrc source  $MYVIMRC
  autocmd! bufwritepost sean_tm_twilight.vim source ~/.vim/colors/sean_tm_twilight.vim

	" Stip trailing spaces from file
	"autocmd! bufwrite :%s/\s*$//g
  autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
  
endif


"Ack shortcut...
map <leader>a :Ack<space>


" Insert HashRockets... :)
imap <C-l> <Space>=><Space>

" Textmate-like Surround stuff...
vmap " s"
vmap ' s'
vmap ( s)
vmap [ s]
vmap { s}

imap <C-s><C-s> <C-s><C-e>

" NERDCommeter stuff...
let NERDSpaceDelims=1
map <leader>/ <plug>NERDCommenterToggle<CR>

" Ctrl-Shift-D to duplicate the current line below
map <C-D> yyp
" Shift D duplicates anything highlighted on the line below...
vmap D y'>p

" Disable search match highlight
nmap <silent> <esc><esc> :nohlsearch<cr>

" Remap double ;; to enter EX mode
" nmap ;; :
imap ;; <esc>:
imap § <esc>:
nmap § :

" Map <Leader>w to make window commands quicker
nmap <Leader>w <C-w>
set splitright
set splitbelow

" Alignment
map <Leader>l :Align<Space>

" Ruby syntax checking...
" autocmd BufWritePost *.rb make -c %
" SyntasticEnable
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1

" Blockle
let g:blockle_mapping = '<C-{>'

" Movement
" map j gj
" map k gk

map <C-t> :CommandT<CR>

" Move line highlighting with window focus
autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline

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

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

