#!/bin/bash

PROGRAM=./silk

# expect input expected_output
function expect {
  a=$(mktemp)
  echo -e "$1" | timeout 5 $PROGRAM "$a"
  r=$(lli "$a")

  if [ "$r" != "$2" ]; then
    echo -e "\e[31mExpected $2 but got $r (in case $1)\e[m"
    exit 1
  else
    echo -e "\e[32mpass $1\e[m"
  fi
}

function failed {
  a=$(mktemp)
  echo "$1" | timeout 5 $PROGRAM "$a"
  if [ "$?" == "0" ]; then
    echo -e "\e[31mExpected fail\e[m"
    exit 1
  else
    echo -e "\e[32mfailed $1\e[m"
  fi
}

expect "100" "100"
expect "20" "20"
expect "-10" "-10"
expect "100 +   200" "300"
expect "100+-200" "-100"
expect "100+200+300+400" "1000"
expect "1+2*3+4" "11"
expect "2*3/6" "1"
expect "2*4/6" "1"
expect "2*3/6" "1"
expect "2*3/8" "0"
expect "4/3-2*1+5" "4"
expect "4/(3-2)*(1+5)" "24"
expect "100\n200+300" "500"

failed "abcd"