// This program uses assembly to get the lights on the MBED LPC1768 
// microcontroller to display the low order 4 bits of a value passed in
// by a C program for a time that is passed as a second parameter (I/O 
// port driver and assembly delay loop subroutine)

#include "mbed.h"

extern "C" int my_leds(int value);

// Initialize LEDs
DigitalOut myled1(LED1);
DigitalOut myled2(LED2);
DigitalOut myled3(LED3);
DigitalOut myled4(LED4);

int main() {
    int value = 0;
    // Loop forever
    while(1) {
        // Call assembly language function to set LEDs
        my_leds(value);
        myled1 = myled2 = myled3 = myled4 = 0;
        // Increment value mod 16 to run through patterns
        value = (value + 1) % 16;
    }
}
