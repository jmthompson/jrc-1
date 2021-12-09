EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 5 8
Title "JRC-1 RAM and ROM"
Date "2021-12-04"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Memory:AS6C4008 U12
U 1 1 61ADEFE1
P 2950 3950
F 0 "U12" H 2600 5100 50  0000 C CNN
F 1 "AS6C4008" H 3200 5100 39  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 2900 5600 50  0001 C CNN
F 3 "" H 2950 3950 50  0001 C CNN
	1    2950 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 4550 2250 4550
Text GLabel 2100 4550 0    50   Input ~ 0
A15
Wire Wire Line
	2100 4450 2250 4450
Text GLabel 2100 4450 0    50   Input ~ 0
A14
Wire Wire Line
	2100 4350 2250 4350
Text GLabel 2100 4350 0    50   Input ~ 0
A13
Wire Wire Line
	2100 4250 2250 4250
Text GLabel 2100 4250 0    50   Input ~ 0
A12
Wire Wire Line
	2100 4150 2250 4150
Text GLabel 2100 4150 0    50   Input ~ 0
A11
Wire Wire Line
	2100 3750 2250 3750
Text GLabel 2100 3750 0    50   Input ~ 0
A7
Wire Wire Line
	2100 3650 2250 3650
Text GLabel 2100 3650 0    50   Input ~ 0
A6
Wire Wire Line
	2100 3550 2250 3550
Text GLabel 2100 3550 0    50   Input ~ 0
A5
Wire Wire Line
	2100 4850 2250 4850
Text GLabel 2100 4850 0    50   Input ~ 0
A18
Wire Wire Line
	2100 4750 2250 4750
Text GLabel 2100 4750 0    50   Input ~ 0
A17
Wire Wire Line
	2100 4650 2250 4650
Text GLabel 2100 4650 0    50   Input ~ 0
A16
Wire Wire Line
	2100 4050 2250 4050
Text GLabel 2100 4050 0    50   Input ~ 0
A10
Wire Wire Line
	2100 3950 2250 3950
Text GLabel 2100 3950 0    50   Input ~ 0
A9
Wire Wire Line
	2100 3850 2250 3850
Text GLabel 2100 3850 0    50   Input ~ 0
A8
Wire Wire Line
	2100 3450 2250 3450
Text GLabel 2100 3450 0    50   Input ~ 0
A4
Wire Wire Line
	2100 3350 2250 3350
Text GLabel 2100 3350 0    50   Input ~ 0
A3
Wire Wire Line
	2100 3250 2250 3250
Text GLabel 2100 3250 0    50   Input ~ 0
A2
Wire Wire Line
	2100 3150 2250 3150
Text GLabel 2100 3150 0    50   Input ~ 0
A1
Wire Wire Line
	2100 3050 2250 3050
Text GLabel 2100 3050 0    50   Input ~ 0
A0
Wire Wire Line
	3650 4400 3800 4400
Text GLabel 3800 4400 2    50   Input ~ 0
RAM1CSB
Text GLabel 3800 4600 2    50   Input ~ 0
WRB
Wire Wire Line
	3650 4600 3800 4600
Wire Wire Line
	3650 4500 3800 4500
Text GLabel 3800 4500 2    50   Input ~ 0
RDB
Text GLabel 3800 3050 2    50   BiDi ~ 0
D0
Wire Wire Line
	3650 3050 3800 3050
Text GLabel 3800 3150 2    50   BiDi ~ 0
D1
Wire Wire Line
	3650 3150 3800 3150
Text GLabel 3800 3250 2    50   BiDi ~ 0
D2
Wire Wire Line
	3650 3250 3800 3250
Text GLabel 3800 3350 2    50   BiDi ~ 0
D3
Wire Wire Line
	3650 3350 3800 3350
Text GLabel 3800 3450 2    50   BiDi ~ 0
D4
Wire Wire Line
	3650 3450 3800 3450
Text GLabel 3800 3550 2    50   BiDi ~ 0
D5
Wire Wire Line
	3650 3550 3800 3550
Text GLabel 3800 3650 2    50   BiDi ~ 0
D6
Wire Wire Line
	3650 3650 3800 3650
Text GLabel 3800 3750 2    50   BiDi ~ 0
D7
Wire Wire Line
	3650 3750 3800 3750
