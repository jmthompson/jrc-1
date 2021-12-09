EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 7 9
Title "JRC-1 Bus Decoding Logic"
Date "2021-12-08"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text GLabel 3150 2500 2    50   Output ~ 0
UARTSELB
Text GLabel 3150 2400 2    50   Output ~ 0
SPISELB
Text GLabel 3150 2300 2    50   Output ~ 0
VIASELB
Wire Wire Line
	3000 2100 3150 2100
Text GLabel 3150 2100 2    50   Output ~ 0
RAM2CSB
Wire Wire Line
	3000 2000 3150 2000
Text GLabel 3150 2000 2    50   Output ~ 0
RAM1CSB
Wire Wire Line
	3000 1900 3150 1900
Text GLabel 3150 1900 2    50   Output ~ 0
ROMCSB
Text GLabel 3150 1700 2    50   Output ~ 0
WRB
Wire Wire Line
	3000 1700 3150 1700
Wire Wire Line
	3000 1600 3150 1600
Text GLabel 3150 1600 2    50   Output ~ 0
RDB
Wire Wire Line
	1550 3300 1700 3300
Text GLabel 1550 3300 0    50   Input ~ 0
RWB
Wire Wire Line
	1550 2500 1700 2500
Text GLabel 1550 2500 0    50   Input ~ 0
A15
Wire Wire Line
	1550 2400 1700 2400
Text GLabel 1550 2400 0    50   Input ~ 0
A14
Wire Wire Line
	1550 2300 1700 2300
Text GLabel 1550 2300 0    50   Input ~ 0
A13
Wire Wire Line
	1550 2200 1700 2200
Text GLabel 1550 2200 0    50   Input ~ 0
A12
Wire Wire Line
	1550 2100 1700 2100
Text GLabel 1550 2100 0    50   Input ~ 0
A11
Wire Wire Line
	1550 2000 1700 2000
Text GLabel 1550 2000 0    50   Input ~ 0
A10
Wire Wire Line
	1550 1900 1700 1900
Text GLabel 1550 1900 0    50   Input ~ 0
A9
Wire Wire Line
	1550 1800 1700 1800
Text GLabel 1550 1800 0    50   Input ~ 0
A8
Wire Wire Line
	1550 3400 1700 3400
Text GLabel 1550 3400 0    50   Input ~ 0
VDA
Wire Wire Line
	1550 3200 1700 3200
Text GLabel 1550 3200 0    50   Input ~ 0
PHI2
Wire Wire Line
	2400 3900 2300 3900
Connection ~ 2400 3900
Wire Wire Line
	2400 3800 2400 3900
Wire Wire Line
	2300 3900 2200 3900
Connection ~ 2300 3900
Wire Wire Line
	2300 3800 2300 3900
Connection ~ 2200 3900
Wire Wire Line
	2500 3900 2400 3900
Wire Wire Line
	2500 3800 2500 3900
Wire Wire Line
	2200 3800 2200 3900
$Comp
L power:GND #PWR?
U 1 1 62269CB7
P 2200 4000
AR Path="/60EE1618/62269CB7" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/62269CB7" Ref="#PWR044"  Part="1" 
F 0 "#PWR044" H 2200 3750 50  0001 C CNN
F 1 "GND" H 2205 3827 50  0000 C CNN
F 2 "" H 2200 4000 50  0001 C CNN
F 3 "" H 2200 4000 50  0001 C CNN
	1    2200 4000
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62269CBD
P 2200 950
AR Path="/60EE1618/62269CBD" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/62269CBD" Ref="#PWR043"  Part="1" 
F 0 "#PWR043" H 2200 800 50  0001 C CNN
F 1 "+5V" H 2215 1123 50  0000 C CNN
F 2 "" H 2200 950 50  0001 C CNN
F 3 "" H 2200 950 50  0001 C CNN
	1    2200 950 
	1    0    0    -1  
