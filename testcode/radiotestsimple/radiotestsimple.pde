 /*
   APEX Alpha - Radio Telemetry Test with 2 Output Pins
   
   Daniel Saul
   Priyesh Patel
   
   18 July 2011

   (C) Copyright APEXHAB Team 2011
   team@apexhab.org
 */

void setup()
{
    pinMode(5,OUTPUT);
    pinMode(6,OUTPUT);

    // Enable NTX2
    pinMode(7,OUTPUT);
    digitalWrite(7,HIGH);
}

void loop()
{
    rtty_tx("$$ALPHA,a,very,long,test,string,is,being,sent,over,rtty!\n");
    delay(2000);
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

