#include <OneWire.h>

// Temperature Chip on pin 2
OneWire ds(2);

void setup()
{
    // Start serial at 9600 baud
    Serial.begin(9600);
}

void loop()
{
    byte i;
    byte data[9];
    byte addr[8];

    if ( !ds.search(addr) )
    {
        Serial.println("No more addresses");
        ds.reset_search();
        delay(1500);
        return;
    }

    Serial.print("ADDR = ");
    for ( i=0; i<8; i++ )
    {
        Serial.print(addr[i], HEX);
        Serial.print(" ");
    }
    Serial.println("");
}
