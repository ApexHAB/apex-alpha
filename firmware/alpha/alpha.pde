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
#include "Counter.h"
#include "Rtty.h"

// Define constants [pin numbers]
#define LED_PIN 13
#define TEMPERATURE_PIN 2
#define GPS_RX 3
#define GPS_TX 4
#define TX_1 5
#define TX_0 6
#define NTX2_EN 7
#define SD_CS 10

#define LOG_FILENAME "alpha.log"

// Addresses of sensors
byte ext_temp_addr[8] = {0x28, 0xE1, 0x5D, 0x3E, 0x03, 0x00, 0x00, 0xC0};
byte int_temp_addr[8] = {0x28, 0x15, 0x8B, 0x51, 0x03, 0x00, 0x00, 0xA6};

// Create instances of classes
Led status_led;
Temp temp_sensor;
Gps gps_receiver;
Counter tick_counter;
Rtty radio;

// Define RTTY protocol
char sentence_delimiter[] = "$$";
char callsign[] = "ALPHA";
char field_delimiter[] = ",";

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

    // Initialise SD card
    Serial.print("  - SD Card... ");
    //
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
    tick_counter.inc();

    // Get data from external sensors and devices
    get_data();

    // Construct the packet
    build_packet();

    // Store sent packet and prepare packet
    char packet_sent[220];
    strcpy(packet_sent,radio.prepare(packet));

    Serial.print("Telemetry started... ");

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
    
    // Write packet to SD card
    //

    // Print packet to serial
    Serial.print(packet_sent);

    // Delay until the next packet
    // This window is also for UART commands to be entered in
    delay(8000);

    // Check for any inputted UART commands
    uart_commands();
}

/**
 * Get data from external sensors and receivers
 */
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

/**
 * Build the packet
 */
void build_packet()
{
    // Empty the packet variable
    sprintf(packet,"");

    // $$ and callsign
    strcat(packet,sentence_delimiter);
    strcat(packet,callsign);
    strcat(packet,field_delimiter);

    // Tick counter
    char counter_temp[6];
    sprintf(counter_temp,"%u",tick_counter.get());
    strcat(packet,counter_temp);
    strcat(packet,field_delimiter);

    // GPS string
    strcat(packet,gps_data);
    strcat(packet,field_delimiter);

    // External temperature
    strcat(packet,ext_temp);
    strcat(packet,field_delimiter);

    // Internal temperature
    strcat(packet,int_temp);
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
