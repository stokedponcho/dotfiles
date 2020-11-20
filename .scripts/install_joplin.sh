#!/bin/bash

url="https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh"

[[ -f "Joplin_install_and_update.sh" ]] && rm "Joplin_install_and_update.sh"

wget -O - "$url" \
		| sed 's/\~\/\.joplin/\~\/\.software\/joplin/g' \
		| sed 's/${HOME}\/\.joplin/\${HOME}\/\.software\/\joplin/g' \
		> "Joplin_install_and_update.sh"
