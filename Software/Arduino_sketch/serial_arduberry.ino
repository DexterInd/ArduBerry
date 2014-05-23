void setup() 
{
  Serial.begin(9600);  //Start the Serial at 9600 baud
}

void loop() 
{
  if(Serial.read()=='s') //If 's' is recieved, send the data back 
  {
    int sensorValue = analogRead(A0);
    Serial.print("Hi");
    Serial.println(sensorValue);  //Send 'hi' followed by the analog read value
  }
  delay(1000);       
}
