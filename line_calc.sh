#!/bin/sh

if [ $# != 1 ]; then
    echo "Please input your file"
    exit -1;
fi

echo -n "file: $1, line number: "
line_no=`grep -v -e '^[[:space:]]*$' $1 | grep -v -e '^{[[:space:]]*$' | grep -v -e '^[[:space:]]*}$' | wc -l`
echo $line_no