$Comp
L power:+5V #PWR035
U 1 1 61B0ED14
P 2950 2550
F 0 "#PWR035" H 2950 2400 50  0001 C CNN
F 1 "+5V" H 2965 2723 50  0000 C CNN
F 2 "" H 2950 2550 50  0001 C CNN
F 3 "" H 2950 2550 50  0001 C CNN
	1    2950 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR036
U 1 1 61B10976
P 2950 5350
F 0 "#PWR036" H 2950 5100 50  0001 C CNN
F 1 "GND" H 2955 5177 50  0000 C CNN
F 2 "" H 2950 5350 50  0001 C CNN
F 3 "" H 2950 5350 50  0001 C CNN
	1    2950 5350
	1    0    0    -1  
$EndComp
$Comp
L Memory:AS6C4008 U13
U 1 1 61B14B22
P 5400 3950
F 0 "U13" H 5050 5100 50  0000 C CNN
F 1 "AS6C4008" H 5650 5100 39  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 5350 5600 50  0001 C CNN
F 3 "" H 5400 3950 50  0001 C CNN
	1    5400 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4550 4550 4700 4550
Text GLabel 4550 4550 0    50   Input ~ 0
A15
Wire Wire Line
	4550 4450 4700 4450
Text GLabel 4550 4450 0    50   Input ~ 0
A14
Wire Wire Line
	4550 4350 4700 4350
Text GLabel 4550 4350 0    50   Input ~ 0
A13
Wire Wire Line
	4550 4250 4700 4250
Text GLabel 4550 4250 0    50   Input ~ 0
A12
Wire Wire Line
	4550 4150 4700 4150
Text GLabel 4550 4150 0    50   Input ~ 0
A11
Wire Wire Line
	4550 3750 4700 3750
Text GLabel 4550 3750 0    50   Input ~ 0
A7
Wire Wire Line
	4550 3650 4700 3650
Text GLabel 4550 3650 0    50   Input ~ 0
A6
Wire Wire Line
	4550 3550 4700 3550
Text GLabel 4550 3550 0    50   Input ~ 0
A5
Wire Wire Line
	4550 4850 4700 4850
Text GLabel 4550 4850 0    50   Input ~ 0
A18
Wire Wire Line
	4550 4750 4700 4750
Text GLabel 4550 4750 0    50   Input ~ 0
A17
Wire Wire Line
	4550 4650 4700 4650
Text GLabel 4550 4650 0    50   Input ~ 0
A16
Wire Wire Line
	4550 4050 4700 4050
Text GLabel 4550 4050 0    50   Input ~ 0
A10
Wire Wire Line
	4550 3950 4700 3950
Text GLabel 4550 3950 0    50   Input ~ 0
A9
Wire Wire Line
	4550 3850 4700 3850
Text GLabel 4550 3850 0    50   Input ~ 0
A8
Wire Wire Line
	4550 3450 4700 3450
Text GLabel 4550 3450 0    50   Input ~ 0
A4
Wire Wire Line
	4550 3350 4700 3350
Text GLabel 4550 3350 0    50   Input ~ 0
A3
Wire Wire Line
	4550 3250 4700 3250
Text GLabel 4550 3250 0    50   Input ~ 0
A2
Wire Wire Line
	4550 3150 4700 3150
Text GLabel 4550 3150 0    50   Input ~ 0
A1
Wire Wire Line
	4550 3050 4700 3050
Text GLabel 4550 3050 0    50   Input ~ 0
A0
Wire Wire Line
	6100 4400 6250 4400
Text GLabel 6250 4400 2    50   Input ~ 0
RAM2CSB
Text GLabel 6250 4600 2    50   Input ~ 0
WRB
Wire Wire Line
	6100 4600 6250 4600
Wire Wire Line
	6100 4500 6250 4500
Text GLabel 6250 4500 2    50   Input ~ 0
RDB
Text GLabel 6250 3050 2    50   BiDi ~ 0
D0
Wire Wire Line
	6100 3050 6250 3050
Text GLabel 6250 3150 2    50   BiDi ~ 0
D1
Wire Wire Line
	6100 3150 6250 3150
Text GLabel 6250 3250 2    50   BiDi ~ 0
D2
Wire Wire Line
	6100 3250 6250 3250
Text GLabel 6250 3350 2    50   BiDi ~ 0
D3
Wire Wire Line
	6100 3350 6250 3350
Text GLabel 6250 3450 2    50   BiDi ~ 0
D4
Wire Wire Line
	6100 3450 6250 3450
Text GLabel 6250 3550 2    50   BiDi ~ 0
D5
Wire Wire Line
	6100 3550 6250 3550
