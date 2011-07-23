/**
 * Temp.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "Temp.h"

Temp::Temp()
{
}

void Temp::init(int pin)
{
    _pin = pin;
}

float Temp::get(uint8_t* addr)
{
    OneWire ds(_pin);
    byte data[9];

    // Reset OneWire and then select specified sensor
    ds.reset();
    ds.select(addr);

    // Start conversion
    ds.write(0x44);

    // Wait while conversion is in process
    while(digitalRead(_pin) == 0) {}

    // Read scratchpad
    ds.reset();
    ds.select(addr);
    ds.write(0xBE);

    // Put scratchpad data into data
    for(byte i = 0; i<9; i++)
    {
        data[i] = ds.read();
    }

    // Form temperature data in float temp
    float temp = ( (data[1] << 8) + data[0] ) * 0.0625;

    // Error temperature
    float error = 999.99;

    // Check CRC8 checksum and then return data
    if(OneWire::crc8(data, 8) == data[8])
    {
        return temp;
    }
    else
    {
        return error;
    }
}
