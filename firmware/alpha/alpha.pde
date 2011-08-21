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
#include "Temp.h"
#include "Gps.h"
#include "Counter.h"
#include "Rtty.h"
#include "SdLogger.h"
#include "Battery.h"

// Define constants [pin numbers]
#define STATUS_LED_PIN 13
#define TEMPERATURE_PIN 2
#define GPS_RX 3
#define GPS_TX 4
#define TX_1 5
#define TX_0 6
#define NTX2_EN 7
#define BATT_PIN 0

#define LOG_FILENAME "ALPHA.LOG"

// Addresses of sensors
byte ext_temp_addr[8] = {0x28, 0x13, 0xF7, 0x73, 0x03, 0x00, 0x00, 0x2F};
byte int_temp_addr[8] = {0x28, 0x35, 0x8C, 0x5E, 0x03, 0x00, 0x00, 0xDB};

// Create instances of classes
Temp temp_sensor;
Gps gps_receiver;
Counter tick_counter;
Rtty radio;
SdLogger sdcard;
Battery batt;

// Define packet variable
char packet[200];

// Temperature variables
char ext_temp[10];
char int_temp[10];

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
    pinMode(STATUS_LED_PIN,OUTPUT);
    digitalWrite(STATUS_LED_PIN,HIGH);

    // Initialise tick counter
    Serial.print("  - Counter... ");
    tick_counter.init();
    Serial.println("initialised");

    // Initialise temperature sensors
    Serial.print("  - Temperature Sensors... ");
    temp_sensor.init(TEMPERATURE_PIN);
    Serial.println("initialised");

    // Initialise GPS receiver
    Serial.print("  - GPS... ");
    gps_receiver.init(GPS_RX,GPS_TX);
    Serial.println("initialised");

    // Initialise radio module
    Serial.print("  - Radio Module... ");
    radio.init(TX_1,TX_0,NTX2_EN);
    Serial.println("initialised");

    // Initialise battery sensor
    Serial.print("  - Battery Sensor... ");
    batt.init(BATT_PIN);
    Serial.println("initialised");

    // Initialise SD card
    Serial.print("  - SD Card... ");
    sdcard.init(LOG_FILENAME);
    Serial.println("initialised");

    // System initialised and booted
    Serial.println("");
    Serial.println("Apex Alpha successfully booted");
    Serial.println("");

    // Turn status LED off
    digitalWrite(STATUS_LED_PIN,LOW);

    // Blank line to serial
    Serial.println("");
}

void loop()
{
    // Increment the counter
    tick_counter.inc();

    // Get data from external sensors and devices and then construct the packet
    build_packet();

    // Store sent packet and prepare packet
    sprintf(packet,radio.prepare(packet));

    // Print packet to serial
    Serial.print(packet);

    // Write packet to SD card
    sdcard.log(packet); 

    // Telemetry
    Serial.print("Telemetry started... ");
    //digitalWrite(STATUS_LED_PIN,HIGH); // SPI bus is in use

    // Send the packet with RTTY
    // @ 300 baud - preamble then 3 times
    radio.set_baud(300);
    radio.preamble();
    radio.tx();
    radio.tx();
    radio.tx();
    // @ 50 baud - preamble then 2 times
    radio.set_baud(50);
    radio.preamble();
    radio.tx();
    radio.tx();

    Serial.println("finished");
    //digitalWrite(STATUS_LED_PIN,LOW); // SPI bus is in use
    
    // Delay until the next packet
    // This window is also for UART commands to be entered in
    delay(8000);

    // Check for any inputted UART commands
    uart_commands();
}
/**
 * Build the packet
 */
void build_packet()
{
    // External temperature sensor
    char et[10];
    dtostrf(temp_sensor.get(ext_temp_addr),4,2,et);
    // Internal temperature sensor
    char it[10];
    dtostrf(temp_sensor.get(int_temp_addr),4,2,it);

    // Build the packet
    sprintf(packet,"$$ALPHA,%u,%s,%s,%s",tick_counter.get(),gps_receiver.getData(),et,it);
}

/**
 * Check for any commands via UART 
 */
void uart_commands()
{
    if(Serial.available() >= 4)
    {
        // A $ signifies the start of a 3 character command
        while((Serial.available() > 0) && (Serial.read() != '$')) {}

        if(Serial.available() >= 3)
        {
            char data[4];
            for(int i=0; i<3; i++)
            {
                data[i] = Serial.read();
            }
            data[3] = 0;
            
            uart_commands_parse(data);
        }
    }

    Serial.flush();
}

/**
 * Parse UART command 
 */
void uart_commands_parse(char* cmd)
{
    if(strcmp(cmd,"RTC") == 0)
    {
        tick_counter.reset();
    }
}
