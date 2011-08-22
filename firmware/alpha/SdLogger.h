/**
 * sdlogger.h
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#ifndef SDLOGGER_H
#define SDLOGGER_H

#include "WProgram.h"
#include "Fat16.h"
#include "Fat16util.h"

void sdlogger_log(char* sentence);

#endif
