#!/bin/bash

array[0]=0.99
array[1]=0.98
array[2]=0.97
array[3]=0.96
array[4]=0.95
array[5]=0.94
array[6]=0.93
array[7]=0.92
array[8]=0.91

for i2 in {0..8}; do
  DATE=`date +%Y-%m-%d:%H:%M:%S`
  mkdir ./resultado_$DATE
  for i in {1,3,5,7,9}; do
    cp main.m K$i.m
    sed -i 's/%##KNN##%/'"K = $i"'/g' K$i.m
    sed -i 's/%##VARIANCE##%/'"desired_variance = ${array[$i2]}"'/g' K$i.m
    printf "source K$i.m\nexit\n" > entrada$i
    octave-cli < entrada$i > ./resultado_$DATE/resultado_K$i &
  done
  sleep 10
done
