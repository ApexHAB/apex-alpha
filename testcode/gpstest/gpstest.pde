/**
 * GPS Test
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "NewSoftSerial.h"

NewSoftSerial gps(3,4);

char nmeatype[6] = "GPGGA";

void setup()
{
    Serial.begin(9600);

    gps.begin(4800);
    gps.active();
}

void loop()
{
    Serial.println(getGPS());
}

char* getGPS()
{
    while(gps.read() != '$') {}

    char serbuf[6];
    serbuf[5] = 0;

    for (int i=0; i<5; i++)
    {
        while (!gps.available()) {}
        serbuf[i] = gps.read();
    }

    bool matches = true;

    for (int i=0; i<5; i++)
    {
        if(nmeatype[i] != serbuf[i])
        {
            matches = false;
        }
    }

    if(matches)
    {
        char data[100] = "";
        data[0] = 0;
        int i = 1;

        while(data[i-1] != 13)
        {
            while(!gps.available()) {}
            data[i] = gps.read();
            i++;
        }

        char parsed[50]; 

        // Check for GPS Fix
        if(data[37] == '1' || data[37] == '2')
        {
            // Parse data
            char hours[3];
            hours[0] = data[2];
            hours[1] = data[3];
            hours[2] = 0;

            char minutes[3];
            minutes[0] = data[4];
            minutes[1] = data[5];
            minutes[2] = 0;

            char seconds[3];
            seconds[0] = data[6];
            seconds[1] = data[7];
            seconds[2] = 0;

            char latitude[10];
            latitude[0] = data[12];
            latitude[1] = data[13];
            latitude[2] = data[14];
            latitude[3] = data[15];
            latitude[4] = '.';
            latitude[5] = data[17];
            latitude[6] = data[18];
            latitude[7] = data[19];
            latitude[8] = data[20];
            latitude[9] = 0;

            char latitude_ns[2];
            if(data[22] == 'S')
            {
                latitude_ns[0] = '-';
            }
            else
            {
                latitude_ns[0] = 0;
            }
            latitude_ns[1] = 0;

            char longitude[11];
            longitude[0] = data[24];
            longitude[1] = data[25];
            longitude[2] = data[26];
            longitude[3] = data[27];
            longitude[4] = data[28];
            longitude[5] = '.';
            longitude[6] = data[30];
            longitude[7] = data[31];
            longitude[8] = data[32];
            longitude[9] = data[33];
            longitude[10] = 0;

            char longitude_ew[2];
            if(data[35] == 'W')
            {
                longitude_ew[0] = '-';
            }
            else
            {
                longitude_ew[0] = 0;
            }
            longitude_ew[1] = 0;

            char satellites[3];
            satellites[0] = data[39];
            satellites[1] = data[40];
            satellites[2] = 0;
            
            char altitude[6];
            altitude[0] = data[47];
            altitude[1] = data[48];
            altitude[2] = data[49];
            altitude[3] = data[50];
            altitude[4] = data[51];
            altitude[5] = 0;

            strcpy(parsed,hours);
            strcat(parsed,":");
            strcat(parsed,minutes);
            strcat(parsed,":");
            strcat(parsed,seconds);
            strcat(parsed,",");
            strcat(parsed,latitude_ns);
            strcat(parsed,latitude);
            strcat(parsed,",");
            strcat(parsed,longitude_ew);
            strcat(parsed,longitude);
            strcat(parsed,",");
            strcat(parsed,altitude);
            strcat(parsed,",");
            strcat(parsed,satellites);
            strcat(parsed,",");

            return parsed;
        }
        else return ",,,,,";
    }
    else getGPS();
}
