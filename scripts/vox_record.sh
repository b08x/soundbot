#!/usr/bin/env bash


RECORDINGS="$HOME/Storage/recordings/thinkings"

trap "exit" INT TERM ERR
trap "kill 0" EXIT
#if already started, this command will yield an error
#complaining that it's already being commanded to do stuff
#which should be ok because using the backslash between these two commands will allow both commands to run regardless if the first one fails. Otherwise, using "&&" would prevent timemachine from opening as those symbols indicate that any command after the first one will not run if the first one fails.
zita-a2j -j powermic -d hw:PowerMicIINS -c 1 & \
ZITA_PID="$!"


sleep 1

timemachine -a -b -20.0 -e -35.0 -T 30 -t 30 powermic:capture_1 -f wav -s -p "$RECORDINGS/tm-" &

wait




#ideally, when closing timemachine, the zita process would also stop. as it stands, which is an odd way of explaining current circumstances, the zita prcess remains running in the background after timemachine is closed.
#I'm not sure if I care about this? Well, if I had the time to be particular, sure this is a nice detail.
