#!/usr/bin/env bash
count=0
while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Text read from file: $line"

  name=$(sed 's/^\(.*\)\..*$/\1/' <<< $1)
  outfile="${name}${count}.wav"
  echo "Writing file: ${outfile}"

  say -o $outfile --data-format=LEI16@22000 --channels=1 -v 'Daniel' $line
  ((count++));
done < "$1"
