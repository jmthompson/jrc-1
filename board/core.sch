EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 2 2
Title "JRC-3 Core Logic"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 65xx:W65C816SxPL U?
U 1 1 60EE18FC
P 2050 2650
F 0 "U?" H 1700 4050 50  0000 C CNN
F 1 "W65C816SxPL" H 2400 4050 50  0000 C CIB
F 2 "" H 2050 4650 50  0001 C CNN
F 3 "http://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf" H 2050 4550 50  0001 C CNN
	1    2050 2650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60EE31B8
P 1950 850
F 0 "#PWR?" H 1950 700 50  0001 C CNN
F 1 "+5V" H 1965 1023 50  0000 C CNN
F 2 "" H 1950 850 50  0001 C CNN
F 3 "" H 1950 850 50  0001 C CNN
	1    1950 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 850  1950 1000
Wire Wire Line
	2050 1100 2050 1000
Wire Wire Line
	2050 1000 1950 1000
Connection ~ 1950 1000
Wire Wire Line
	1950 1000 1950 1100
$Comp
L power:GND #PWR?
U 1 1 60EE43AC
P 1950 4500
F 0 "#PWR?" H 1950 4250 50  0001 C CNN
F 1 "GND" H 1955 4327 50  0000 C CNN
F 2 "" H 1950 4500 50  0001 C CNN
F 3 "" H 1950 4500 50  0001 C CNN
	1    1950 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 4200 1950 4350
Wire Wire Line
	2150 4200 2150 4350
Wire Wire Line
	2150 4350 2050 4350
Connection ~ 1950 4350
Wire Wire Line
	1950 4350 1950 4500
Wire Wire Line
	2050 4200 2050 4350
Connection ~ 2050 4350
Wire Wire Line
	2050 4350 1950 4350
$Comp
L 74xx:74HC245 U?
U 1 1 60EF0172
P 4650 3650
F 0 "U?" H 4400 4300 50  0000 C CNN
F 1 "74ACT245" H 4850 4300 50  0000 C CNN
F 2 "" H 4650 3650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 4650 3650 50  0001 C CNN
	1    4650 3650
	-1   0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60EF76DF
P 4650 2800
F 0 "#PWR?" H 4650 2650 50  0001 C CNN
F 1 "+5V" H 4665 2973 50  0000 C CNN
F 2 "" H 4650 2800 50  0001 C CNN
F 3 "" H 4650 2800 50  0001 C CNN
	1    4650 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 2800 4650 2850
$Comp
L power:GND #PWR?
U 1 1 60EFC4DE
P 4650 4550
F 0 "#PWR?" H 4650 4300 50  0001 C CNN
F 1 "GND" H 4655 4377 50  0000 C CNN
F 2 "" H 4650 4550 50  0001 C CNN
F 3 "" H 4650 4550 50  0001 C CNN
	1    4650 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 4450 4650 4550
Text GLabel 2800 2250 2    50   Output ~ 0
A8
Text GLabel 2800 2350 2    50   Output ~ 0
A9
Text GLabel 2800 2450 2    50   Output ~ 0
A10
Text GLabel 2800 2550 2    50   Output ~ 0
A11
Text GLabel 2800 2650 2    50   Output ~ 0
A12
Text GLabel 2800 2750 2    50   Output ~ 0
A13
Text GLabel 2800 2850 2    50   Output ~ 0
A14
Text GLabel 2800 2950 2    50   Output ~ 0
A15
Wire Wire Line
	2650 2250 2800 2250
Wire Wire Line
	2650 2350 2800 2350
Wire Wire Line
	2650 2450 2800 2450
Wire Wire Line
	2650 2550 2800 2550
Wire Wire Line
	2650 2650 2800 2650
Wire Wire Line
	2650 2750 2800 2750
Wire Wire Line
	2650 2850 2800 2850
Wire Wire Line
	2650 2950 2800 2950
