/**
 * SdLogger.h
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

class SdLogger
{
    public:
        SdLogger();
        void init(char* logFile);
        void log(char* sentence);
    private:
        char _logFile[15];
};

#endif
