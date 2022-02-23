#!/bin/bash
# SPDX-License-Identifier: MIT
# Author: Mark Gutenberger <mark-gutenberger@outlook.com>
# clang-format.sh (c) 2022
# Desc:
# Created:  2022-02-23T03:36:52.086Z
# Modified: 2022-02-23T04:13:39.284Z



THIS_PATH="$(realpath "$0")"
THIS_DIR="$(dirname "$THIS_PATH")"
IGNORE="node_modules/**/*"
FILE_LIST="$(find . -type d -name node_modules -prune \
-o -name '*.c' \
-o -name '*.cc' \
-o -name '*.cpp' \
-o -name '*.h' \
-o -name '*.hh' \
-o -name '*.hpp' \
-o -name '*.m' \
-o -name '*.hm' \
-o -name '*.cs' \
-o -name '*.rc' \
-o -name -print)"

echo -e "\e[0;33mFiles found to format = \n\"\"\"\n$FILE_LIST\n\"\"\"\e[0m"

clang-format --verbose -i --style=file $FILE_LIST
