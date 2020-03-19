#!/usr/bin/env bash


amixer -D hw:0 sset Master,0 60 unmute
amixer -D hw:0 sset Front,0 60 unmute
amixer -D hw:0 sset Surround,0 60 unmute
amixer -D hw:0 sset Center,0 60 unmute
amixer -D hw:0 sset LFE,0 60 unmute
amixer -D hw:0 set PCM 94%

sleep 0.5

#/usr/bin/jackd -P70 -p2048 -t2000 -dalsa -dhw:0 -r48000 -p512 -n2 -Xseq &

#sleep 0.5

#a2jmidid -e &
jack_control start && a2j_control start
