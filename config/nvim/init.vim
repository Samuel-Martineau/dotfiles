""""""""""""""""""""""""""""""""""""""""""" Inspiré par """"""""""""""""""""""""""""""""""""""""""""
" - https://medium.com/better-programming/setting-up-neovim-for-web-development-in-2020-d800de3efacd
" - https://medium.com/better-programming/setting-up-neovim-for-web-development-in-2020-d800de3efacd
" - https://github.com/rafi/vim-config
" - https://github.com/cheperuiz/dotfiles/blob/master/.vimrc
" - https://gist.github.com/benawad/b768f5a5bbd92c8baabd363b7e79786f
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""" Prérequis """""""""""""""""""""""""""""""""""""""""""""""
" - Node.js
" - Neovim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function DownloadVplug()
  let plug_path = stdpath('data') . '/site/autoload/plug.vim'
  if (empty(glob(plug_path)))
    silent execute ("!curl -fLo " . plug_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

function LoadPlugins()
  call plug#begin()
  Plug 'joshdick/onedark.vim'
  Plug 'preservim/nerdcommenter'
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'prettier/vim-prettier', { 'do': 'npm install' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'mattn/emmet-vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'preservim/nerdcommenter'
  Plug 'sheerun/vim-polyglot'
  Plug 'lambdalisue/suda.vim'
  Plug 'neoclide/npm.nvim', {'do' : 'npm install'}
  Plug 'tpope/vim-fugitive'
  call plug#end()
endfunction

function LoadTheme()
  if (has("termguicolors"))
    set termguicolors
  endif
  syntax enable
  colorscheme onedark
endfunction

function ConfigureNerdTree()
  let g:NERDTreeShowHidden = 1
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeIgnore = []
  let g:NERDTreeStatusline = ''
  let g:NERDTreeIgnore = ['^node_modules$']
  " Automaticaly close nvim if NERDTree is only thing left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " Toggle
  nnoremap <silent> <C-b> :NERDTreeToggle<CR>
endfunction

function ConfigurePrettier()
  let g:prettier#autoformat = 1
  let g:prettier#autoformat_require_pragma = 0
  let g:prettier#config#single_quote = "true"
  let g:prettier#config#trailing_comma = "all"
  let g:prettier#config#quote_props = "consistent"
  let g:prettier#config#arrow_parens = "always"
endfunction

function ConfigureTerminalEmulator()
  " open new split panes to right and below
  set splitright
  set splitbelow
  " turn terminal to normal mode with escape
  tnoremap <Esc> <C-\><C-n>
  " start terminal in insert mode
  au BufEnter * if &buftype == 'terminal' | :startinsert | endif
  " open terminal on ctrl+n
  function! OpenTerminal()
    split term://zsh
    resize 10
  endfunction
  nnoremap <C-N> :call OpenTerminal()<CR>
endfunction

function ConfigureCOC()
  nmap <F2> <Plug>(coc-rename)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  inoremap <silent><expr> <c-space> coc#refresh()
  set cmdheight=2
  set updatetime=300
  set shortmess+=c
  if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
  else
    set signcolumn=yes
  endif
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  autocmd CursorHold * silent call CocActionAsync('highlight')
endfunction

function ConfigureTMUXNavigator()
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <C-J> :TmuxNavigateLeft<cr>
  nnoremap <silent> <C-L> :TmuxNavigateRight<cr>
  nnoremap <silent> <C-I> :TmuxNavigateUp<cr>
  nnoremap <silent> <C-K> :TmuxNavigateDown<cr>
endfunction

function ConfigureBufferTabs()
  let g:airline#extensions#tabline#enabled = 1
  nnoremap <silent> <F5> :bn<CR>
  nnoremap <silent> <F6> :bp<CR>
endfunction

function ConfigureTabulation()
  " Use spaces instead of tabs
  set expandtab

  " Be smart when using tabs ;)
  set smarttab

  " 1 tab == 2 spaces
  set shiftwidth=2
  set tabstop=2
  set softtabstop=2

  " Linebreak on 500 characters
  set lbr
  set tw=500

  set ai "Auto indent
  set si "Smart indent
  set nowrap "Wrap lines
endfunction

:call DownloadVplug()
:call LoadPlugins()
:call LoadTheme()
:call ConfigureNerdTree()
:call ConfigurePrettier()
:call ConfigureTerminalEmulator()
:call ConfigureCOC()
:call ConfigureTMUXNavigator()
:call ConfigureBufferTabs()
:call ConfigureTabulation()

set mouse=a
set number
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', 'node_modules']
map <C-c> "+y<CR>
let g:user_emmet_mode='a'
set autoread
au FocusGained,BufEnter * checktim"
filetype plugin on