" no swap file
set nobackup
set nowb
set noswapfile

" no tab, insert 4 whitespaces instead
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" auto indent and smart indent
set ai
set si

" well syntax
syntax enable

" file type support
filetype on
filetype plugin indent on

" highlight search result
set hlsearch

" show line number
set number

" Add $ACE_ROOT in the path, for search like gf
set path+=$ACE_ROOT

" tags file
set tags=./tags,$ACE_ROOT/ace/tags
