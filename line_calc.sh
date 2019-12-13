#!/bin/sh

if [ $# != 1 ]; then
    echo "Please input your file"
    exit -1;
fi

file="$1"
echo -n "file: $file, valid line number: "

# 1. filter comments /* ... */
sed -r ':a; s%(.*)/\*.*\*/%\1%; ta; /\/\*/ !b; N; ba' "$file" > "$file.tmp.1"

# 2. filter comment //
grep -v -e '^[[:space:]]*//' "$file.tmp.1" > "$file.tmp.2"

# 3. filter blank line
#line_no=`grep -v -e '^[[:space:]]*$' $1 | grep -v -e '^[[:space:]]*{[[:space:]]*$' | grep -v -e '^[[:space:]]*}[[:space:]]*$' | wc -l`
line_no=`grep -v -e '^[[:space:]]*$' "$file.tmp.2" | wc -l`
echo $line_no

# 4. delete temporaray files
rm "$file.tmp.1" "$file.tmp.2" -rf
