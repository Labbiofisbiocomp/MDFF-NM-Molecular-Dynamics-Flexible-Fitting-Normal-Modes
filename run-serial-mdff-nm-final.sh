#!/bin/bash

# initial replica
i=1
# last replica
j=10

while [ $i -le $j ]
do

# run script

mkdir $i
cd ./$i
cp ../files/* .
cp ../inputs/* .
R -f mdff_nm.R  > output_${i}
cd ..

 echo $i
 i=$((i+1))

done
