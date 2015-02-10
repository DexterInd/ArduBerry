#!/usr/bin/env python
# coding: utf-8

# This project controls a Lionel train switch using the Raspberry Pi and an Arduberry.  
# See more documentation on our website at https://www.dexterindustries.com/Arduberry/example-projects-with-arduberry-and-raspberry-pi/

import serial
import time

while True:	# Run a forever loop.  Just run until we run into an error.
	try:

		# Open a the "test.txt" file.  The last value of the switch in this file and was written by the PHP code.
		fo = open("/var/www/test.txt", "r")		# The file is saved at /var/www/
		switch_state = fo.read()				# Get the switch state.  It will either be 1 or 0.
		fo.close()					
		# print "Switch State: " + str(switch_state)	# Debugging: Print the value of the file

		#Send Serial data to arduberry
		ser = serial.Serial('/dev/ttyAMA0', 9600)  	# open first serial port

		if(switch_state == "1"):
			ser.write("1")  	# Send the value "1" over serial, throws the switch.
			print "Switched!" 	# Print to let the user know that we switched the switch.
			time.sleep(1)		# Give the team a 100 ms break.  They earned it!
		else:
			ser.write("0")		# Send the value "0" over the serial, throw the switch in the opposite direction.
			print "Switched back!"	# Print to . . .
			time.sleep(1)		# Team break, earned it, etc.

		ser.close() 			# Don't forget to close the serial line.
	except:
		print "Error"
