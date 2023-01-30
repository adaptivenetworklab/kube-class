#!/bin/bash
i=1
while true; do
  if [[ "$i" -gt 10 ]]; then
       exit 1
  fi
  echo i: $i

  kubectl delete ns user$i
  ((i++))

done