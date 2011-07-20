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
#include "Temp.h"

#define LED_PIN 13
#define TEMPERATURE_PIN 2

byte ext_temp_addr[8] = {0x28, 0xE1, 0x5D, 0x3E, 0x03, 0x00, 0x00, 0xC0};
byte int_temp_addr[8] = {0x28, 0x15, 0x8B, 0x51, 0x03, 0x00, 0x00, 0xA6};

Led status_led;
Temp temp_sensor;

void setup()
{
    // Setup serial
    Serial.begin(9600);

    Serial.println("/------------------------\\");
    Serial.println("|       Apex Alpha       |");
    Serial.println("\\------------------------/");
    Serial.println("");
    Serial.println("Initialising:");

    // Initialise status LED and then turn it on
    Serial.print("  - Status LED... ");
    status_led.init(LED_PIN);
    status_led.on();
    Serial.println("initialised");

    // Initialise temperature sensors
    Serial.print("  - Temperature sensors... ");
    temp_sensor.init(TEMPERATURE_PIN);
    Serial.println("initialised");

    // System initialised and booted
    Serial.println("");
    Serial.println("Apex Alpha successfully booted");
    Serial.println("");

    Serial.print("Turning status LED off... ");
    // Turn status LED off after 1 second
    status_led.timer(1000, false);
    Serial.println("done");
    Serial.println("");
}

void loop()
{
    Serial.println(temp_sensor.get(ext_temp_addr));
    Serial.println(temp_sensor.get(int_temp_addr));
    delay(1000);
}
