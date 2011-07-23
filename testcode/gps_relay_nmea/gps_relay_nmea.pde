/**
 * Relay NMEA from GPS from Software Serial to Hardware Serial
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "NewSoftSerial.h"

NewSoftSerial gps(3,4);

void setup()
{
    Serial.begin(9600);

    gps.begin(4800);
    gps.active();
}

void loop()
{
    while(!gps.available()) {}
    Serial.print(gps.read(),BYTE);
}
