import serial
import json
import urllib
import time
backer_count=0
alert=' '
while True:
	try:
		alert=''	
		
		#Get data from kickstarter using Kimono's API
		results = json.load(urllib.urlopen("http://www.kimonolabs.com/api/cprwyx20?apikey=3c6697d3dc43fe0fbc6f9bfcbb9d21fa"))
		
		#Parse the data
		data= results['results']['collection3']
		comments= results['results']['collection2'][0]['number']
		total= results['results']['collection1'][0]['total']
		backers= results['results']['collection1'][0]['backers']
		
		#Print on terminal
		print "Comments:",comments,"Total:",total,"Backers:",backers
		goals=["$1:","$5:","$23:","$23P:","$37:","$84:","$185:","$900:"]
		backer_count=str(backer_count)
		backers=str(backers)
		for i in range(len(backer_count)):
			if backer_count[i] is backers[i]:		#if backer_count has not changed do nothing
				print " "
			else:
				print"New backer "					#if backer_count has changed, mark the alert flag for the horn
				alert='?'
				backer_count=backers
				break
				
		#Send data to arduberry
		ser = serial.Serial('/dev/ttyAMA0', 9600)  	# open first serial port
		#Since the OLED shield does not new lines 
		#'`'- parsed as a new line by Arduberry when printing on the OLED
		#'~'- parsed as clear screen on OLED by Arduberry
		#If first character on a message is '?' Arduberry blows the Air horn
		mesg="~"+str(alert)+"ARDUBERRY`"+total+'`'+"Backers:"+backers+'`'
		ser.write(mesg)      						#Send the message to arduberry
		for i in range(len(data)):
			ser.write(goals[i]+data[i]['count'][:-7]+'`')	#Send individual backer count
			print goals[i]+data[i]['count'][:-7]
		ser.close()   
		time.sleep(240)								#Run every 4 minutes(240 s)
	except:
		print "Error"