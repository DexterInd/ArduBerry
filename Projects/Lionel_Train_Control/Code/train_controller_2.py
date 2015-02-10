import serial
import time

while True:
	try:

		# Open a file
		fo = open("/var/www/test.txt", "r")
		switch_state = fo.read()
		fo.close()
		# print "Switch State: " + str(switch_state)	# Print the value of the file

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
