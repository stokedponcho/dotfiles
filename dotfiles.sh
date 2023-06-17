#!/bin/bash

stow . -v  \
	--ignore .stowrc					\
	--ignore .disabled				\
	--ignore .gitmodules			\
	--ignore dotfiles.sh			\
	--ignore README.md
