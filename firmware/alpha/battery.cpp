/**
 * battery.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "battery.h"

float battery_get_voltage()
{
    float val = analogRead(BATTERY_PIN);
    float volts = ((val/1023)*BATTERY_REFERENCE_VOLTS) / BATTERY_RESISTOR_RATIO;
    return volts;
}
