 /*
   APEX Alpha - Radio Telemetry Test with 2 Output Pins
   
   Daniel Saul
   Priyesh Patel
   
   18 July 2011

   (C) Copyright APEXHAB Team 2011
   team@apexhab.org
 */

char inData[200]; // Allocate some space for the string
char inChar=-1; // Where to store the character read
byte index = 0; // Index into array; where to store the character

void setup()
{
    pinMode(5,OUTPUT);
    pinMode(6,OUTPUT);
    Serial.begin(9600);
    rtty_tx("APEX Open Evening Demo\n");
    Serial.println("APEX Open Evening Demo");
    rtty_tx("Initialized.\n\n");
    Serial.println("Initialized.\n\n");


}

void loop()
{
    if(Serial.available()){
      Serial.println("---------------------------");
 Serial.println("Sending...\n");
       delay(100);
      
       while(Serial.available() > 0) {

            inChar = Serial.read(); // Read a character
            inData[index] = inChar; // Store it
            index++; // Increment where to write next
            inData[index] = '\0'; // Null terminate the string
   
       }
       rtty_tx("$APEX_OPENEVENINGDEMO: ");
       rtty_tx(inData);
       rtty_tx("\n");
       Serial.print("'");
       Serial.print("$APEX_OPENEVENINGDEMO: ");
       Serial.print(inData);
       Serial.print("'\n");
       Serial.println("Message Sent.\n\n");
       for (int i=0;i<199;i++) {
            inData[i]=0;
        }
        index=0;

    }
       
}

void rtty_tx(char * sentence)
{
    // Send a character at a time to the rtty_byte function :P
    char s;

    s = *sentence++;

    while(s != '\0')
    {
        rtty_byte(s);
        s = *sentence++;
    }
}

void rtty_byte(char s){
    // Send a byte at a time to the rtty_bit function

    int b;

    //Send a start bit
    rtty_bit(0);

    //Send rest of it
    for(b=0;b<8;b++)
    {
        if(s & 1)
        {
            rtty_bit(1);
        }
        else
        {
            rtty_bit(0);
        }

        s = s >> 1;
    }

    //Send 2 stop bits
    rtty_bit(1);
    rtty_bit(1);
}

void rtty_bit(int b)
{
    if(b)
    {   // if high
        digitalWrite(6,HIGH);
        digitalWrite(5,LOW);
    }
    else
    {   // if low
        digitalWrite(5,HIGH);
        digitalWrite(6,LOW);
    } 

    delayMicroseconds(3370);
}

