/**
 * Battery.h
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#ifndef BATTERY_H
#define BATTERY_H

#include "WProgram.h"

class Battery
{
    public:
        Battery();
        void init(int pin);
    private:
        int _adcPin;
};

#endif
