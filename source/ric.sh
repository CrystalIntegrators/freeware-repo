#!/bin/bash

for file in `find . -name "pkginfo"`; do
  echo -ne "${file}\t"
  echo -ne "`grep "NAME=" ${file}`\t"
  echo     "`grep "VERSION=" ${file} | grep -v "# VERSION="`"
done
"

