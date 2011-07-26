/**
 * SdLogger.cpp
 *
 * Part of the Apex Alpha project
 * http://www.apexhab.org/alpha/
 *
 * Priyesh Patel
 *
 * (c) Copyright ApexHAB 2011
 * team@apexhab.org
 */

#include "SdLogger.h"

SdLogger::SdLogger()
{
}

void SdLogger::init(char* logFile)
{
    strcpy(_logFile,logFile);
}

void SdLogger::log(char* sentence)
{
    SdCard card;
    Fat16 file;

    if(!card.init())
    {
        return;
    }

    if(!Fat16::init(&card))
    {
        return;
    }

    if(!file.open(_logFile, O_CREAT | O_APPEND | O_WRITE))
    {
        return;
    }

    file.print(sentence);

    file.close();
}
