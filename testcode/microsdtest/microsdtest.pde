/**
 * Testing the interface with the MicroSD card
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include <SD.h>

File myFile;

void setup()
{
    Serial.begin(9600);
    Serial.print("Initializing SD card...");

    pinMode(10, OUTPUT);

    if (!SD.begin(10)) {
        Serial.println("initialization failed!");
        return;
    }
    Serial.println("initialization done.");

    myFile = SD.open("ALPHA.LOG", FILE_WRITE);

    if (myFile) {
        myFile.println("$$ALPHA,1,TEST,PACKET*FFFF");
        myFile.close();
    } else {
        Serial.println("error opening alpha.log");
    }
}

void loop()
{
}