Text GLabel 2800 1450 2    50   Output ~ 0
A0
Text GLabel 2800 1550 2    50   Output ~ 0
A1
Text GLabel 2800 1650 2    50   Output ~ 0
A2
Text GLabel 2800 1750 2    50   Output ~ 0
A3
Text GLabel 2800 1850 2    50   Output ~ 0
A4
Text GLabel 2800 1950 2    50   Output ~ 0
A5
Text GLabel 2800 2050 2    50   Output ~ 0
A6
Text GLabel 2800 2150 2    50   Output ~ 0
A7
Wire Wire Line
	2650 1450 2800 1450
Wire Wire Line
	2650 1550 2800 1550
Wire Wire Line
	2650 1650 2800 1650
Wire Wire Line
	2650 1750 2800 1750
Wire Wire Line
	2650 1850 2800 1850
Wire Wire Line
	2650 1950 2800 1950
Wire Wire Line
	2650 2050 2800 2050
Wire Wire Line
	2650 2150 2800 2150
Text GLabel 5300 3150 2    50   BiDi ~ 0
D0
Wire Wire Line
	5150 3150 5300 3150
Text GLabel 5300 3250 2    50   BiDi ~ 0
D1
Wire Wire Line
	5150 3250 5300 3250
Text GLabel 5300 3350 2    50   BiDi ~ 0
D2
Wire Wire Line
	5150 3350 5300 3350
Text GLabel 5300 3450 2    50   BiDi ~ 0
D3
Wire Wire Line
	5150 3450 5300 3450
Text GLabel 5300 3550 2    50   BiDi ~ 0
D4
Wire Wire Line
	5150 3550 5300 3550
Text GLabel 5300 3650 2    50   BiDi ~ 0
D5
Wire Wire Line
	5150 3650 5300 3650
Text GLabel 5300 3750 2    50   BiDi ~ 0
D6
Wire Wire Line
	5150 3750 5300 3750
Text GLabel 5300 3850 2    50   BiDi ~ 0
D7
Wire Wire Line
	5150 3850 5300 3850
Text GLabel 1300 2250 0    50   Input ~ 0
IRQB
Wire Wire Line
	1300 2250 1450 2250
Text GLabel 1300 2350 0    50   Input ~ 0
NMIB
Wire Wire Line
	1300 2350 1450 2350
Text GLabel 1300 2150 0    50   Input ~ 0
ABORTB
Wire Wire Line
	1300 2150 1450 2150
Text GLabel 1300 2650 0    50   Output ~ 0
RWB
Wire Wire Line
	1300 2650 1450 2650
Text GLabel 1300 3150 0    50   Output ~ 0
VPA
Wire Wire Line
	1300 3150 1450 3150
Text GLabel 1300 3050 0    50   Input ~ 0
BE
Wire Wire Line
	1300 3050 1450 3050
Text GLabel 1300 2950 0    50   Input ~ 0
RDY
Wire Wire Line
	1300 2950 1450 2950
Text GLabel 1300 3250 0    50   Output ~ 0
VDA
Wire Wire Line
	1300 3250 1450 3250
Text GLabel 1300 3450 0    50   Output ~ 0
VPB
Wire Wire Line
	1300 3450 1450 3450
NoConn ~ 1450 3550
NoConn ~ 1450 3750
NoConn ~ 1450 3850
Text GLabel 1300 1750 0    50   Input ~ 0
PHI2
Wire Wire Line
	1300 1750 1450 1750
Text GLabel 1300 1450 0    50   Input ~ 0
RESETB
Wire Wire Line
	1300 1450 1450 1450
Text GLabel 5300 4050 2    50   Input ~ 0
RWB
Wire Wire Line
	5150 4050 5300 4050
Text GLabel 5300 4150 2    50   Input ~ 0
PHI1
Wire Wire Line
	5150 4150 5300 4150
Wire Wire Line
	2650 3150 3550 3150
Wire Wire Line
	2650 3250 3450 3250
Wire Wire Line
	2650 3350 3350 3350
Wire Wire Line
	2650 3450 3250 3450
Wire Wire Line
	2650 3550 3150 3550
Wire Wire Line
	2650 3650 3050 3650
Wire Wire Line
	2650 3750 2950 3750
Wire Wire Line
	2650 3850 2850 3850
