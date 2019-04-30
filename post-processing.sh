#!/bin/bash
# Maintained by Qiao-Le He
# 

firstRow=NC01

for STRING in `cat strings`
do
    for VARIABLE in `cat files`
    do
        egrep -i $STRING $VARIABLE.csv | awk '{print $4, $3}' > $VARIABLE
    done
    paste `cat files` > $STRING
    rm `cat files`
done

cat `cat strings` > tmp
paste strings tmp > temp
cat files temp > output
rm tmp temp `cat strings`

