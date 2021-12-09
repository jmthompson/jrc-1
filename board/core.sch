EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 2 3
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
F 0 "U?" H 4900 4300 50  0000 C CNN
F 1 "74ACT245" H 4400 4300 50  0000 C CNN
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
	7850 2500 8000 2500
Text GLabel 8000 2500 2    50   Output ~ 0
IO4SELB
Wire Wire Line
	7850 2400 8000 2400
Text GLabel 8000 2400 2    50   Output ~ 0
IO3SELB
Wire Wire Line
	7850 2300 8000 2300
Text GLabel 8000 2300 2    50   Output ~ 0
IO2SELB
Wire Wire Line
	7850 2200 8000 2200
Text GLabel 8000 2200 2    50   Output ~ 0
IO1SELB
Wire Wire Line
	7850 2000 8000 2000
Text GLabel 8000 2000 2    50   Output ~ 0
RAM2CSB
Wire Wire Line
	7850 1900 8000 1900
Text GLabel 8000 1900 2    50   Output ~ 0
RAM1CSB
Wire Wire Line
	7850 1800 8000 1800
Text GLabel 8000 1800 2    50   Output ~ 0
ROMCSB
Text GLabel 8000 1550 2    50   Output ~ 0
WSENB
Wire Wire Line
	7850 1550 8000 1550
Text GLabel 8000 1450 2    50   Output ~ 0
WRB
Wire Wire Line
	7850 1450 8000 1450
Wire Wire Line
	7850 1350 8000 1350
Wire Wire Line
	5150 5750 5300 5750
Wire Wire Line
	5150 5650 5300 5650
Wire Wire Line
	5150 5550 5300 5550
Text GLabel 8000 1350 2    50   Output ~ 0
RDB
Text GLabel 5300 5750 2    50   Output ~ 0
A18
Text GLabel 5300 5650 2    50   Output ~ 0
A17
Text GLabel 5300 5550 2    50   Output ~ 0
A16
Wire Wire Line
	6400 2800 6550 2800
Text GLabel 6400 2800 0    50   Input ~ 0
RWB
Wire Wire Line
	6400 2100 6550 2100
Text GLabel 6400 2100 0    50   Input ~ 0
A15
Wire Wire Line
	6400 2000 6550 2000
Text GLabel 6400 2000 0    50   Input ~ 0
A14
Wire Wire Line
	6400 1900 6550 1900
Text GLabel 6400 1900 0    50   Input ~ 0
A13
Wire Wire Line
	6400 1800 6550 1800
Text GLabel 6400 1800 0    50   Input ~ 0
A12
Wire Wire Line
	6400 1700 6550 1700
Text GLabel 6400 1700 0    50   Input ~ 0
A11
Wire Wire Line
	6400 1600 6550 1600
Text GLabel 6400 1600 0    50   Input ~ 0
A10
Wire Wire Line
	6400 1500 6550 1500
Text GLabel 6400 1500 0    50   Input ~ 0
A9
Wire Wire Line
	6400 1400 6550 1400
Text GLabel 6400 1400 0    50   Input ~ 0
A8
Wire Wire Line
	6400 2900 6550 2900
Text GLabel 6400 2900 0    50   Input ~ 0
VDA
Wire Wire Line
	6400 3150 6550 3150
Text GLabel 6400 3150 0    50   Input ~ 0
PHI2
Wire Wire Line
	7250 3550 7150 3550
Connection ~ 7250 3550
Wire Wire Line
	7250 3450 7250 3550
Wire Wire Line
	7150 3550 7050 3550
Connection ~ 7150 3550
Wire Wire Line
	7150 3450 7150 3550
Wire Wire Line
	7050 3550 7050 3650
Connection ~ 7050 3550
Wire Wire Line
	7350 3550 7250 3550
Wire Wire Line
	7350 3450 7350 3550
Wire Wire Line
	7050 3450 7050 3550
$Comp
L power:GND #PWR?
U 1 1 6134F327
P 7050 3650
F 0 "#PWR?" H 7050 3400 50  0001 C CNN
F 1 "GND" H 7055 3477 50  0000 C CNN
F 2 "" H 7050 3650 50  0001 C CNN
F 3 "" H 7050 3650 50  0001 C CNN
	1    7050 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 1000 7150 1000
Connection ~ 7250 1000
Wire Wire Line
	7250 1150 7250 1000
Wire Wire Line
	7150 1000 7050 1000
Connection ~ 7150 1000
Wire Wire Line
	7150 1150 7150 1000
