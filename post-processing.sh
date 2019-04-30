#!/bin/bash
# Maintained by Qiao-Le He


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
