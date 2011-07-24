/**
 * Counter.h
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#ifndef COUNTER_H
#define COUNTER_H

#include "WProgram.h"
#include "EEPROM.h"

#define EEPROM_LOW_BYTE 0
#define EEPROM_HIGH_BYTE 1

class Counter
{
    public:
        Counter();
        void init();
        uint16_t get();
        void set(uint16_t new_counter);
        void inc();
        void reset();
    private:
};

#endif