Wire Wire Line
	7050 1000 7050 1150
Connection ~ 7050 1000
Wire Wire Line
	7350 1000 7250 1000
Wire Wire Line
	7350 1150 7350 1000
Wire Wire Line
	7050 800  7050 1000
$Comp
L power:+5V #PWR?
U 1 1 61340500
P 7050 800
F 0 "#PWR?" H 7050 650 50  0001 C CNN
F 1 "+5V" H 7065 973 50  0000 C CNN
F 2 "" H 7050 800 50  0001 C CNN
F 3 "" H 7050 800 50  0001 C CNN
	1    7050 800 
	1    0    0    -1  
$EndComp
$Comp
L jrc-1:JIGL U?
U 1 1 61333E85
P 7200 2300
F 0 "U?" H 6700 3400 50  0000 C CNN
F 1 "JIGL" H 7600 3400 50  0000 C CNN
F 2 "" H 7200 2300 50  0001 C CNN
F 3 "" H 7200 2300 50  0001 C CNN
	1    7200 2300
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x05_Odd_Even J?
U 1 1 613464D2
P 9550 3150
F 0 "J?" H 9600 3567 50  0000 C CNN
F 1 "JTAG" H 9600 3476 50  0000 C CNN
F 2 "" H 9550 3150 50  0001 C CNN
F 3 "~" H 9550 3150 50  0001 C CNN
	1    9550 3150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 61347864
P 10050 3450
F 0 "#PWR?" H 10050 3200 50  0001 C CNN
F 1 "GND" H 10055 3277 50  0000 C CNN
F 2 "" H 10050 3450 50  0001 C CNN
F 3 "" H 10050 3450 50  0001 C CNN
	1    10050 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9850 2950 10050 2950
Wire Wire Line
	10050 2950 10050 3350
Wire Wire Line
	9850 3350 10050 3350
Connection ~ 10050 3350
Wire Wire Line
	10050 3350 10050 3450
Wire Wire Line
	8800 2050 8800 2250
$Comp
L power:+5V #PWR?
U 1 1 613591A2
P 8800 2050
F 0 "#PWR?" H 8800 1900 50  0001 C CNN
F 1 "+5V" H 8815 2223 50  0000 C CNN
F 2 "" H 8800 2050 50  0001 C CNN
F 3 "" H 8800 2050 50  0001 C CNN
	1    8800 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	9850 3050 10150 3050
NoConn ~ 9850 3150
NoConn ~ 9850 3250
NoConn ~ 9350 3250
Wire Wire Line
	7850 2950 8800 2950
Wire Wire Line
	7850 3150 9000 3150
Wire Wire Line
	7850 3250 9100 3250
$Comp
L Device:R_Network04 RN?
U 1 1 613D4415
P 9000 2450
F 0 "RN?" H 9188 2496 50  0000 L CNN
F 1 "4.7k" H 9188 2405 50  0000 L CNN
F 2 "Resistor_THT:R_Array_SIP5" V 9275 2450 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 9000 2450 50  0001 C CNN
	1    9000 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 2650 8800 2950
Connection ~ 8800 2950
Wire Wire Line
	8800 2950 9350 2950
Wire Wire Line
	7850 3050 8900 3050
Wire Wire Line
	8900 2650 8900 3050
Connection ~ 8900 3050
Wire Wire Line
	8900 3050 9350 3050
Wire Wire Line
	9000 2650 9000 3150
Connection ~ 9000 3150
Wire Wire Line
	9000 3150 9350 3150
Wire Wire Line
	9100 2650 9100 3250
Connection ~ 9100 3250
Wire Wire Line
	9100 3250 9100 3350
Wire Wire Line
	9100 3350 9350 3350
Wire Wire Line
	10150 2850 10150 3050
$Comp
L power:+5V #PWR?
U 1 1 614090E5
P 10150 2850
F 0 "#PWR?" H 10150 2700 50  0001 C CNN
F 1 "+5V" H 10165 3023 50  0000 C CNN
F 2 "" H 10150 2850 50  0001 C CNN
F 3 "" H 10150 2850 50  0001 C CNN
	1    10150 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 3850 4150 3850
Wire Wire Line
	2650 3750 3500 3750
Wire Wire Line
	2650 3650 3400 3650
$Comp
L 74xx:74LS574 U?
U 1 1 61595EA3
P 4650 6050
F 0 "U?" H 4400 6700 50  0000 C CNN
F 1 "74AC573" H 4900 6700 50  0000 C CNN
F 2 "" H 4650 6050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS574" H 4650 6050 50  0001 C CNN
	1    4650 6050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 615A0295
