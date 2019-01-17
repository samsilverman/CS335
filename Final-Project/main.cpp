#include "mbed.h"
#include "Adafruit_SGP30.h"
#include "PinDetect.h"

Adafruit_SGP30 sgp(p9, p10);

DigitalOut statusled1(LED1); // Used for indicating SGP30 warming up
DigitalOut statusled2(LED2); // Used for indicating an error when starting SGP30
DigitalOut statusled3(LED3); // Used for indicating an error when SGP30 is collecting measurments
DigitalOut statusled4(LED4); // Used for indicating an error when SGP30 is calibrating

PwmOut speaker(p21);

PwmOut warningleds(p26);

PinDetect increaseThresholdButton(p25); //uses PinDetect to handle switch debouncing
PinDetect decreaseThresholdButton(p24);
Timer debounce;

const uint16_t eCO2Thresholds[6] = {250, 350, 1000, 2000, 5000, 40000};
const int minThresholdIndex = 0;
const int maxThresholdIndex = 5;
int currentThresholdIndex = 2;
bool thresholdChanged = false;
bool eCO2PastThreshold = false;

void startSGP30() {
    printf("Starting SGP30...\n\r");
    if (!sgp.begin()) {
        printf("Error: Failed to find SGP30.\n\r");
        statusled2 = 1;
        while(1) {}
    }
}

void calibrateSGP30() {
    uint16_t TVOC_base, eCO2_base;
    if (!sgp.getIAQBaseline(&eCO2_base, &TVOC_base)) {
        printf("Error: Failed to get baseline readings.\n\r");
        statusled4 = 1;
        while(1) {}
    }
    printf("****Baseline values: eCO2: 0x"); printf("%d", eCO2_base);
    printf(" & TVOC: 0x"); printf("%d****\n\r", TVOC_base);
}

uint16_t getECO2Reading() {
    if (!sgp.IAQmeasure()) {
        printf("Error: Failed to get TVOC/eCO2 measurments.\n\r");
        statusled3 = 1;
        while(1) {}
    }
    printf("eCO2 "); printf("%d", sgp.eCO2); printf(" ppm\n\r");
    return sgp.eCO2;   
}

void pauseDetection() {
    if (eCO2PastThreshold == true) {
        warningleds = !warningleds;
        speaker.period(1.0/969.0);
        speaker = 0.5;
        wait(.5);
        speaker.period(1.0/800.0);
        warningleds = !warningleds;
        wait(.5);
        speaker = 0.0;
    }
    else {
        wait(1);
    }
}

void increaseThreshold() {
    if (debounce.read_ms() > 100) {
        if (currentThresholdIndex < maxThresholdIndex) {
            currentThresholdIndex++;
            thresholdChanged = true;
        } 
    }
}

void decreaseThreshold() {
    if (debounce.read_ms() > 100) {
        if (currentThresholdIndex > minThresholdIndex) {
            currentThresholdIndex--;
            thresholdChanged = true;
        }
    }
}

void detectThresholdChange() {
    if (thresholdChanged == true) {
        thresholdChanged = false;
        printf("****Threshold change to %d ppm****\n\r", eCO2Thresholds[currentThresholdIndex]);
    }
}

int main() {
    debounce.start();
    increaseThresholdButton.mode(PullUp); //See link https://os.mbed.com/users/4180_1/notebook/pushbuttons/
    increaseThresholdButton.attach_deasserted(&increaseThreshold);
    increaseThresholdButton.setSampleFrequency();
    
    decreaseThresholdButton.mode(PullUp);
    decreaseThresholdButton.attach_deasserted(&decreaseThreshold);
    decreaseThresholdButton.setSampleFrequency();
    
    startSGP30();
    
    statusled1 = 1;
    for(int i = 0; i < 20; i++) {
        getECO2Reading();
        wait(1);
    }
    statusled1 = 0;
    
    int counter = 0;
    
    while(1) {
        detectThresholdChange();
        counter++;
        if (counter == 30) {
            counter = 0;
            calibrateSGP30();
        }
        uint16_t reading = getECO2Reading();
        if (reading >= eCO2Thresholds[currentThresholdIndex]) {
            eCO2PastThreshold = true;
        }
        else {
            eCO2PastThreshold = false;
        }
        pauseDetection();
    }
}
