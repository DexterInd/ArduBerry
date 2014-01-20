#include <Wire.h>
#include <SeeedGrayOLED.h>
#include <avr/pgmspace.h>

int horn=7;
void setup()
{
  Serial.begin(9600);
  Wire.begin();
  pinMode(horn, OUTPUT);
  SeeedGrayOled.init();             //initialize SEEED OLED display
  SeeedGrayOled.clearDisplay();     //Clear Display.
  SeeedGrayOled.setNormalDisplay(); //Set Normal Display Mode
  SeeedGrayOled.setVerticalMode();  // Set to vertical mode for displaying text
}
int data;
int x=0, y=0, erase =0, sound=0;
void loop()
{
  sound=0; 	//Turn of the Air horns 
  if(Serial.available()>0)
  {
    if(erase==1)						//Clear the screen when a new message comes
    {
      erase=0;
      SeeedGrayOled.init();             //initialize SEEED OLED display
      SeeedGrayOled.clearDisplay();     //Clear Display.
      SeeedGrayOled.setNormalDisplay(); //Set Normal Display Mode
      SeeedGrayOled.setVerticalMode();  //Set to vertical mode for displaying text
  
      x=0;y=0;							//Set x,y pointers back to origin 
    }
    data=Serial.read();
    Serial.print((char)data);
    if((char)data=='?')					//If '?' was received, then we had a new backer
    {
      sound=1;
    }
    else if((char)data=='`')			//If '`' received, then print a newline
    {
      y++;
      x=0;
    }
    else if((char)data=='~')			//If '~' received, then set the flag to clear the screen
    {
      erase=1;
    }
    else								//Otherwise, just print the message
    {
      SeeedGrayOled.setTextXY(y,x);
      SeeedGrayOled.putChar(data);
      Serial.print((char)data);
      x++;
    }
  }
  if(sound==1)							//Sound the Air horns if someone backed us
  {
    digitalWrite(horn,HIGH);
    delay(1000);
    digitalWrite(horn,LOW);
  }
}


