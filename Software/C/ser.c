/*	This is an example on how to send and receive data from the Arduberry via Serial
//
//	Karan Nayan
//	Initial Date: 23 May 2014
//	http://www.dexterindustries.com/
//
//	To compile:
// 	gcc ser.c -l wiringPi
//
//	To run:
// 	./a.out
*/
#include <wiringSerial.h>
int main(void)
{
	int handle = serialOpen ("/dev/ttyAMA0", 9600);	//Open the Serial port
	serialFlush(handle);	//Clear the stream of old data packets
	while(1)
	{	
		serialPutchar (handle, 's');		//Send 's' to the Arduberry
		char inp=serialGetchar(handle);		//Receive the characters from the Arduberry
		printf("%c",inp);
	}
	return 0;
}