Text GLabel 6250 3650 2    50   BiDi ~ 0
D6
Wire Wire Line
	6100 3650 6250 3650
Text GLabel 6250 3750 2    50   BiDi ~ 0
D7
Wire Wire Line
	6100 3750 6250 3750
$Comp
L power:+5V #PWR037
U 1 1 61B14B64
P 5400 2550
F 0 "#PWR037" H 5400 2400 50  0001 C CNN
F 1 "+5V" H 5415 2723 50  0000 C CNN
F 2 "" H 5400 2550 50  0001 C CNN
F 3 "" H 5400 2550 50  0001 C CNN
	1    5400 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR038
U 1 1 61B14B6A
P 5400 5350
F 0 "#PWR038" H 5400 5100 50  0001 C CNN
F 1 "GND" H 5405 5177 50  0000 C CNN
F 2 "" H 5400 5350 50  0001 C CNN
F 3 "" H 5400 5350 50  0001 C CNN
	1    5400 5350
	1    0    0    -1  
$EndComp
$Comp
L Memory:W29C020C U14
U 1 1 61B194BA
P 8200 4000
F 0 "U14" H 7850 5150 50  0000 C CNN
F 1 "W29C020C" H 8450 5150 39  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 8150 5650 50  0001 C CNN
F 3 "" H 8200 4000 50  0001 C CNN
	1    8200 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 4600 7500 4600
Text GLabel 7350 4600 0    50   Input ~ 0
A15
Wire Wire Line
	7350 4500 7500 4500
Text GLabel 7350 4500 0    50   Input ~ 0
A14
Wire Wire Line
	7350 4400 7500 4400
Text GLabel 7350 4400 0    50   Input ~ 0
A13
Wire Wire Line
	7350 4300 7500 4300
Text GLabel 7350 4300 0    50   Input ~ 0
A12
Wire Wire Line
	7350 4200 7500 4200
Text GLabel 7350 4200 0    50   Input ~ 0
A11
Wire Wire Line
	7350 3800 7500 3800
Text GLabel 7350 3800 0    50   Input ~ 0
A7
Wire Wire Line
	7350 3700 7500 3700
Text GLabel 7350 3700 0    50   Input ~ 0
A6
Wire Wire Line
	7350 3600 7500 3600
Text GLabel 7350 3600 0    50   Input ~ 0
A5
Wire Wire Line
	7350 4800 7500 4800
Text GLabel 7350 4800 0    50   Input ~ 0
A17
Wire Wire Line
	7350 4700 7500 4700
Text GLabel 7350 4700 0    50   Input ~ 0
A16
Wire Wire Line
	7350 4100 7500 4100
Text GLabel 7350 4100 0    50   Input ~ 0
A10
Wire Wire Line
	7350 4000 7500 4000
Text GLabel 7350 4000 0    50   Input ~ 0
A9
Wire Wire Line
	7350 3900 7500 3900
Text GLabel 7350 3900 0    50   Input ~ 0
A8
Wire Wire Line
	7350 3500 7500 3500
Text GLabel 7350 3500 0    50   Input ~ 0
A4
Wire Wire Line
	7350 3400 7500 3400
Text GLabel 7350 3400 0    50   Input ~ 0
A3
Wire Wire Line
	7350 3300 7500 3300
Text GLabel 7350 3300 0    50   Input ~ 0
A2
Wire Wire Line
	7350 3200 7500 3200
Text GLabel 7350 3200 0    50   Input ~ 0
A1
Wire Wire Line
	7350 3100 7500 3100
Text GLabel 7350 3100 0    50   Input ~ 0
A0
$Comp
L power:GND #PWR040
U 1 1 61B29161
P 8200 5400
F 0 "#PWR040" H 8200 5150 50  0001 C CNN
F 1 "GND" H 8205 5227 50  0000 C CNN
F 2 "" H 8200 5400 50  0001 C CNN
F 3 "" H 8200 5400 50  0001 C CNN
	1    8200 5400
	1    0    0    -1  
$EndComp
Text GLabel 9050 4650 2    50   Input ~ 0
WRB
Wire Wire Line
	8900 4650 9050 4650
Wire Wire Line
	8900 4550 9050 4550
Text GLabel 9050 4550 2    50   Input ~ 0
RDB
Wire Wire Line
	8900 4450 9050 4450
