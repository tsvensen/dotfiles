" This must be first, because it changes other options as a side effect.
set nocompatible " This setting prevents vim from emulating the original vi's bugs and limitations.

" add utf-8 support
set fileencodings=utf-8,latin2

if !has('gui_running')
    " Compatibility for Terminal
    let g:solarized_termtrans=1

    if (&t_Co >= 256 || $TERM == 'xterm-256color')
        " Do nothing, it handles itself.
    else
        " Make Solarized use 16 colors for Terminal support
        let g:solarized_termcolors=16
    endif
endif

syntax enable
set background=dark
colorscheme solarized



set bs=2    " allow backspacing over everything in insert mode
set ai      " always set autoindenting on
"set backup " keep a backup file
"set viminfo='20,\"50  " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50    " keep 50 lines of command line history
set ruler    " show the cursor position all the time
set tabstop=2 " ts
set noet "automatically convert tab chars into spaces
set shiftwidth=2 " sw
set softtabstop=2 " sts
set expandtab " added 2012.03.20
set smarttab
set showmatch
set nowrapscan
set nowrap
set nohlsearch
set incsearch
set ignorecase
set nohlsearch
set wmnu
set list
set iskeyword+=-
set lcs=tab:+-
"set guifont=8x13bold

nmap <silent> ,/ :nohlsearch<CR> " clear highlighted searches instead of /asdf


" Nerd Tree specific
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1

"nnoremap :set paste! "avoid staircase affect when pasting mulitple lines
"nnoremap <F5> :set invpaste paste?<Enter>
map <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5> " hit F5 before and after pasting


" UPDATED 2010.08.05
set complete=.,w,b,u,t,i,k " keyword completion with CTRL-P or N
" :help options -> left off at line 2570

autocmd BufRead *.asp set smartindent cinwords=if,elsif,else,for,while,try,except,finally,sub,class,switch,case
autocmd BufRead *.htx set smartindent cinwords=if,elsif,else,for,while,try,except,finally,sub,class,switch,case
autocmd BufRead *.js set smartindent cinwords=if,else,for,while,try,except,finally,function,switch,case
autocmd BufRead *.pl set smartindent cinwords=if,elsif,else,for,while,try,except,finally,sub,class,switch,case
autocmd BufRead *.php set smartindent cinwords=if,elseif,else,for,while,try,except,finally,function,class,switch,case
autocmd BufRead *.phpx set smartindent cinwords=if,elseif,else,for,while,try,except,finally,function,class,switch,case
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" / END UPDATED 2010.08.05



" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif



" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 "autocmd BufRead *.txt set tw=78

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  autocmd BufReadPre,FileReadPre  *.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost  *.gz call GZIP_read("gunzip")
  autocmd BufReadPost,FileReadPost  *.bz2 call GZIP_read("bunzip2")
  autocmd BufWritePost,FileWritePost  *.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost  *.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre      *.gz call GZIP_appre("gunzip")
  autocmd FileAppendPre      *.bz2 call GZIP_appre("bunzip2")
  autocmd FileAppendPost    *.gz call GZIP_write("gzip")
  autocmd FileAppendPost    *.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    " set 'cmdheight' to two, to avoid the hit-return prompt
    let ch_save = &ch
    set ch=3
    " when filtering the whole buffer, it will become empty
    let empty = line("'[") == 1 && line("']") == line("$")
    let tmp = tempname()
    let tmpe = tmp . "." . expand("<afile>:e")
    " write the just read lines to a temp file "'[,']w tmp.gz"
    execute "'[,']w " . tmpe
    " uncompress the temp file "!gunzip tmp.gz"
    execute "!" . a:cmd . " " . tmpe
    " delete the compressed lines
    '[,']d
    " read in the uncompressed lines "'[-1r tmp"
    set nobin
    execute "'[-1r " . tmp
    " if buffer became empty, delete trailing blank line
    if empty
      normal Gdd''
    endif
    " delete the temp file
    call delete(tmp)
    let &ch = ch_save
    " When uncompressed the whole buffer, do autocommands
    if empty
      execute ":doautocmd BufReadPost " . expand("%:r")
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      execute "!" . a:cmd . " <afile>:r"
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    execute "!" . a:cmd . " <afile>"
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

endif " has("autocmd")



au BufNewFile,BufRead *.php,*.php3,*.inc,*.module,*.info,*.install set ft=php
au BufNewFile,BufRead *.nqc,*.cpp,*.c,*.as                         set ft=cpp
au BufNewFile,BufRead *.cgi,*.plx,*.pl                             set ft=perl
au BufNewFile,BufRead *.scss                                       set ft=scss



" MY ADDITIONS : 2008.12.11

" Shortcuts for moving between tabs.
" Alt-j to move to the tab to the left
noremap <A-j> gT
" Alt-k to move to the tab to the right
noremap <A-k> gt

" tComment
"map <leader>c <c-_><c-_>


" http://www.vim.org/scripts/script.php?script_id=2540
filetype off
filetype indent plugin on




set rtp+=~/.vim/bundle/vundle/
 call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-surround'

Bundle 'tpope/vim-fugitive'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
  let g:gist_clip_command = 'pbcopy'
  let g:gist_show_privates = 1

Bundle 'mutewinter/vim-css3-syntax'
Bundle 'pangloss/vim-javascript'
Bundle 'leshill/vim-json'
Bundle 'nono/vim-handlebars'
" Bundle 'othree/html5.vim'

" Includes scss/sass
Bundle 'tpope/vim-haml'

" Snipmate with dependancies
" Snippets are here : https://github.com/honza/vim-snippets
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"
Bundle "garbas/vim-snipmate"

Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
  autocmd vimenter * if !argc() | NERDTree | endif


" CtrlP File Finder
Bundle 'kien/ctrlp.vim'
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX
  let g:ctrlp_map = '<c-f>'
