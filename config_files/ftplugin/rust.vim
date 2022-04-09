" Run rust file
command! -nargs=* Run :vsplit | terminal cd '%:h'; cargo run
