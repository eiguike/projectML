#!/bin/bash

DATE=`date +%Y-%m-%d:%H:%M:%S`
mkdir ./resultado_$DATE

for i in {1,3,5,7,9}; do
  cp main.m K$i.m
  sed -i 's/%##KNN##%/'"K = $i;"'/g' K$i.m
  printf "source K$i.m\nexit\n" > entrada$i
  octave-cli < entrada$i > ./resultado_$DATE/resultado_K$i &
done
