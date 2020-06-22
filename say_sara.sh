#!/bin/bash
LC_ALL=ru_RU.UTF-8
cnt=0

cat speech_mpga.txt | \
while read text; do

cnt=$((cnt+1))

#13_0
DISPLAY=:0.0 xdotool mousemove --sync  1351 800
DISPLAY=:0.0 xdotool click --delay 250 1

DISPLAY=:0.0 xdotool key --delay 250 ctrl+a ; DISPLAY=:0.0 xdotool  key --delay 250 BackSpace

DISPLAY=:0.0 xsel -c
echo "$text" | DISPLAY=:0.0 xsel -ib

DISPLAY=:0.0 xdotool key --delay 250 ctrl+v

sleep 1

#14_7
DISPLAY=:0.0 xdotool mousemove --sync 1458 896
DISPLAY=:0.0 xdotool click --delay 250 1

sleep  90

#14_7
DISPLAY=:0.0 xdotool mousemove --sync  1458 850
sleep 5
DISPLAY=:0.0 xdotool click --delay 250 3
sleep 5
DISPLAY=:0.0 xdotool key --delay 250 Up
sleep 5
DISPLAY=:0.0 xdotool key --delay 250 Up
sleep 5
DISPLAY=:0.0 xdotool key --delay 250 Up
sleep 5

DISPLAY=:0.0 xsel -c
echo "$cnt" | DISPLAY=:0.0 xsel -ib
sleep 1

DISPLAY=:0.0 xdotool key --delay 250 Return
sleep 5

DISPLAY=:0.0 xdotool key --delay 250 ctrl+v

sleep 1

DISPLAY=:0.0 xdotool key --delay 250 Return
sleep 10

done

ls -v ./Загрузки/*.mpga | sed "s/^/file '/" | sed  "s/$/'/" > list_sara.txt

ffmpeg -y -f concat -safe 0 -i list_sara.txt -c copy ~/mpga/hi.mp3

mv -f ./Загрузки/*.mpga ~/sara
