#!/bin/bash

CalcFromFile()
{
    file="$1";

    # 0. filter non-cpp files
    suffix=${file##*.};
    if [ $suffix != 'cpp' ] && [ $suffix != 'h' ]; then
        return;
    fi

    # 1. filter comments /* ... */
    sed -r ':a; s%(.*)/\*.*\*/%\1%; ta; /\/\*/ !b; N; ba' "$file" > "$file.tmp.1"

    # 2. filter comment //
    grep -v -e '^[[:space:]]*//' "$file.tmp.1" > "$file.tmp.2"

    # 3. filter blank line
    #line=`grep -v -e '^[[:space:]]*$' $1 | grep -v -e '^[[:space:]]*{[[:space:]]*$' | grep -v -e '^[[:space:]]*}[[:space:]]*$' | wc -l`
    line=`grep -v -e '^[[:space:]]*$' "$file.tmp.2" | wc -l`

    # 4. delete temporaray files
    rm "$file.tmp.1" "$file.tmp.2" -rf

    echo "file: $file, valid line number: $line"
    all_lines=$(($all_lines+$line))
}

CalcFromDir()
{
    for item in `ls $1`
    do
        child="$1/$item"
        if [ -f "$child" ]; then
            CalcFromFile "$child"
        else
            CalcFromDir $child
        fi
    done
}

main()
{
    file="$1"

    if [ -f "$file" ]; then
        CalcFromFile "$file"
    elif [ -d "$file" ]; then
        CalcFromDir "$file"
    else
        echo "Please input a valid file or directory"
        exit -2
    fi

    echo "--------------------------------------------------"
    echo "all valid line number: $all_lines"
    echo "--------------------------------------------------"
    echo;
}

###############################################################

if [ $# != 1 ]; then
    echo "Please input your file or directory";
    exit -1;
fi

all_lines=0;

main $1
