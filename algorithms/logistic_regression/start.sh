#!/bin/bash

array[0]=0
array[1]=0.01
array[2]=0.05
array[3]=0.1
array[4]=0.25
array[5]=0.5
array[6]=0.75
array[7]=1

for i2 in {1..5}; do
  DATE=`date +%Y-%m-%d:%H:%M:%S`
  mkdir ./resultado_$DATE
  for i in {0..7}; do
    cp main.m lambda$i.m
    sed -i 's/%##LOGISTIC##%/'"lambda = ${array[$i]}"'/g' lambda$i.m
    printf "source lambda$i.m\nexit\n" > entrada$i
    octave-cli < entrada$i > ./resultado_$DATE/resultado_lambda$i.txt &
  done
  sleep 13
  rm entrada*
  rm lambda*
done