$EndComp
$Comp
L jrc-1:JIGL U?
U 1 1 62269CC3
P 2350 2550
AR Path="/60EE1618/62269CC3" Ref="U?"  Part="1" 
AR Path="/6224E7FB/62269CC3" Ref="U16"  Part="1" 
F 0 "U16" H 1850 3750 50  0000 C CNN
F 1 "JIGL" H 2800 3750 50  0000 C CNN
F 2 "" H 2350 2550 50  0001 C CNN
F 3 "" H 2350 2550 50  0001 C CNN
	1    2350 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 3000 1700 3000
Text GLabel 1550 3000 0    50   Input ~ 0
A20
Wire Wire Line
	1550 2900 1700 2900
Text GLabel 1550 2900 0    50   Input ~ 0
A19
Wire Wire Line
	1550 2800 1700 2800
Text GLabel 1550 2800 0    50   Input ~ 0
A18
Wire Wire Line
	1550 2700 1700 2700
Text GLabel 1550 2700 0    50   Input ~ 0
A17
Wire Wire Line
	1550 2600 1700 2600
Text GLabel 1550 2600 0    50   Input ~ 0
A16
Wire Wire Line
	1550 3500 1700 3500
Text GLabel 1550 3500 0    50   Input ~ 0
VPA
Wire Wire Line
	2200 950  2200 1150
Wire Wire Line
	2500 1150 2400 1150
Connection ~ 2200 1150
Connection ~ 2300 1150
Wire Wire Line
	2300 1150 2200 1150
Connection ~ 2400 1150
Wire Wire Line
	2400 1150 2300 1150
Wire Wire Line
	2400 1150 2400 1300
Wire Wire Line
	2300 1150 2300 1300
Wire Wire Line
	2500 1150 2500 1300
Wire Wire Line
	2200 1150 2200 1300
Wire Wire Line
	2200 3900 2200 4000
Wire Wire Line
	3000 2300 3150 2300
Wire Wire Line
	3000 2400 3150 2400
Wire Wire Line
	3000 2500 3150 2500
Wire Wire Line
	1550 1700 1700 1700
Text GLabel 1550 1700 0    50   Input ~ 0
A5
Wire Wire Line
	1550 1600 1700 1600
Text GLabel 1550 1600 0    50   Input ~ 0
A4
Text GLabel 3150 2800 2    50   Output ~ 0
SLOT1SELB
Wire Wire Line
	3000 2800 3150 2800
Text GLabel 3150 2900 2    50   Output ~ 0
SLOT2SELB
Wire Wire Line
	3000 2900 3150 2900
Text GLabel 3150 3000 2    50   Output ~ 0
SLOT3SELB
Wire Wire Line
	3000 3000 3150 3000
$Comp
L 74xx:74HC245 U?
U 1 1 6261E75F
P 5450 4150
AR Path="/62BE9D15/6261E75F" Ref="U?"  Part="1" 
AR Path="/60EE1618/6261E75F" Ref="U?"  Part="1" 
AR Path="/6224E7FB/6261E75F" Ref="U18"  Part="1" 
F 0 "U18" H 5200 4800 50  0000 C CNN
F 1 "74ACT245" H 5650 4800 50  0000 C CNN
F 2 "" H 5450 4150 50  0001 C CNN
F 3 "" H 5450 4150 50  0001 C CNN
	1    5450 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 6261E765
P 5450 3350
AR Path="/62BE9D15/6261E765" Ref="#PWR?"  Part="1" 
AR Path="/60EE1618/6261E765" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6261E765" Ref="#PWR048"  Part="1" 
F 0 "#PWR048" H 5450 3200 50  0001 C CNN
F 1 "+5V" H 5465 3523 50  0000 C CNN
F 2 "" H 5450 3350 50  0001 C CNN
F 3 "" H 5450 3350 50  0001 C CNN
	1    5450 3350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 6261E76B
P 5650 3800
AR Path="/62BE9D15/6261E76B" Ref="#PWR?"  Part="1" 
AR Path="/60EE1618/6261E76B" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6261E76B" Ref="#PWR050"  Part="1" 
F 0 "#PWR050" H 5650 3550 50  0001 C CNN
F 1 "GND" H 5655 3627 50  0000 C CNN
F 2 "" H 5650 3800 50  0001 C CNN
F 3 "" H 5650 3800 50  0001 C CNN
	1    5650 3800
	1    0    0    -1  
