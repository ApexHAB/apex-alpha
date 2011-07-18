/*
   APEX Alpha - Radio Telemetry Test with 2 Output Pins
   Daniel Saul
   18 July 2011

   (C) Copyright APEXHAB Team 2011
   team@apexhab.org

 */

void setup()
{

}

void loop()
{
    //Now send to the splitIntoCharacters function
    splitIntoChars("a very long test string");
}

//Split into characters
void splitIntoChars(char * string)
{
    // Send a character at a time to the Bytes function :P
    char s;

    s = *string++;

    while( s != '\0'){
        Bytes(s);
        s = *string++;
    }
}


void Bytes(char s){
    // Send a byte at a time to the splitIntoBits function

    int b;

    //Send a start bit
    splitIntoBits(0);

    //Send rest of it
    for(b=0;b<8;b++){

        if(s & 1){
            splitIntoBits(1);
        }else{
            splitIntoBits(0);
        }

        s = s >> 1;
    }

    //Send 2 stop bits
    splitIntoBits(1);
    splitIntoBits(1);

}

void splitIntoBits(int abit)
{
    if(abit){                        //if high
        digitalWrite(5, HIGH);
        digitalWrite(6, LOW);
    }else{                           // if low
        digitalWrite(5, LOW);
        digitalWrite(6, HIGH);
    } 
    delayMicroseconds(3370);
}

