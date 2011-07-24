/**
 * Counter.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "Counter.h"

Counter::Counter()
{
}

void Counter::init()
{
    // To reset the counter (in EEPROM) on init
    //reset();
}

uint16_t Counter::get()
{
    byte lowByte = EEPROM.read(EEPROM_LOW_BYTE);
    byte highByte = EEPROM.read(EEPROM_HIGH_BYTE);
    return ((highByte << 8) | lowByte);
}

void Counter::set(uint16_t new_counter)
{
    EEPROM.write(EEPROM_LOW_BYTE, (byte) (0xFF & new_counter));
    EEPROM.write(EEPROM_HIGH_BYTE, (byte) (new_counter >> 8));
}

void Counter::inc()
{
    uint16_t temp_counter = get();
    temp_counter++;
    set(temp_counter);
}

void Counter::reset()
{
    set(0);
}