$EndComp
Text GLabel 4800 3650 0    50   BiDi ~ 0
XD0
Wire Wire Line
	4950 3650 4800 3650
Text GLabel 4800 3750 0    50   BiDi ~ 0
XD1
Wire Wire Line
	4950 3750 4800 3750
Text GLabel 4800 3850 0    50   BiDi ~ 0
XD2
Wire Wire Line
	4950 3850 4800 3850
Text GLabel 4800 3950 0    50   BiDi ~ 0
XD3
Wire Wire Line
	4950 3950 4800 3950
Text GLabel 4800 4050 0    50   BiDi ~ 0
XD4
Wire Wire Line
	4950 4050 4800 4050
Text GLabel 4800 4150 0    50   BiDi ~ 0
XD5
Wire Wire Line
	4950 4150 4800 4150
Text GLabel 4800 4250 0    50   BiDi ~ 0
XD6
Wire Wire Line
	4950 4250 4800 4250
Text GLabel 4800 4350 0    50   BiDi ~ 0
XD7
Wire Wire Line
	4950 4350 4800 4350
Text GLabel 6100 3650 2    50   BiDi ~ 0
D0
Wire Wire Line
	5950 3650 6100 3650
Text GLabel 6100 3750 2    50   BiDi ~ 0
D1
Wire Wire Line
	5950 3750 6100 3750
Text GLabel 6100 3850 2    50   BiDi ~ 0
D2
Wire Wire Line
	5950 3850 6100 3850
Text GLabel 6100 3950 2    50   BiDi ~ 0
D3
Wire Wire Line
	5950 3950 6100 3950
Text GLabel 6100 4050 2    50   BiDi ~ 0
D4
Wire Wire Line
	5950 4050 6100 4050
Text GLabel 6100 4150 2    50   BiDi ~ 0
D5
Wire Wire Line
	5950 4150 6100 4150
Text GLabel 6100 4250 2    50   BiDi ~ 0
D6
Wire Wire Line
	5950 4250 6100 4250
Text GLabel 6100 4350 2    50   BiDi ~ 0
D7
Wire Wire Line
	5950 4350 6100 4350
Text GLabel 4800 4550 0    50   Input ~ 0
RWB
Wire Wire Line
	4950 4550 4800 4550
$Comp
L 74xx:74HC245 U?
U 1 1 6261E795
P 5450 1950
AR Path="/62BE9D15/6261E795" Ref="U?"  Part="1" 
AR Path="/60EE1618/6261E795" Ref="U?"  Part="1" 
AR Path="/6224E7FB/6261E795" Ref="U17"  Part="1" 
F 0 "U17" H 5200 2600 50  0000 C CNN
F 1 "74ACT245" H 5650 2600 50  0000 C CNN
F 2 "" H 5450 1950 50  0001 C CNN
F 3 "" H 5450 1950 50  0001 C CNN
	1    5450 1950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 6261E79B
P 5450 1150
AR Path="/62BE9D15/6261E79B" Ref="#PWR?"  Part="1" 
AR Path="/60EE1618/6261E79B" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6261E79B" Ref="#PWR046"  Part="1" 
F 0 "#PWR046" H 5450 1000 50  0001 C CNN
F 1 "+5V" H 5465 1323 50  0000 C CNN
F 2 "" H 5450 1150 50  0001 C CNN
F 3 "" H 5450 1150 50  0001 C CNN
	1    5450 1150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 6261E7A1
P 5450 2850
AR Path="/62BE9D15/6261E7A1" Ref="#PWR?"  Part="1" 
AR Path="/60EE1618/6261E7A1" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6261E7A1" Ref="#PWR047"  Part="1" 
F 0 "#PWR047" H 5450 2600 50  0001 C CNN
F 1 "GND" H 5455 2677 50  0000 C CNN
F 2 "" H 5450 2850 50  0001 C CNN
F 3 "" H 5450 2850 50  0001 C CNN
	1    5450 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 2750 5450 2850
Wire Wire Line
	4950 2450 4850 2450
Wire Wire Line
	4850 2450 4850 2750
