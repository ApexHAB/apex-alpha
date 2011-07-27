/**
 * Rtty.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "Rtty.h"

Rtty::Rtty()
{
}

void Rtty::init(int tx1_pin, int tx0_pin, int en_pin)
{
    _tx1_pin = tx1_pin;
    _tx0_pin = tx0_pin;
    _en_pin = en_pin;

    pinMode(_tx1_pin,OUTPUT);
    pinMode(_tx0_pin,OUTPUT);
    pinMode(_en_pin,OUTPUT);

    digitalWrite(_en_pin,HIGH);
}

char* Rtty::prepare(char* sentence)
{
    strcpy(_sentence,sentence);

    uint16_t checksum = _crc16_ccitt_checksum(_sentence);

    char checksum_string[6];
    sprintf(checksum_string,"*%04X",checksum);

    strcat(_sentence,checksum_string);
    strcat(_sentence,"\r\n");

    return _sentence;
}

void Rtty::tx()
{
    // Disable interrupts
    noInterrupts();

    int i=0;
    while(_sentence[i] != 0)
    {
        _tx_byte(_sentence[i]);
        i++;
    }

    // Re-enable interrupts
    interrupts();
}

void Rtty::set_baud(int baud)
{
    _baud = baud;
}

int Rtty::get_baud()
{
    return _baud;
}

void Rtty::preamble()
{
    char sentence[15] = "UUUUUUUUUUUU\r\n";

    // Disable interrupts
    noInterrupts();

    int i=0;
    while(sentence[i] != 0)
    {
        _tx_byte(sentence[i]);
        i++;
    }

    // Re-enable interrupts
    interrupts();
}

void Rtty::_tx_byte(char c)
{
    // Start bit
    _tx_bit(0);

    // Send byte
    for(int b=0; b<8; b++)
    {
        if(c & 1)
        {
            _tx_bit(1);
        }
        else
        {
            _tx_bit(0);
        }

        c = c >> 1;
    }

    // 2 Stop bits
    _tx_bit(1);
    _tx_bit(1);
}

void Rtty::_tx_bit(int b)
{
    if(b)
    {
        // If HIGH
        digitalWrite(_tx1_pin,HIGH);
        digitalWrite(_tx0_pin,LOW);
    }
    else
    {
        // If LOW
        digitalWrite(_tx1_pin,LOW);
        digitalWrite(_tx0_pin,HIGH);        
    }

    if(_baud == 300)
    {
        delayMicroseconds(3370);
    }
    else if(_baud == 50)
    {
        delayMicroseconds(10000);
        delayMicroseconds(10150);
    }
    else
    {
        // Otherwise 50 baud
        delayMicroseconds(10000);
        delayMicroseconds(10150);
    }
}

uint16_t Rtty::_crc16_ccitt_checksum(char* sentence)
{
    size_t i;
    uint16_t crc;
    uint8_t c;

    crc = 0xFFFF;

    // Skip the $$ at the beginning
    for (i=2; i<strlen(sentence); i++)
    {
        c = sentence[i];
        crc = _crc_xmodem_update(crc, c);
    }

    return crc;
}
