#!/bin/bash

#
# taken from https://stackoverflow.com/questions/40095929/bash-countdownup-timer-w-alarm-improvements
# similar: https://stackoverflow.com/questions/3127977/how-to-make-the-hardware-beep-sound-in-mac-os-x-10-6
# watch/countdown: https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
# 

# default timeout
timeout_mins=10
# while testing your script, making changes, you want this to be something like 1 or 2
sec_per_min=1

# check for command line input
if [ 0 -ne $# ]
then
	# assign the first command line param, no check, if it is a number, though!
	timeout_mins=$1
	lang=$2
fi

# now it does make sense, to have a variable in the for loop core
# for i in $(seq $timeout_mins -1 1)
# do
#     echo -n "$i, "
#     sleep $sec_per_min
# done

# say -v '?' # list of all voices

case "$lang" in
	en)
		# say -v Ava "Break for $timeout_mins min."
		# say -v Victoria "Break for $timeout_mins min"
		cmd="say -v Allison 'Get up and break for 30 sec.'"
		;;
	pl)
		cmd="say -v Zosia 'Oderwi się od tego komputera, chociaż na 30 sekund.'"
		;;
	ru)
		# cmd="say -v Yuri 'Отойди от компьютера хотя бы на 30 секунд.'"
		cmd="say -v Milena 'Отойди от компьютера хотя бы на 30 секунд.'"
		;;
	de)
		cmd="say -v Anna 'Geh weg vom Computer, zumindest 30 Sekunden'"
		;;
	*)
		cmd="say 'Get up and break for 30 sec.'"
		# say -v Bells "dong dong dong"
		# say -v Bells "beep"
		;;
esac

while :
do
	# beep -r 25 -l 3 # doesn't work on MacOS
	
	# MacOS only?
	# tput bel
	$(`$cmd`)

	sleep $timeout_mins
done