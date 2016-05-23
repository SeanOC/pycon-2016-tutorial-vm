#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

if [ ! -d exercises ]; then
	git clone https://github.com/sarguido/large-scale-data-analysis.git exercises
else
	cd exercises
	git fetch
	git rebase origin/master
fi