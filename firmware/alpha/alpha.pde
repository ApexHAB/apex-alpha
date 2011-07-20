/**
 * alpha.pde
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

#define LED_PIN 13

Led board_led;

void setup()
{
    // Setup serial
    Serial.begin(9600);

    // 
    board_led.init(LED_PIN);
    board_led.on();

    
    board_led.timer(1000, false);
}

void loop()
{
}
