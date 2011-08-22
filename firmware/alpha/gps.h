/**
 * gps.h
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

#define GPS_RX 3
#define GPS_TX 4

char* gps_get();
void gps_strCopy(char* str, char* dest, int pos, int len);

#endif
