/**
 * EEPROM Testing
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "EEPROM.h"

void setup()
{
    Serial.begin(9600);

    // Write a 0 to all 512 bytes of the EEPROM
    for (int i = 0; i < 512; i++)
        EEPROM.write(i, 0);

    // Write uint16 to EEPROM
    uint16_t counter = 12478;
    EEPROM.write(0,(byte) (0xFF & counter));
    EEPROM.write(1,(byte) (counter >> 8));

    // Read uint16 from EEPROM
    byte lowByte = EEPROM.read(0);
    byte highByte = EEPROM.read(1);
    uint16_t newcounter = (highByte << 8) | lowByte;

    Serial.println(newcounter);
}

void loop()
{
}