Wire Wire Line
	4850 2750 5450 2750
Connection ~ 5450 2750
$Comp
L power:+5V #PWR?
U 1 1 6261E7AC
P 4400 2200
AR Path="/62BE9D15/6261E7AC" Ref="#PWR?"  Part="1" 
AR Path="/60EE1618/6261E7AC" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6261E7AC" Ref="#PWR045"  Part="1" 
F 0 "#PWR045" H 4400 2050 50  0001 C CNN
F 1 "+5V" H 4415 2373 50  0000 C CNN
F 2 "" H 4400 2200 50  0001 C CNN
F 3 "" H 4400 2200 50  0001 C CNN
	1    4400 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 2200 4400 2350
Wire Wire Line
	4950 2350 4400 2350
Wire Wire Line
	4800 2150 4950 2150
Text GLabel 4800 2150 0    50   Input ~ 0
A7
Wire Wire Line
	4800 2050 4950 2050
Text GLabel 4800 2050 0    50   Input ~ 0
A6
Wire Wire Line
	4800 1950 4950 1950
Text GLabel 4800 1950 0    50   Input ~ 0
A5
Wire Wire Line
	4800 1850 4950 1850
Text GLabel 4800 1850 0    50   Input ~ 0
A4
Wire Wire Line
	4800 1750 4950 1750
Text GLabel 4800 1750 0    50   Input ~ 0
A3
Wire Wire Line
	4800 1650 4950 1650
Text GLabel 4800 1650 0    50   Input ~ 0
A2
Wire Wire Line
	4800 1550 4950 1550
Text GLabel 4800 1550 0    50   Input ~ 0
A1
Wire Wire Line
	4800 1450 4950 1450
Text GLabel 4800 1450 0    50   Input ~ 0
A0
Wire Wire Line
	6100 2150 5950 2150
Text GLabel 6100 2150 2    50   Output ~ 0
XA7
Wire Wire Line
	6100 2050 5950 2050
Text GLabel 6100 2050 2    50   Output ~ 0
XA6
Wire Wire Line
	6100 1950 5950 1950
Text GLabel 6100 1950 2    50   Output ~ 0
XA5
Wire Wire Line
	6100 1850 5950 1850
Text GLabel 6100 1850 2    50   Output ~ 0
XA4
Wire Wire Line
	6100 1750 5950 1750
Text GLabel 6100 1750 2    50   Output ~ 0
XA3
Wire Wire Line
	6100 1650 5950 1650
Text GLabel 6100 1650 2    50   Output ~ 0
XA2
Wire Wire Line
	6100 1550 5950 1550
Text GLabel 6100 1550 2    50   Output ~ 0
XA1
Wire Wire Line
	6100 1450 5950 1450
Text GLabel 6100 1450 2    50   Output ~ 0
XA0
$Comp
L power:GND #PWR?
U 1 1 6261E7D4
P 5450 5050
AR Path="/62BE9D15/6261E7D4" Ref="#PWR?"  Part="1" 
AR Path="/60EE1618/6261E7D4" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6261E7D4" Ref="#PWR049"  Part="1" 
F 0 "#PWR049" H 5450 4800 50  0001 C CNN
F 1 "GND" H 5455 4877 50  0000 C CNN
F 2 "" H 5450 5050 50  0001 C CNN
F 3 "" H 5450 5050 50  0001 C CNN
	1    5450 5050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 4950 5450 5050
Text GLabel 3150 3200 2    50   Input ~ 0
TCK
Text GLabel 3150 3300 2    50   Output ~ 0
TDO
Text GLabel 3150 3500 2    50   Input ~ 0
TDI
Text GLabel 3150 3400 2    50   Input ~ 0
TMS
Wire Wire Line
	3000 3200 3150 3200
Wire Wire Line
	3000 3300 3150 3300
Wire Wire Line
	3000 3400 3150 3400
Wire Wire Line
	3000 3500 3150 3500
Wire Wire Line
	4050 2700 4050 4650
Wire Wire Line
	3000 2700 4050 2700
Wire Wire Line
	4050 4650 4950 4650
$EndSCHEMATC
