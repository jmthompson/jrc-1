EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 3 8
Title "JRC-1 VIA and SPI Controller"
Date "2021-12-04"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 65xx:W65C22SxPL U7
U 1 1 61F2C714
P 5550 3800
AR Path="/61B43476/61F2C714" Ref="U7"  Part="1" 
AR Path="/62053143/61F2C714" Ref="U?"  Part="1" 
AR Path="/6256DBED/61F2C714" Ref="U?"  Part="1" 
F 0 "U7" H 5200 5100 50  0000 C CNN
F 1 "W65C22SxPL" H 5850 5100 50  0000 C CIB
F 2 "" H 5550 3950 50  0001 C CNN
F 3 "http://www.westerndesigncenter.com/wdc/documentation/w65c22.pdf" H 5550 3950 50  0001 C CNN
	1    5550 3800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR021
U 1 1 61F3A04D
P 5550 2200
AR Path="/61B43476/61F3A04D" Ref="#PWR021"  Part="1" 
AR Path="/62053143/61F3A04D" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/61F3A04D" Ref="#PWR?"  Part="1" 
F 0 "#PWR021" H 5550 2050 50  0001 C CNN
F 1 "+5V" H 5565 2373 50  0000 C CNN
F 2 "" H 5550 2200 50  0001 C CNN
F 3 "" H 5550 2200 50  0001 C CNN
	1    5550 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 2200 5550 2350
$Comp
L power:GND #PWR022
U 1 1 61F3B00D
P 5550 5350
AR Path="/61B43476/61F3B00D" Ref="#PWR022"  Part="1" 
AR Path="/62053143/61F3B00D" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/61F3B00D" Ref="#PWR?"  Part="1" 
F 0 "#PWR022" H 5550 5100 50  0001 C CNN
F 1 "GND" H 5555 5177 50  0000 C CNN
F 2 "" H 5550 5350 50  0001 C CNN
F 3 "" H 5550 5350 50  0001 C CNN
	1    5550 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 5250 5550 5350
Text GLabel 4800 2700 0    50   Input ~ 0
RESETB
Wire Wire Line
	4950 2700 4800 2700
Text GLabel 4800 4200 0    50   BiDi ~ 0
D0
Wire Wire Line
	4950 4200 4800 4200
Text GLabel 4800 4300 0    50   BiDi ~ 0
D1
Wire Wire Line
	4950 4300 4800 4300
Text GLabel 4800 4400 0    50   BiDi ~ 0
D2
Wire Wire Line
	4950 4400 4800 4400
Text GLabel 4800 4500 0    50   BiDi ~ 0
D3
Wire Wire Line
	4950 4500 4800 4500
Text GLabel 4800 4600 0    50   BiDi ~ 0
D4
Wire Wire Line
	4950 4600 4800 4600
Text GLabel 4800 4700 0    50   BiDi ~ 0
D5
Wire Wire Line
	4950 4700 4800 4700
Text GLabel 4800 4800 0    50   BiDi ~ 0
D6
Wire Wire Line
	4950 4800 4800 4800
Text GLabel 4800 4900 0    50   BiDi ~ 0
D7
Wire Wire Line
	4950 4900 4800 4900
Text GLabel 4800 2800 0    50   Input ~ 0
PHI2
Wire Wire Line
	4950 2800 4800 2800
Text GLabel 4800 3300 0    50   Input ~ 0
VIASELB
Wire Wire Line
	4950 3300 4800 3300
Wire Wire Line
	5550 2350 4000 2350
Wire Wire Line
	4000 2350 4000 3200
Wire Wire Line
	4000 3200 4950 3200
Connection ~ 5550 2350
Text GLabel 4800 3000 0    50   Output ~ 0
VIAIRQB
Wire Wire Line
	4950 3000 4800 3000
Text GLabel 4800 3500 0    50   Input ~ 0
A0
Wire Wire Line
	4950 3500 4800 3500
Text GLabel 4800 3600 0    50   Input ~ 0
A1
Wire Wire Line
	4950 3600 4800 3600
Text GLabel 4800 3700 0    50   Input ~ 0
A2
Wire Wire Line
	4950 3700 4800 3700
Text GLabel 4800 3800 0    50   Input ~ 0
A3
Wire Wire Line
	4950 3800 4800 3800
Text GLabel 4800 4000 0    50   Input ~ 0
RWB
Wire Wire Line
	4950 4000 4800 4000