P 4650 6950
F 0 "#PWR?" H 4650 6700 50  0001 C CNN
F 1 "GND" H 4655 6777 50  0000 C CNN
F 2 "" H 4650 6950 50  0001 C CNN
F 3 "" H 4650 6950 50  0001 C CNN
	1    4650 6950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 6850 4650 6950
$Comp
L power:+5V #PWR?
U 1 1 615A9933
P 4650 5200
F 0 "#PWR?" H 4650 5050 50  0001 C CNN
F 1 "+5V" H 4665 5373 50  0000 C CNN
F 2 "" H 4650 5200 50  0001 C CNN
F 3 "" H 4650 5200 50  0001 C CNN
	1    4650 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 5200 4650 5250
Wire Wire Line
	2650 3550 3300 3550
Wire Wire Line
	2650 3450 3200 3450
Wire Wire Line
	2650 3350 3100 3350
Wire Wire Line
	2650 3250 3000 3250
Wire Wire Line
	2650 3150 2900 3150
Wire Wire Line
	2900 3150 2900 5550
Wire Wire Line
	2900 5550 4150 5550
Connection ~ 2900 3150
Wire Wire Line
	2900 3150 4150 3150
Wire Wire Line
	3000 3250 3000 5650
Wire Wire Line
	3000 5650 4150 5650
Connection ~ 3000 3250
Wire Wire Line
	3000 3250 4150 3250
Wire Wire Line
	3100 3350 3100 5750
Wire Wire Line
	3100 5750 4150 5750
Connection ~ 3100 3350
Wire Wire Line
	3100 3350 4150 3350
Wire Wire Line
	3200 3450 3200 5850
Wire Wire Line
	3200 5850 4150 5850
Connection ~ 3200 3450
Wire Wire Line
	3200 3450 4150 3450
Wire Wire Line
	3300 3550 3300 5950
Wire Wire Line
	3300 5950 4150 5950
Connection ~ 3300 3550
Wire Wire Line
	3300 3550 4150 3550
Wire Wire Line
	3400 3650 3400 6050
Wire Wire Line
	3400 6050 4150 6050
Connection ~ 3400 3650
Wire Wire Line
	3400 3650 4150 3650
Wire Wire Line
	3500 3750 3500 6150
Wire Wire Line
	3500 6150 4150 6150
Connection ~ 3500 3750
Wire Wire Line
	3500 3750 4150 3750
Wire Wire Line
	3600 3900 3600 6250
Wire Wire Line
	3600 6250 4150 6250
Wire Wire Line
	4150 6550 4050 6550
Wire Wire Line
	4050 6550 4050 6850
Wire Wire Line
	4050 6850 4650 6850
Connection ~ 4650 6850
Wire Wire Line
	5150 6050 5300 6050
Wire Wire Line
	5150 5950 5300 5950
Wire Wire Line
	5150 5850 5300 5850
Text GLabel 5300 6050 2    50   Output ~ 0
A21
Text GLabel 5300 5950 2    50   Output ~ 0
A20
Text GLabel 5300 5850 2    50   Output ~ 0
A19
Wire Wire Line
	5150 6250 5300 6250
Wire Wire Line
	5150 6150 5300 6150
Text GLabel 5300 6250 2    50   Output ~ 0
A23
Text GLabel 5300 6150 2    50   Output ~ 0
A22
Wire Wire Line
	4000 6450 4150 6450
Text GLabel 4000 6450 0    50   Input ~ 0
PHI1
Wire Wire Line
	7850 2700 8000 2700
Text GLabel 8000 2700 2    50   Output ~ 0
IO6SELB
Wire Wire Line
	7850 2600 8000 2600
Text GLabel 8000 2600 2    50   Output ~ 0
~IO5SELB
Wire Wire Line
	6400 2600 6550 2600
Text GLabel 6400 2600 0    50   Input ~ 0
A20
Wire Wire Line
	6400 2500 6550 2500
Text GLabel 6400 2500 0    50   Input ~ 0
A19
Wire Wire Line
	6400 2400 6550 2400
Text GLabel 6400 2400 0    50   Input ~ 0
A18
Wire Wire Line
	6400 2300 6550 2300
Text GLabel 6400 2300 0    50   Input ~ 0
A17
Wire Wire Line
	6400 2200 6550 2200
Text GLabel 6400 2200 0    50   Input ~ 0
A16
$EndSCHEMATC
