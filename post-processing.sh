#!/bin/bash
# Maintained by Qiao-Le He

echo " "
echo "                :-) BASH based data post-processing (BDP) (-:"
echo " "
echo "                       BDP is written by Qiao-Le He"
echo " "
echo "          copyright (c) 2019, East China University of Science and"
echo "           Technology, Shanghai, China"
echo " "
echo "          check out https://github.com/KimHe/BDP for more information"
echo " "
echo "          BDP is free software; you can redistribute it and/or modify"
echo "          it under the terms of the GNU Lesser General Public License"
echo " "

if [ ! -z "$1" ];
then
    if [ $1 = 'sort' ];
    then
        sort -n strings | tee strings_sorted | mv strings_sorted strings
    fi
fi

for STRING in `cat strings`
do
    for VARIABLE in `cat files`
    do
        egrep -i $STRING $VARIABLE.csv | awk '{print $3}' | sort -n | tail -1 > $VARIABLE
    done
    paste `cat files` > $STRING
    rm `cat files`
done

cat `cat strings` > tmp
paste strings tmp > temp
cat files temp > BDP_Area.out
rm tmp temp `cat strings`

for STRING in `cat strings`
do
   for VARIABLE in `cat files`
   do
       egrep -i $STRING $VARIABLE.csv | awk '{print $4}' | sort -n | tail -1 > $VARIABLE
   done
   paste `cat files` > $STRING
   rm `cat files`
done

cat `cat strings` > tmp
paste strings tmp > temp
cat files temp > BDP_Relative.out
rm tmp temp `cat strings`