Text GLabel 9050 4450 2    50   Input ~ 0
ROMCSB
$Comp
L power:GND #PWR?
U 1 1 61F0D492
P 1200 7650
AR Path="/60EE1618/61F0D492" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/61F0D492" Ref="#PWR034"  Part="1" 
F 0 "#PWR034" H 1200 7400 50  0001 C CNN
F 1 "GND" H 1205 7477 50  0000 C CNN
F 2 "" H 1200 7650 50  0001 C CNN
F 3 "" H 1200 7650 50  0001 C CNN
	1    1200 7650
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 61F0D498
P 800 7350
AR Path="/60EE1618/61F0D498" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/61F0D498" Ref="C23"  Part="1" 
F 0 "C23" H 892 7396 50  0001 L CNN
F 1 "1u" H 892 7350 50  0001 L CNN
F 2 "" H 800 7350 50  0001 C CNN
F 3 "~" H 800 7350 50  0001 C CNN
	1    800  7350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61F0D49E
P 800 7050
AR Path="/60EE1618/61F0D49E" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/61F0D49E" Ref="#PWR033"  Part="1" 
F 0 "#PWR033" H 800 6900 50  0001 C CNN
F 1 "+5V" H 815 7223 50  0000 C CNN
F 2 "" H 800 7050 50  0001 C CNN
F 3 "" H 800 7050 50  0001 C CNN
	1    800  7050
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 61F0D4A4
P 1000 7350
AR Path="/60EE1618/61F0D4A4" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/61F0D4A4" Ref="C24"  Part="1" 
F 0 "C24" H 1092 7396 50  0001 L CNN
F 1 "1u" H 1092 7350 50  0001 L CNN
F 2 "" H 1000 7350 50  0001 C CNN
F 3 "~" H 1000 7350 50  0001 C CNN
	1    1000 7350
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 61F0D4AA
P 1200 7350
AR Path="/60EE1618/61F0D4AA" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/61F0D4AA" Ref="C25"  Part="1" 
F 0 "C25" H 1292 7396 50  0001 L CNN
F 1 "1u" H 1292 7350 50  0001 L CNN
F 2 "" H 1200 7350 50  0001 C CNN
F 3 "~" H 1200 7350 50  0001 C CNN
	1    1200 7350
	1    0    0    -1  
$EndComp
Wire Wire Line
	800  7050 800  7150
Wire Wire Line
	1000 7150 1000 7250
Wire Wire Line
	800  7450 800  7550
Wire Wire Line
	1000 7450 1000 7550
Wire Wire Line
	1200 7450 1200 7550
Wire Wire Line
	1200 7150 1200 7250
Connection ~ 800  7150
Wire Wire Line
	800  7150 800  7250
Connection ~ 1000 7150
Wire Wire Line
	1000 7150 800  7150
Wire Wire Line
	1200 7150 1000 7150
Wire Wire Line
	800  7550 1000 7550
Wire Wire Line
	1200 7550 1200 7650
Connection ~ 1000 7550
Wire Wire Line
	1000 7550 1200 7550
Connection ~ 1200 7550
$Comp
L power:+5V #PWR039
U 1 1 61D1FEE9
P 8200 2600
F 0 "#PWR039" H 8200 2450 50  0001 C CNN
F 1 "+5V" H 8215 2773 50  0000 C CNN
F 2 "" H 8200 2600 50  0001 C CNN
F 3 "" H 8200 2600 50  0001 C CNN
	1    8200 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 3800 9050 3800
Text GLabel 9050 3800 2    50   BiDi ~ 0
D7
Wire Wire Line
	8900 3700 9050 3700
Text GLabel 9050 3700 2    50   BiDi ~ 0
D6
Wire Wire Line
	8900 3600 9050 3600
Text GLabel 9050 3600 2    50   BiDi ~ 0
D5
Wire Wire Line
	8900 3500 9050 3500
Text GLabel 9050 3500 2    50   BiDi ~ 0
D4
Wire Wire Line
	8900 3400 9050 3400
Text GLabel 9050 3400 2    50   BiDi ~ 0
D3
Wire Wire Line
	8900 3300 9050 3300
Text GLabel 9050 3300 2    50   BiDi ~ 0
D2
Wire Wire Line
	8900 3200 9050 3200
Text GLabel 9050 3200 2    50   BiDi ~ 0
D1
Wire Wire Line
	8900 3100 9050 3100
Text GLabel 9050 3100 2    50   BiDi ~ 0
D0
$EndSCHEMATC
