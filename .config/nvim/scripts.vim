if did_filetype()
  finish
endif

if getline(1) =~ 'dash'
  setfiletype sh
endif
