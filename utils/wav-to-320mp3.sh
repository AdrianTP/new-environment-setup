#!/usr/bin/env bash
mkdir -p output
for i in *.wav; do
  # sox "$i" output/"$i.mp3" rate -v
  lame -q 2 --cbr -b 320 -F "$i" output/"$i.mp3"
done

