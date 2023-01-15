#!/bin/bash
i=2
while true; do
  if [[ "$i" -gt 10 ]]; then
       exit 1
  fi
  echo i: $i

  kubectl create ns user$i
  ((i++))

done