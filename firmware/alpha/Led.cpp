/**
 * Led.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "Led.h"

Led::Led()
{
}

void Led::init(int pin)
{
    _pin = pin;
    pinMode(_pin, OUTPUT);
}

void Led::on()
{
    digitalWrite(_pin, HIGH);
}

void Led::off()
{
    digitalWrite(_pin, LOW);
}

void Led::timer(int time, bool command)
{
    delay(time);
    if(command) digitalWrite(_pin, HIGH);
    else digitalWrite(_pin, LOW);
}
