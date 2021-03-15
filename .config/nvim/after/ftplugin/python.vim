" PEP8 standards
set shiftwidth=4 tabstop=4 softtabstop=4
set expandtab autoindent smartindent
set colorcolumn=80
set foldmethod=indent
set nofoldenable

let b:ale_linters = ['flake8', 'pylint']
let b:ale_fixers = [
    \'autopep8',
    \'black',
    \'isort',
    \'add_blank_lines_for_python_control_statements'
    \]
