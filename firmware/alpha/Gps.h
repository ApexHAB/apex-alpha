/**
 * Gps.h
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#ifndef GPS_H
#define GPS_H

#include "WProgram.h"
#include "NewSoftSerial.h"

class Gps
{
    public:
        Gps();
        void init(int rxpin, int txpin);
        char* getData();
    private:
        int _rxpin;
        int _txpin;
};

#endif
