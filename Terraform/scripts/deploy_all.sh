#!/bin/bash

components=("vpc" "database" "ecs" "redis")
for x in ${components[@]}; do
  ./terraform.sh $1 $x apply
done