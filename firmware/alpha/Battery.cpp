/**
 * Battery.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "Battery.h"

Battery::Battery()
{
}

void Battery::init(int pin)
{
    _adcPin = pin;
}
