#include <Wire.h>
#include <avr/pgmspace.h>

int rel_1 = 4;
int rel_2 = 5;

void setup()
{
  Serial.begin(9600);
  Wire.begin();
  // initialize the digital pin as an output.
  pinMode(rel_1, OUTPUT);     
  pinMode(rel_2, OUTPUT);  
 
}
int data;
int x=0, y=0, erase =0, sound=0;
void loop()
{
  sound=0; 	//Turn of the Air horns 
  if(Serial.available()>0)
  {
    data=Serial.read();
    if((char)data=='0')					//If '?' was received, then we had a new backer
    {
      digitalWrite(rel_1, HIGH);   // turn the LED on (HIGH is the voltage level)
      digitalWrite(rel_2, LOW);
      delay(1000);               // wait for a second
    }
    else if((char)data=='1')			//If '`' received, then print a newline
    {
      digitalWrite(rel_1, LOW);    // turn the LED off by making the voltage LOW
      digitalWrite(rel_2, HIGH);
      delay(1000);               // wait for a second
    }
    else								//Otherwise, just print the message
    {
      digitalWrite(rel_1, LOW);    // turn the LED off by making the voltage LOW
      digitalWrite(rel_2, HIGH);
      delay(1000);               // wait for a second     
    }
  }
}


