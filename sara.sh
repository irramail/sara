#!/bin/bash
while :;
do

keytext=$(redis-cli keys "mpgatext")
for key in $keytext
do
if  [[ "$key" == "mpgatext" ]]
then
  echo -n '' > speech_mpga.txt
  SUM=""
  BTEXT=`redis-cli get mpgatext`

  redis-cli set mpgabtext "$BTEXT"
  redis-cli get mpgatext > lines_mpga.txt
  for i in `cat  lines_mpga.txt`
  do
    li=${#i}
    ls=${#SUM}
    if [[ $((li + ls)) -gt 1000 && "$i" =~ "." ]]; then echo "$SUM $i" >> speech_mpga.txt; SUM=""; i=""; fi
    SUM="$SUM $i"
  done
  echo "$SUM" >> speech_mpga.txt

  ./say_sara.sh
  redis-cli set mpgastext ""

  redis-cli del mpgatext
fi
done


sleep 1;
done
