
if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Cursor key selection
  let macvim_hig_shift_movement = 1

  " Command-T for CommandT
  macmenu &File.New\ Tab key=<nop>
  map <D-t> :CommandT<CR>
  imap <D-t> <Esc>:CommandT<CR>
  " let g:CommandTAcceptSelectionMap='' 
  " let g:CommandTAcceptSelectionTabMap='<CR>'
  "
  set selectmode=

  " Command-Shift-F for Ack
  macmenu Window.Toggle\ Full\ Screen\ Mode key=<nop>
  map <D-F> :Ack<space>

  " Command-e for ConqueTerm
  map <D-e> :call StartTerm()<CR>


  " Command-Shift-T for Taglist suport
  macmenu File.Open\ Tab\.\.\. key=<nop>
  " map <D-T> :TlistToggle<CR>

  " delimitMate fixes
  imap <M-Left> <Plug>delimitMateC-Left
  imap <M-Right> <Plug>delimitMateC-Right
  imap <D-Left> <Plug>delimitMateHome
  imap <D-Right> <Plug>delimitMateEnd

  " open tabs with command-<tab number>
  map <D-1> :tabn 1<CR>
  map <D-2> :tabn 2<CR>
  map <D-3> :tabn 3<CR>
  map <D-4> :tabn 4<CR>
  map <D-5> :tabn 5<CR>
  map <D-6> :tabn 6<CR>
  map <D-7> :tabn 7<CR>
  map <D-8> :tabn 8<CR>
  map <D-9> :tabn 9<CR>

	macmenu &File.Save key=<nop>
	" map <D-s> :w<CR>
	" imap <D-s> <Esc>:w<CR>
endif

" Start without the toolbar
set guioptions-=T
set go-=L
set go-=l
set go-=r
set go-=R


" Source the vimrc file after saving it
if has("autocmd")
  autocmd! bufwritepost .gvimrc source  $MYGVIMRC
endif


" Default gui color scheme done in .vimrc script...

" set guifont=Bitstream\ Vera\ Sans\ Mono:h12
set guifont=Menlo:h12

" ConqueTerm wrapper
function! StartTerm()
  execute 'ConqueTerm ' . $SHELL . ' --login'
  setlocal listchars=tab:\ \ 
endfunction

" Project Tree
" autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd FocusGained * call s:UpdateNERDTree()
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" If the parameter is a directory, cd into it
function! s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . a:directory
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function! s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif

  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

" Utility function!  to create file commands
function! s:CommandCabbr(abbreviation, expansion)
  execute 'cabbrev ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction

function! s:FileCommand(name, ...)
  if exists("a:1")
    let funcname = a:1
  else
    let funcname = a:name
  endif

  execute 'command -nargs=1 -complete=file ' . a:name . ' :call ' . funcname . '(<f-args>)'
endfunction

function! s:DefineCommand(name, destination)
  call s:FileCommand(a:destination)
  call s:CommandCabbr(a:name, a:destination)
endfunction

" Public NERDTree-aware versions of builtin function! 
function! ChangeDirectory(dir, ...)
  execute "cd " . a:dir
  let stay = exists("a:1") ? a:1 : 1

  NERDTree

  if !stay
    wincmd p
  endif
endfunction

function! Touch(file)
  execute "!touch " . a:file
  call s:UpdateNERDTree()
endfunction

function! Remove(file)
  let current_path = expand("%")
  let removed_path = fnamemodify(a:file, ":p")

  if (current_path == removed_path) && (getbufvar("%", "&modified"))
    echo "You are trying to remove the file you are editing. Please close the buffer first."
  else
    execute "!rm " . a:file
  endif

  call s:UpdateNERDTree()
endfunction

function! Mkdir(file)
  execute "!mkdir " . a:file
  call s:UpdateNERDTree()
endfunction

function! Edit(file)
  if exists("b:NERDTreeRoot")
    wincmd p
  endif

  execute "e " . a:file

ruby << RUBY
  destination = File.expand_path(VIM.evaluate(%{system("dirname " . a:file)}))
  pwd         = File.expand_path(Dir.pwd)
  home        = pwd == File.expand_path("~")

  if home || Regexp.new("^" + Regexp.escape(pwd)) !~ destination
    VIM.command(%{call ChangeDirectory(system("dirname " . a:file), 0)})
  end
RUBY
endfunction

" Turn off balloneval as it's annoying!
set noballooneval

" Define the NERDTree-aware aliases
call s:DefineCommand("cd", "ChangeDirectory")
call s:DefineCommand("touch", "Touch")
call s:DefineCommand("rm", "Remove")
call s:DefineCommand("e", "Edit")
call s:DefineCommand("mkdir", "Mkdir")

" Include user's local vim config
" if filereadable(expand("~/.gvimrc.local"))
"   source ~/.gvimrc.local
" endif


set autoread

