#!/bin/bash

DATE=`date +%Y-%m-%d:%H:%M:%S`
mkdir ./resultado_$DATE

array[0]=0.99
array[1]=0.98
array[2]=0.97
array[3]=0.96
array[4]=0.95
array[5]=0.94
array[6]=0.93
array[7]=0.92
array[8]=0.91

for i in {0..8}; do
  cp main.m K$i.m
  sed -i 's/%##LOGISTIC##%/'"desired_variance = ${array[$i]};"'/g' K$i.m
  printf "source K$i.m\nexit\n" > entrada$i
  octave-cli < entrada$i > ./resultado_$DATE/resultado_$i.txt &
done

sleep 2
rm entrada*
rm K*
