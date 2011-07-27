/**
 * Rtty.h
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#ifndef RTTY_H
#define RTTY_H

#include "WProgram.h"
#include "util/crc16.h"

class Rtty
{
    public:
        Rtty();
        void init(int tx1_pin, int tx0_pin, int en_pin);
        char* prepare(char* sentence);
        void tx();
        void set_baud(int baud);
        int get_baud();
        void preamble();
    private:
        int _tx1_pin;
        int _tx0_pin;
        int _en_pin;
        int _baud;
        char _sentence[200];
        void _tx_byte(char c);
        void _tx_bit(int b);
        uint16_t _crc16_ccitt_checksum(char* sentence);
};

#endif
