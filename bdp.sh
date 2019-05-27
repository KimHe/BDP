#!/bin/bash

echo " "
echo "                :-) BASH-based data post-processing (BDP) (-:"
echo " "
echo "                       BDP is written by Qiao-Le He"
echo " "
echo -e "\t copyright (c) 2019, East China University of Science and"
echo -e "\t  Technology, 200237 Shanghai, China"
echo " "
echo -e "\t check out https://github.com/KimHe/BDP for more information"
echo " "
echo -e "\t BDP is free software; you can redistribute it and/or modify"
echo -e "\t it under the terms of the GNU Lesser General Public License"
echo " "


while [[ "$#" -gt 0 ]];
do
    case $1 in
        -h|--help) help=1; shift;;
        -t|--trans) trans=1;;
        -s|--sort) sort=1;;
        -g|--generate) generate=1;;
        -c|--check) check=1;;
        *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift;
done

if [ "$help" == 1 ];
then
    echo "[SYNOPSIS]:"
    echo -e "\t bash bdp.sh -h"
    echo -e "\t bash bdp.sh -t"
    echo -e "\t bash bdp.sh -g -c -s"
    echo ""
    echo "[OPTIONS]:"
    echo -e "\t -h, --help"
    echo -e "\t \t Display help information and exit"
    echo -e "\t -t, --trans"
    echo -e "\t \t Convert the plain txt files from xlsx docs and exit"
    echo -e "\t -g, --generate"
    echo -e "\t \t Generate the STRING file from the raw data"
    echo -e "\t -s, --sort"
    echo -e "\t \t Strings are numerically or alphabetically sorted"
    echo -e "\t -c, --check"
    echo -e "\t \t Check whether the STRINGS pattern is qualified for this program. Square brackets [] will be replaced with \[\]. Trailing spaces will be omitted. Spaces between names will be replaced with \s."
    echo " "
    exit 0
fi

if [ "$trans" == 1 ];
then
    for TRANS in `cat files`
    do
        ssconvert -O 'separator"    " format=raw' $TRANS.xlsx $TRANS.txt
    done
    echo "[INFO]: The CSV docs have been converted from the XLSX docs"
    echo ""
    exit 0
fi

# Generate STRINGS from the raw datasets
if [ "$generate" == 1 ];
then
    for VARIABLE in `cat files`
    do
        cat $VARIABLE.txt | awk '{print $7, $8, $9, $10, $11, $12, $13}' | sort -n > $VARIABLE
    done
    cat `cat files` > strings
    rm `cat files`
    echo "[INFO]: The STRINGS file has been generated from the raw data"
    echo ""
fi

# Sort element names in the STRING
if [ "$sort" == 1 ];
then
    sort -n strings > strings_sorted
    sort -u strings_sorted > strings_unique
    mv strings_unique strings | rm strings_sorted
    echo "[INFO]: The elements in the STRING have been sorted"
    echo ""
fi

cp strings .strings

# Check the pattern of element names in the STRING
if [ "$check" == 1 ];
then
    # Trailing
    sed -i 's/\s\+$//g' .strings
    # Suppress file names start with .
    sed -i 's/^\.//g'   .strings
    # Replace square brackets
    sed -i 's/\[/\\[/g' .strings
    sed -i 's/\]/\\]/g' .strings
    # Replace spaces of file names with \s
    sed -i 's/ /\\s/g'  .strings
    # Replace asterisks with dot
    sed -i 's/*/./g' .strings
    echo "[INFO]: The pattern of STRINGS has been checked and modified"
    echo ""
fi


# Extract Retention information
for STRING in `cat .strings`
do
    for VARIABLE in `cat files`
    do
        grep -i -w $STRING $VARIABLE.txt | awk '{print $2}' | sort -n | tail -1 > $VARIABLE
    done
    paste `cat files` > $STRING
    rm `cat files`
    echo -n "."
done
echo ""

cat `cat .strings` > tmp
paste .strings tmp > temp
cat files temp > BDP_Retention.out
rm tmp temp `cat .strings`


# Extract Area information
for STRING in `cat .strings`
do
    for VARIABLE in `cat files`
    do
        grep -i -w $STRING $VARIABLE.txt | awk '{print $3}' | sort -n | tail -1 > $VARIABLE
    done
    paste `cat files` > $STRING
    rm `cat files`
    echo -n "."
done
echo ""

cat `cat .strings` > tmp
paste .strings tmp > temp
cat files temp > BDP_Area.out
rm tmp temp `cat .strings`


# Extract Relative information
for STRING in `cat .strings`
do
    for VARIABLE in `cat files`
    do
        grep -i -w $STRING $VARIABLE.txt | awk '{print $4}' | sort -n | tail -1 > $VARIABLE
    done
    paste `cat files` > $STRING
    rm `cat files`
    echo -n "."
done
echo ""

cat `cat .strings` > tmp
paste .strings tmp > temp
cat files temp > BDP_Relative.out
rm tmp temp `cat .strings`


if [ "$check" == 1 ];
then
    sed -i 's/\\\[/\[/g' BDP_Area.out
    sed -i 's/\\\]/\]/g' BDP_Area.out
    sed -i 's/\\\[/\[/g' BDP_Relative.out
    sed -i 's/\\\]/\]/g' BDP_Relative.out
    sed -i 's/\\\[/\[/g' BDP_Retention.out
    sed -i 's/\\\]/\]/g' BDP_Retention.out
    sed -i 's/\\s/ /g'   BDP_Area.out
    sed -i 's/\\s/ /g'   BDP_Relative.out
    sed -i 's/\\s/ /g'   BDP_Retention.out
    echo ""
fi

echo "[INFO]: DONE"