Text GLabel 4100 4900 2    50   Output ~ 0
BA0
Text GLabel 4100 5000 2    50   Output ~ 0
BA1
Text GLabel 4100 5100 2    50   Output ~ 0
BA2
Text GLabel 4100 5200 2    50   Output ~ 0
BA3
Text GLabel 4100 5300 2    50   Output ~ 0
BA4
Text GLabel 4100 5400 2    50   Output ~ 0
BA5
Text GLabel 4100 5500 2    50   Output ~ 0
BA6
Text GLabel 4100 5600 2    50   Output ~ 0
BA7
Wire Wire Line
	2850 5600 2850 3850
Wire Wire Line
	2850 5600 4100 5600
Connection ~ 2850 3850
Wire Wire Line
	2850 3850 4150 3850
Wire Wire Line
	2950 5500 2950 3750
Wire Wire Line
	2950 5500 4100 5500
Connection ~ 2950 3750
Wire Wire Line
	2950 3750 4150 3750
Wire Wire Line
	3050 5400 3050 3650
Wire Wire Line
	3050 5400 4100 5400
Connection ~ 3050 3650
Wire Wire Line
	3050 3650 4150 3650
Wire Wire Line
	3150 5300 3150 3550
Wire Wire Line
	3150 5300 4100 5300
Connection ~ 3150 3550
Wire Wire Line
	3150 3550 4150 3550
Wire Wire Line
	3250 5200 3250 3450
Wire Wire Line
	3250 5200 4100 5200
Connection ~ 3250 3450
Wire Wire Line
	3250 3450 4150 3450
Wire Wire Line
	3350 5100 3350 3350
Wire Wire Line
	3350 5100 4100 5100
Connection ~ 3350 3350
Wire Wire Line
	3350 3350 4150 3350
Wire Wire Line
	3450 5000 3450 3250
Wire Wire Line
	3450 5000 4100 5000
Connection ~ 3450 3250
Wire Wire Line
	3450 3250 4150 3250
Wire Wire Line
	3550 4900 3550 3150
Wire Wire Line
	3550 4900 4100 4900
Connection ~ 3550 3150
Wire Wire Line
	3550 3150 4150 3150
$Comp
L jrc-1:JIGL U?
U 1 1 61333E85
P 7300 2450
F 0 "U?" H 7700 3550 50  0000 C CNN
F 1 "JIGL" H 7700 1350 50  0000 C CNN
F 2 "" H 7300 2450 50  0001 C CNN
F 3 "" H 7300 2450 50  0001 C CNN
	1    7300 2450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61340500
P 7150 950
F 0 "#PWR?" H 7150 800 50  0001 C CNN
F 1 "+5V" H 7165 1123 50  0000 C CNN
F 2 "" H 7150 950 50  0001 C CNN
F 3 "" H 7150 950 50  0001 C CNN
	1    7150 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 950  7150 1150
Wire Wire Line
	7450 1300 7450 1150
Wire Wire Line
	7450 1150 7350 1150
Connection ~ 7150 1150
Wire Wire Line
	7150 1150 7150 1300
Wire Wire Line
	7250 1300 7250 1150
Connection ~ 7250 1150
Wire Wire Line
	7250 1150 7150 1150
Wire Wire Line
	7350 1300 7350 1150
Connection ~ 7350 1150
Wire Wire Line
	7350 1150 7250 1150
$Comp
L power:GND #PWR?
U 1 1 6134F327
P 7150 3800
F 0 "#PWR?" H 7150 3550 50  0001 C CNN
F 1 "GND" H 7155 3627 50  0000 C CNN
F 2 "" H 7150 3800 50  0001 C CNN
F 3 "" H 7150 3800 50  0001 C CNN
	1    7150 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 3600 7150 3700
Wire Wire Line
	7450 3600 7450 3700
Wire Wire Line
	7450 3700 7350 3700
Connection ~ 7150 3700
Wire Wire Line
	7150 3700 7150 3800
Wire Wire Line
	7250 3600 7250 3700
Connection ~ 7250 3700
Wire Wire Line
	7250 3700 7150 3700
Wire Wire Line
	7350 3600 7350 3700
Connection ~ 7350 3700
Wire Wire Line
	7350 3700 7250 3700
