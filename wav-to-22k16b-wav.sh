#!/bin/bash
mkdir -p output
for i in *.wav; do
  sox "$i" -b 16 output/$(basename $i) channels 1 rate 22k
done
