set nocompatible

noremap j gj
noremap k gk

set mouse=a
set selectmode=
set mousehide

" no beeping!
set vb t_vb=
set number
set relativenumber
set ruler
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

" Netrw Config
let g:netrw_liststyle=3
let g:netrw_list_hide = ".git,.sass-cache,.jpg,.png,.svg"
let g:netrw_browse_split = 4

" Stop ballooneval turning on in plugins!
let g:netrw_nobeval=1

" Command-T configuration
let g:CommandTMaxHeight=20
set wildignore+=tmp/**
" ZoomWin configuration
map § :ZoomWin<CR>

" Taglist

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

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use skinny indent guides
let g:indent_guides_guide_size = 1


" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
set t_Co=256
if has("gui_running")
  colorscheme sean_tm_twilight
  " colorscheme eddie

  " MacVIM shift+arrow-keys behavior (required in .vimrc)
  let macvim_hig_shift_movement = 1

else
  let g:solarized_termcolors=256
  colorscheme solarized
  set background=dark
  " colorscheme Tomorrow-Night
  " let g:Powerline_colorscheme='solarized256'
  let g:airline_powerline_fonts=1
  let g:airline_theme='solarized'

  set cursorline

  " Copy to the system clipboard
  map <leader>c "+y
endif


" Open .vimrc in a new tab
nmap <leader>,v :tabedit $MYVIMRC<CR>
nmap <leader>,g :tabedit $MYGVIMRC<CR>
nmap <leader>,c :tabedit ~/.vim/colors/solarized.vim<CR>

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Include user's local vim config
" if filereadable(expand("~/.vimrc.local"))
"   source ~/.vimrc.local
" endif

if has("autocmd")
	" Source the vimrc file after saving it
  autocmd! bufwritepost .vimrc source  $MYVIMRC
  autocmd! bufwritepost sean_tm_twilight.vim source ~/.vim/colors/sean_tm_twilight.vim
  autocmd! bufwritepost sean_tm_twilight.vim source ~/.vim/colors/solarized.vim

	" Strip trailing spaces from file
	"autocmd! bufwrite :%s/\s*$//g
  autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

endif

" Use Node.js for JavaScript interpretation
let $JS_CMD='node'


" Ack shortcut...
map <leader>f y:tab Ack --literal '<C-R>=expand("<cword>")<CR>' app/
vmap <leader>f y:tab Ack --literal '<C-R>0'<space> app/


" Ruby stuff
" Insert HashRockets... :)
imap <C-l> <Space>=><Space>

" Alignment
map <Leader>l :Tabularize<space>

set statusline+=set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

setlocal spell spelllang=en_gb
set spell
map z= ea<C-x>s

let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_javascript_checkers = ['jshint']

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


" let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript']

" let g:ctrlp_map = '<c-t>'
map <leader>b :CtrlPBuffer<cr>
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_working_path_mode = 2
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files --exclude-standard -co']
let g:ctrlp_switch_buffer = 'Et'

" Delete buffers in Ctrlp buffer mode
let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }

func! MyCtrlPMappings()
    nnoremap <buffer> <silent> <c-@> :call <sid>DeleteBuffer()<cr>
endfunc

func! s:DeleteBuffer()
    exec "bd" fnamemodify(getline('.')[2:], ':p')
    exec "norm \<F5>"
endfunc


" Move line highlighting with window focus
autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline

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