Text GLabel 6500 3300 0    50   Input ~ 0
PHI2
Wire Wire Line
	6500 3300 6650 3300
Text GLabel 6500 3400 0    50   Input ~ 0
RESETB
Wire Wire Line
	6500 3400 6650 3400
Text GLabel 6500 3050 0    50   Input ~ 0
VDA
Wire Wire Line
	6500 3050 6650 3050
Text GLabel 6500 3150 0    50   Input ~ 0
VPA
Wire Wire Line
	6500 3150 6650 3150
Text GLabel 6500 2400 0    50   Input ~ 0
BA0
Wire Wire Line
	6500 2400 6650 2400
Text GLabel 6500 2500 0    50   Input ~ 0
BA1
Wire Wire Line
	6500 2500 6650 2500
Text GLabel 6500 2600 0    50   Input ~ 0
BA2
Wire Wire Line
	6500 2600 6650 2600
Text GLabel 6500 2700 0    50   Input ~ 0
BA3
Wire Wire Line
	6500 2700 6650 2700
Text GLabel 6500 2800 0    50   Input ~ 0
BA4
Wire Wire Line
	6500 2800 6650 2800
Text GLabel 6500 1550 0    50   Input ~ 0
A5
Wire Wire Line
	6500 1550 6650 1550
Text GLabel 6500 1650 0    50   Input ~ 0
A6
Wire Wire Line
	6500 1650 6650 1650
Text GLabel 6500 1750 0    50   Input ~ 0
A7
Wire Wire Line
	6500 1750 6650 1750
Text GLabel 6500 1850 0    50   Input ~ 0
A11
Wire Wire Line
	6500 1850 6650 1850
Text GLabel 6500 1950 0    50   Input ~ 0
A12
Wire Wire Line
	6500 1950 6650 1950
Text GLabel 6500 2050 0    50   Input ~ 0
A13
Wire Wire Line
	6500 2050 6650 2050
Text GLabel 6500 2150 0    50   Input ~ 0
A14
Wire Wire Line
	6500 2150 6650 2150
Text GLabel 6500 2250 0    50   Input ~ 0
A15
Wire Wire Line
	6500 2250 6650 2250
Text GLabel 6500 2950 0    50   Input ~ 0
RWB
Wire Wire Line
	6500 2950 6650 2950
Text GLabel 8100 1550 2    50   Output ~ 0
A16
Text GLabel 8100 1650 2    50   Output ~ 0
A17
Text GLabel 8100 1750 2    50   Output ~ 0
A18
Text GLabel 8100 1900 2    50   Output ~ 0
RDB
Wire Wire Line
	7950 1550 8100 1550
Wire Wire Line
	7950 1650 8100 1650
Wire Wire Line
	7950 1750 8100 1750
Wire Wire Line
	7950 1900 8100 1900
Wire Wire Line
	7950 2000 8100 2000
Text GLabel 8100 2000 2    50   Output ~ 0
WRB
Wire Wire Line
	7950 2100 8100 2100
Text GLabel 8100 2100 2    50   Output ~ 0
WSENB
Text GLabel 8100 2250 2    50   Output ~ 0
ROMCSB
Wire Wire Line
	7950 2250 8100 2250
Text GLabel 8100 2350 2    50   Output ~ 0
RAM1CSB
Wire Wire Line
	7950 2350 8100 2350
Text GLabel 8100 2450 2    50   Output ~ 0
RAM2CSB
Wire Wire Line
	7950 2450 8100 2450
Text GLabel 8100 2550 2    50   Output ~ 0
IO1SELB
Wire Wire Line
	7950 2550 8100 2550
Text GLabel 8100 2650 2    50   Output ~ 0
IO2SELB
Wire Wire Line
	7950 2650 8100 2650
Text GLabel 8100 2750 2    50   Output ~ 0
IO3SELB
Wire Wire Line
	7950 2750 8100 2750
Text GLabel 8100 2850 2    50   Output ~ 0
IO4SELB
Wire Wire Line
	7950 2850 8100 2850
Text GLabel 8100 2950 2    50   Output ~ 0
RESET
Wire Wire Line
	7950 2950 8100 2950
$EndSCHEMATC
