#vim-BtrPrint
Better printing for vim.

##About
BtrPrint is a plugin that runs atop vim's builtin :hardcopy command. Currently only adds support for colour themes seperate from the main vim theme, but hopefully in a future release, there will be print to PDF support as well as arbitrary monospaced font selection for PDFs.

##Installation
Place BtrPrint.vim under the ~/.vim/plugin directory, or use vundle/pathogen to install.
To set a default colour scheme, place 'let g:BtrPrint_colour = [colourScheme]' into ~/.vimrc

##How to use
If you'd just like to use  use it as you would :hardcopy
