#!/bin/bash
#  A small Bash script to set up User LED3 to blink and turn off from 
#  the Linux console.

# define the LED path to control
LED3_PATH=/sys/class/leds/beaglebone:green:usr3

# New command line arguments:
# The funciton takes either "blink" or "off" as first arguments.
# The function takes any integer as an optional second argument
# only if the first agrument is "blink".


# create a function that displays an error message
function errorMessage
{
        echo "Argument was not recognized! Usage is: "
        echo -e "  led-hw5 Command Number \n  where Command is either "
        echo -e "  'blink' or 'off', and Number is a positive integer "
        echo -e " \n e.g. led-hw5 blink 6 "
        echo -e " \n or \n led-hw5 off "
}


# Example bash function
function removeTrigger
{
  echo "none" >> "$LED3_PATH/trigger"
}


echo "Starting the LED Bash Script"
if [ $# -eq 0 ]; then
	errorMessage
	exit 2
elif [ $# -gt 2 ]; then
	errorMessage
	exit 3
else
	# re-state the first command line argument
	echo "The LED Command that was passed is: $1"
	
	# if the first command line argument is blink...
	if [ $1 == "blink" ]; then

		# if no second argument...
		if [ $# -eq 1 ]
		then
			# display the error message and exit
			errorMessage
			exit 1

		# otherwise, there must be 2 arguments
		else
			# display how many times the LED will blink
			echo "blinking the LED $2 time(s)"
			
			# blink the LED the number of times specified by the
			# second command line argument.
			for (( n=1; n<=$2; n++ ))
			do
				echo "1" >> $LED3_PATH/brightness # turn LED3 on
				sleep 1 # wait for one second
				echo "0" >> $LED3_PATH/brightness # turn LED3 off
				sleep 1 # wait for one second
			done
		fi

	# if the first command line argument is on...
	elif [ $1 == "on" ]; then
		# tell the user the LED is turning on
		echo "Turning the LED on"
		# clear the curent trigger setting
		removeTrigger
		# turn LED3 on by writing 1 to brightness
		echo "1" >> "$LED3_PATH/brightness"
	
	# if the first command line argument is off...
	elif [ $1 == "off" ]; then
		# tell the user the LED is turning off
		echo "Turning the LED off"
		# clear the current trigger setting
		removeTrigger
		# turn LED3 off by writing 0 to brightness
		echo "0" >> "$LED3_PATH/brightness"

	# if the first command line argument is flash...
	elif [ $1 == "flash" ]; then
		# tell the user the LED will flash
		echo "Flashing the LED"
		# clear current trigger setting
		removeTrigger
		# write timer to trigger for LED3
		echo "timer" >> "$LED3_PATH/trigger"
		# wait for one second to let trigger finish writing
		sleep 1
		# use delay on/delay off to flash the LED
		echo "100" >> "$LED3_PATH/delay_off"
		echo "100" >> "$LED3_PATH/delay_on"
	
	# if the first command line argument is status...
	elif [ $1 == "status" ]; then
		# display the current trigger setting
		cat "$LED3_PATH/trigger";


	# otherwise there must be the correct number of arguments (1 or 2),
	# but the command is misspelled.
	else
		errorMessage
		exit 4
	fi
fi

# display end of script
echo "End of the LED Bash Script"
