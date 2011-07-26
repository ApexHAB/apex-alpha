#include "Fat16.h"
#include "Fat16util.h"

void setup()
{
}

void loop()
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

    char name[] = "ALPHA.LOG";

    if(!file.open(name, O_CREAT | O_APPEND | O_WRITE))
    {
        return;
    }

    file.println("$$ALPHA,789,1234.5678,12345.6789,00123,05,23.45,23.45*FFFF");
    
    file.close();
}
