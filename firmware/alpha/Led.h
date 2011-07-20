/**
 * Led.h
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#ifndef LED_H
#define LED_H

#include "WProgram.h"

#define PULSE_DURATION 250

class Led
{
    public:
        Led();
        void init(int pin);
        void on();
        void off();
        void timer(int time, bool command = false);
    private:
        int _pin;
};

#endif
