#	This is an example on how to send and receive data from the Arduberry via Serial
#
#	Karan Nayan
#	Initial Date: 23 May 2014
#	http://www.dexterindustries.com/
#!/usr/bin/python
import serial
ser = serial.Serial('/dev/ttyAMA0',  9600, timeout = 0)	#Open the serial Port
ser.flushInput()	# Clear the input buffer

#Recieve a line from the Arduberry and return it back
def receive():
  while True:
	state = ser.readline()
	if len(state):	#If something was read from the Serial Port, read and return the line
		return state
 
#Send data to the Arduberry
def send(input):
	ser.write(input)
	
while True:
	try:
		send('s')
		print receive(),
	except KeyboardInterrupt:	#If program is terminated, close the serial port before exiting
		ser.close()