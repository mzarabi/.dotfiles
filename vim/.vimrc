" Set leader key to SPACE
let mapleader = " "

imap jk <ESC>
set hlsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
nmap <silent> <C-l> :nohlsearch <CR>

set rtp+=/opt/homebrew/opt/fzf


function! CommentFile()
    let l:filetype = &filetype

    if l:filetype =~ 'c\|cpp\|java\|javascript\|typescript'
        execute ':%s/^/\/\//g'
    elseif l:filetype =~ 'python\|sh\|yaml\|ruby\|perl\|dockerfile'
        execute ':%s/^/#/g'
    elseif l:filetype =~ 'lua'
        execute ':%s/^/-- /g'
    elseif l:filetype == 'css'
        " Wrap the entire file in block comments
        if getline(1) !~ '^/\*' && getline('$') !~ '\*/$'
            execute '1s/^/\/\*/'   " Add /* at the first line
            execute '$s/$/\*\//'   " Add */ at the last line
        else
            echo "File is already commented!"
        endif
    else
        echo "No comment style found for this filetype!"
    endif
endfunction

function! UncommentFile()
    let l:filetype = &filetype

    if l:filetype =~ 'c\|cpp\|java\|javascript\|typescript'
        execute ':%s/^\/\///g'
    elseif l:filetype =~ 'python\|sh\|yaml\|ruby\|perl\|dockerfile'
        execute ':%s/^#//g'
    elseif l:filetype =~ 'lua'
        execute ':%s/^-- //g'
    elseif l:filetype == 'css'
        " Remove block comments
        if getline(1) =~ '^/\*' && getline('$') =~ '\*/$'
            execute '1s/^\/\*//'
            execute '$s/\*\///'
        else
            echo "No block comment found to remove!"
        endif
    else
        echo "No uncomment style found for this filetype!"
    endif
endfunction

" Mappings
nnoremap <Leader>c :call CommentFile()<CR>
nnoremap <Leader>u :call UncommentFile()<CR>