$Comp
L power:GND #PWR?
U 1 1 62602CC0
P 1100 7350
AR Path="/60EE1618/62602CC0" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/62602CC0" Ref="#PWR?"  Part="1" 
AR Path="/61B43476/62602CC0" Ref="#PWR020"  Part="1" 
AR Path="/6256DBED/62602CC0" Ref="#PWR?"  Part="1" 
F 0 "#PWR020" H 1100 7100 50  0001 C CNN
F 1 "GND" H 1105 7177 50  0000 C CNN
F 2 "" H 1100 7350 50  0001 C CNN
F 3 "" H 1100 7350 50  0001 C CNN
	1    1100 7350
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 62602CC1
P 1100 7050
AR Path="/60EE1618/62602CC1" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/62602CC1" Ref="C?"  Part="1" 
AR Path="/61B43476/62602CC1" Ref="C8"  Part="1" 
AR Path="/6256DBED/62602CC1" Ref="C?"  Part="1" 
F 0 "C8" H 1192 7096 50  0001 L CNN
F 1 "1u" H 1192 7050 50  0001 L CNN
F 2 "" H 1100 7050 50  0001 C CNN
F 3 "~" H 1100 7050 50  0001 C CNN
	1    1100 7050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62056790
P 1100 6750
AR Path="/60EE1618/62056790" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/62056790" Ref="#PWR?"  Part="1" 
AR Path="/61B43476/62056790" Ref="#PWR019"  Part="1" 
AR Path="/6256DBED/62056790" Ref="#PWR?"  Part="1" 
F 0 "#PWR019" H 1100 6600 50  0001 C CNN
F 1 "+5V" H 1115 6923 50  0000 C CNN
F 2 "" H 1100 6750 50  0001 C CNN
F 3 "" H 1100 6750 50  0001 C CNN
	1    1100 6750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 6750 1100 6950
Wire Wire Line
	1100 7150 1100 7350
Text GLabel 6300 2700 2    50   BiDi ~ 0
PA0
Wire Wire Line
	6150 2700 6300 2700
Text GLabel 6300 2800 2    50   BiDi ~ 0
PA1
Wire Wire Line
	6150 2800 6300 2800
Text GLabel 6300 2900 2    50   BiDi ~ 0
PA2
Wire Wire Line
	6150 2900 6300 2900
Text GLabel 6300 3000 2    50   BiDi ~ 0
PA3
Wire Wire Line
	6150 3000 6300 3000
Text GLabel 6300 3100 2    50   BiDi ~ 0
PA4
Wire Wire Line
	6150 3100 6300 3100
Text GLabel 6300 3200 2    50   BiDi ~ 0
PA5
Wire Wire Line
	6150 3200 6300 3200
Text GLabel 6300 3300 2    50   BiDi ~ 0
PA6
Wire Wire Line
	6150 3300 6300 3300
Text GLabel 6300 3400 2    50   BiDi ~ 0
PA7
Wire Wire Line
	6150 3400 6300 3400
Wire Wire Line
	6150 3900 6300 3900
Wire Wire Line
	6150 4000 6300 4000
Wire Wire Line
	6150 4100 6300 4100
Wire Wire Line
	6150 4200 6300 4200
Wire Wire Line
	6150 4300 6300 4300
Wire Wire Line
	6150 4400 6300 4400
Wire Wire Line
	6150 4500 6300 4500
Wire Wire Line
	6150 4600 6300 4600
Text GLabel 6300 3900 2    50   BiDi ~ 0
PB0
Text GLabel 6300 4000 2    50   BiDi ~ 0
PB1
Text GLabel 6300 4100 2    50   BiDi ~ 0
PB2
Text GLabel 6300 4200 2    50   BiDi ~ 0
PB3
Text GLabel 6300 4300 2    50   BiDi ~ 0
PB4
Text GLabel 6300 4400 2    50   BiDi ~ 0
PB5
Text GLabel 6300 4500 2    50   BiDi ~ 0
PB6
Text GLabel 6300 4600 2    50   BiDi ~ 0
PB7
Wire Wire Line
	6150 3600 6300 3600
Wire Wire Line
	6150 3700 6300 3700
Text GLabel 6300 3600 2    50   BiDi ~ 0
CA1
Text GLabel 6300 3700 2    50   BiDi ~ 0
CA2
Wire Wire Line
	6150 4800 6300 4800
Wire Wire Line
	6150 4900 6300 4900
Text GLabel 6300 4800 2    50   BiDi ~ 0
CB1
Text GLabel 6300 4900 2    50   BiDi ~ 0
CB2
$EndSCHEMATC
