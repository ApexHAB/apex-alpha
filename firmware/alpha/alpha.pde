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

// Include header files
#include "Led.h"
#include "Temp.h"
#include "Gps.h"

// Define constants [pin numbers]
#define LED_PIN 13
#define TEMPERATURE_PIN 2
#define GPS_RX 3
#define GPS_TX 4

// Addresses of sensors
byte ext_temp_addr[8] = {0x28, 0xE1, 0x5D, 0x3E, 0x03, 0x00, 0x00, 0xC0};
byte int_temp_addr[8] = {0x28, 0x15, 0x8B, 0x51, 0x03, 0x00, 0x00, 0xA6};

// Create instances of classes
Led status_led;
Temp temp_sensor;
Gps gps_receiver;

// Define RTTY protocol
char sentence_start_marker[] = "$$";
char callsign[] = "ALPHA";
char field_separator[] = ",";
uint16_t counter = 0; // To be written to EEPROM later

// Define packet variable
char packet[200];

// Define variables for data
char ext_temp[10];
char int_temp[10];
char gps_data[50];

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
    Serial.print("  - Temperature Sensors... ");
    temp_sensor.init(TEMPERATURE_PIN);
    Serial.println("initialised");

    // Initialise GPS receiver
    Serial.print("  - GPS... ");
    gps_receiver.init(GPS_RX,GPS_TX);
    Serial.println("initialised");

    // System initialised and booted
    Serial.println("");
    Serial.println("Apex Alpha successfully booted");
    Serial.println("");

    Serial.print("Turning status LED off... ");
    // Turn status LED off after 0.5 second
    status_led.timer(500, false);
    Serial.println("done");
    Serial.println("");
}

void loop()
{
    // Increment the counter
    counter++;

    // Get data from external sensors and devices
    get_data();

    // Construct the packet
    build_packet();

    Serial.print(packet);
    
    delay(1000);
}

void get_data()
{
    // External temperature sensor
    char et[10];
    dtostrf(temp_sensor.get(ext_temp_addr),4,2,et);
    sprintf(ext_temp,"%s",et);
    // Internal temperature sensor
    char it[10];
    dtostrf(temp_sensor.get(int_temp_addr),4,2,it);
    sprintf(int_temp,"%s",it);
    // GPS receiver
    sprintf(gps_data,gps_receiver.getData());
}

void build_packet()
{
    // Empty the packet variable
    sprintf(packet,"");

    // $$ and callsign
    strcat(packet,sentence_start_marker);
    strcat(packet,callsign);
    strcat(packet,field_separator);

    // Tick counter
    char counter_temp[6];
    sprintf(counter_temp,"%u",counter);
    strcat(packet,counter_temp);
    strcat(packet,field_separator);

    // GPS string
    strcat(packet,gps_data);
    strcat(packet,field_separator);

    // External temperature
    strcat(packet,ext_temp);
    strcat(packet,field_separator);

    // Internal temperature
    strcat(packet,int_temp);

    // New line
    strcat(packet,"\r\n");
}
