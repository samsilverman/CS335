# SmartSmoke: Air Quality Regulator

SmartSmoke is my final project for the course COMPSCI 335: Inside the Box - How Computers Work.

## Description

SmartSmoke measures air quality and alerts users when hazerdous conditions arise. SmartSmoke measures total volatile organic compound (TVOC) concentration in the air and converts measurements to equivalent carbon-dioxide (eCO2) concentration. 

Using known levels of CO2 concentration from the Occupational Health and Safety Administration, SmartSmoke is able to determine if observed level of eCO2 concentration is dangerous and alerts users with sounds and seirens.

The level of threshold levels defined by the Occupational Health and Safety Administration are listed in the table below:

| CO2 Concentration (ppm) | Description                                                                                                                                                                                                     |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 250                     | Background (normal) outdoor air level.                                                                                                                                                                          |
| 350                     | Typical level found in occupied spaces with good air exchange.                                                                                                                                                  |
| 1,000                   | Level associated with complaints of drowsiness and poor air.                                                                                                                                                    |
| 2,000                   | Level associated with headaches, sleepiness, and stagnate, stale, stuffy air; poor concentration, loss of attention, increased heart rate and slight nausea may also be present.                                |
| 5,000                   | This indicates unusual air conditions where high levels of other gases also could be present. Toxicity or oxygen deprivation could occur. This is the permissible exposure limit for daily workplace exposures. |
| 40,000                  | This level is immediately harmful due to oxygen deprivation.                                                                                                                                                    |

## Equipment

- mbed LPC1768 microcontroller
- Adafruit SGP30 air quality sensor breakout - VOC and eCO2
- mini metal speaker
- 4 RGB tri-color LEDs
- 2 tactile switch buttons
- 1 kΩ resistor
- TIP102 NPN transistor

## Future Work

Unfortunately, due to the time constraints of the project I was unable to implement internet connectivity to the LPC1768. Ideally, I wanted SmartSmoke to send users email updates when harmful levels of CO2 were detected. Email support would further increase the "smartness" of SmartSmoke to allow for better management of large numbers of SmartSmokes and easier air quality control.

## What I Learned

I learned the basics of working with pulse width modulation as this was how I operated the speaker and warning lights. Additionally, I got to play around with various duty cycles/periods to get to a desired siren noise. Finally, I worked with the I2C serial protocol as this was how the SGP30 communicates with the LPC1768.
