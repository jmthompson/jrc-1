EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 8 8
Title "JRC-1 CPLD Logic"
Date "2021-12-08"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text GLabel 4500 3850 2    50   Output ~ 0
UARTSELB
Text GLabel 4500 3650 2    50   Output ~ 0
VIASELB
Wire Wire Line
	4350 3450 4500 3450
Text GLabel 4500 3450 2    50   Output ~ 0
RAM2CSB
Wire Wire Line
	4350 3350 4500 3350
Text GLabel 4500 3350 2    50   Output ~ 0
RAM1CSB
Wire Wire Line
	4350 3250 4500 3250
Text GLabel 4500 3250 2    50   Output ~ 0
ROMCSB
Wire Wire Line
	2900 3850 3050 3850
Text GLabel 2900 3850 0    50   Input ~ 0
A15
Wire Wire Line
	2900 3750 3050 3750
Text GLabel 2900 3750 0    50   Input ~ 0
A14
Wire Wire Line
	2900 3650 3050 3650
Text GLabel 2900 3650 0    50   Input ~ 0
A13
Wire Wire Line
	2900 3550 3050 3550
Text GLabel 2900 3550 0    50   Input ~ 0
A12
Wire Wire Line
	2900 3450 3050 3450
Text GLabel 2900 3450 0    50   Input ~ 0
A11
Wire Wire Line
	2900 3350 3050 3350
Text GLabel 2900 3350 0    50   Input ~ 0
A10
Wire Wire Line
	2900 3250 3050 3250
Text GLabel 2900 3250 0    50   Input ~ 0
A9
Wire Wire Line
	2900 3150 3050 3150
Text GLabel 2900 3150 0    50   Input ~ 0
A8
Wire Wire Line
	2900 4650 3050 4650
Text GLabel 2900 4650 0    50   Input ~ 0
VDA
Wire Wire Line
	3750 5250 3650 5250
Connection ~ 3750 5250
Wire Wire Line
	3750 5150 3750 5250
Wire Wire Line
	3650 5250 3550 5250
Connection ~ 3650 5250
Wire Wire Line
	3650 5150 3650 5250
Connection ~ 3550 5250
Wire Wire Line
	3850 5250 3750 5250
Wire Wire Line
	3850 5150 3850 5250
Wire Wire Line
	3550 5150 3550 5250
$Comp
L power:GND #PWR?
U 1 1 62269CB7
P 3550 5350
AR Path="/60EE1618/62269CB7" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/62269CB7" Ref="#PWR096"  Part="1" 
F 0 "#PWR096" H 3550 5100 50  0001 C CNN
F 1 "GND" H 3555 5177 50  0000 C CNN
F 2 "" H 3550 5350 50  0001 C CNN
F 3 "" H 3550 5350 50  0001 C CNN
	1    3550 5350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62269CBD
P 3550 2300
AR Path="/60EE1618/62269CBD" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/62269CBD" Ref="#PWR095"  Part="1" 
F 0 "#PWR095" H 3550 2150 50  0001 C CNN
F 1 "+5V" H 3565 2473 50  0000 C CNN
F 2 "" H 3550 2300 50  0001 C CNN
F 3 "" H 3550 2300 50  0001 C CNN
	1    3550 2300
	1    0    0    -1  
$EndComp
$Comp
L jrc-1:JIGL U?
U 1 1 62269CC3
P 3700 3900
AR Path="/60EE1618/62269CC3" Ref="U?"  Part="1" 
AR Path="/6224E7FB/62269CC3" Ref="U19"  Part="1" 
F 0 "U19" H 3200 5100 50  0000 C CNN
F 1 "JIGL" H 4150 5100 50  0000 C CNN
F 2 "" H 3700 3900 50  0001 C CNN
F 3 "" H 3700 3900 50  0001 C CNN
	1    3700 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2900 4350 3050 4350
Text GLabel 2900 4350 0    50   Input ~ 0
A20
Wire Wire Line
	2900 4250 3050 4250
Text GLabel 2900 4250 0    50   Input ~ 0
A19
Wire Wire Line
	2900 4150 3050 4150
Text GLabel 2900 4150 0    50   Input ~ 0
A18
Wire Wire Line
	2900 4050 3050 4050
Text GLabel 2900 4050 0    50   Input ~ 0
A17
Wire Wire Line
	2900 3950 3050 3950
Text GLabel 2900 3950 0    50   Input ~ 0
A16
Wire Wire Line
	2900 4750 3050 4750
Text GLabel 2900 4750 0    50   Input ~ 0
VPA
Wire Wire Line
	3550 2300 3550 2500
Wire Wire Line
	3850 2500 3750 2500
Connection ~ 3550 2500
Connection ~ 3650 2500
Wire Wire Line
	3650 2500 3550 2500
Connection ~ 3750 2500
Wire Wire Line
	3750 2500 3650 2500
Wire Wire Line
	3750 2500 3750 2650
Wire Wire Line
	3650 2500 3650 2650
Wire Wire Line
	3850 2500 3850 2650
Wire Wire Line
	3550 2500 3550 2650
Wire Wire Line
	3550 5250 3550 5350
Wire Wire Line
	4350 3650 4500 3650
Wire Wire Line
	4350 3850 4500 3850
Wire Wire Line
	2900 3050 3050 3050
Text GLabel 2900 3050 0    50   Input ~ 0
A5
Wire Wire Line
	2900 2950 3050 2950
Text GLabel 2900 2950 0    50   Input ~ 0
A4
Text GLabel 4500 4150 2    50   Output ~ 0
SLOT1SELB
Wire Wire Line
	4350 4150 4500 4150
Text GLabel 4500 4250 2    50   Output ~ 0
SLOT2SELB
Wire Wire Line
	4350 4250 4500 4250
Text GLabel 4500 4350 2    50   Output ~ 0
SLOT3SELB
Wire Wire Line
	4350 4350 4500 4350
Text GLabel 4500 4550 2    50   Input ~ 0
TCK
Text GLabel 4500 4850 2    50   Input ~ 0
TDI
Text GLabel 4500 4750 2    50   Input ~ 0
TMS
Wire Wire Line
	4350 4550 4500 4550
Wire Wire Line
	4350 4750 4500 4750
Wire Wire Line
	4350 4850 4500 4850
Text GLabel 4500 4050 2    50   Output ~ 0
SLOTENB
Wire Wire Line
	4350 4050 4500 4050
$Comp
L jrc-1:SPI-65B U20
U 1 1 62947BB2
P 7800 3900
F 0 "U20" H 7300 5100 50  0000 C CNN
F 1 "SPI-65B" H 8200 5100 50  0000 C CNN
F 2 "" H 6000 4300 50  0001 C CNN
F 3 "" H 6000 4300 50  0001 C CNN
	1    7800 3900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 6294A95C
P 7650 2300
AR Path="/60EE1618/6294A95C" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/6294A95C" Ref="#PWR097"  Part="1" 
F 0 "#PWR097" H 7650 2150 50  0001 C CNN
F 1 "+5V" H 7665 2473 50  0000 C CNN
F 2 "" H 7650 2300 50  0001 C CNN
F 3 "" H 7650 2300 50  0001 C CNN
	1    7650 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 2300 7650 2500
Wire Wire Line
	7950 2500 7850 2500
Connection ~ 7650 2500
Connection ~ 7750 2500
Wire Wire Line
	7750 2500 7650 2500
Connection ~ 7850 2500
Wire Wire Line
	7850 2500 7750 2500
Wire Wire Line
	7850 2500 7850 2650
Wire Wire Line
	7750 2500 7750 2650
Wire Wire Line
	7950 2500 7950 2650
Wire Wire Line
	7650 2500 7650 2650
Wire Wire Line
	7000 3750 7150 3750
Text GLabel 7000 3750 0    50   Input ~ 0
A1
Wire Wire Line
	7000 3650 7150 3650
Text GLabel 7000 3650 0    50   Input ~ 0
A0
Wire Wire Line
	7650 2500 6650 2500
Wire Wire Line
	6650 2500 6650 3450
Wire Wire Line
	6650 3450 7150 3450
Wire Wire Line
	6650 3750 6650 3550
Wire Wire Line
	6650 3550 7150 3550
Wire Wire Line
	4350 3750 6650 3750
Wire Wire Line
	7000 2950 7150 2950
Text GLabel 7000 2950 0    50   Input ~ 0
PHI2
Wire Wire Line
	7000 3050 7150 3050
Text GLabel 7000 3050 0    50   Input ~ 0
RWB
Wire Wire Line
	7000 3150 7150 3150
Text GLabel 7000 3150 0    50   Input ~ 0
RESETB
Wire Wire Line
	7000 3250 7150 3250
Text GLabel 7000 3250 0    50   Output ~ 0
SPIIRQB
Text GLabel 7000 3950 0    50   BiDi ~ 0
D0
Wire Wire Line
	7150 3950 7000 3950
Text GLabel 7000 4050 0    50   BiDi ~ 0
D1
Wire Wire Line
	7150 4050 7000 4050
Text GLabel 7000 4150 0    50   BiDi ~ 0
D2
Wire Wire Line
	7150 4150 7000 4150
Text GLabel 7000 4250 0    50   BiDi ~ 0
D3
Wire Wire Line
	7150 4250 7000 4250
Text GLabel 7000 4350 0    50   BiDi ~ 0
D4
Wire Wire Line
	7150 4350 7000 4350
Text GLabel 7000 4450 0    50   BiDi ~ 0
D5
Wire Wire Line
	7150 4450 7000 4450
Text GLabel 7000 4550 0    50   BiDi ~ 0
D6
Wire Wire Line
	7150 4550 7000 4550
Text GLabel 7000 4650 0    50   BiDi ~ 0
D7
Wire Wire Line
	7150 4650 7000 4650
Wire Wire Line
	8600 4050 8450 4050
Text GLabel 8600 4050 2    50   Output ~ 0
MOSI
Wire Wire Line
	8600 4150 8450 4150
Text GLabel 8600 4150 2    50   Output ~ 0
MISO
Wire Wire Line
	8600 4250 8450 4250
Text GLabel 8600 4250 2    50   Output ~ 0
SCK
Wire Wire Line
	8600 3200 8450 3200
Text GLabel 8600 3200 2    50   Output ~ 0
SS0
Wire Wire Line
	8600 3300 8450 3300
Text GLabel 8600 3300 2    50   Output ~ 0
SS1
Wire Wire Line
	8600 3400 8450 3400
Text GLabel 8600 3400 2    50   Output ~ 0
SS2
Wire Wire Line
	8600 3500 8450 3500
Text GLabel 8600 3500 2    50   Output ~ 0
SS3
Wire Wire Line
	8600 3600 8450 3600
Text GLabel 8600 3600 2    50   Output ~ 0
SS4
Wire Wire Line
	8600 3700 8450 3700
Text GLabel 8600 3700 2    50   Output ~ 0
SS5
Wire Wire Line
	8600 3800 8450 3800
Text GLabel 8600 3800 2    50   Output ~ 0
SS6
Wire Wire Line
	8600 3900 8450 3900
Text GLabel 8600 3900 2    50   Output ~ 0
SS7
Text GLabel 8600 4550 2    50   Input ~ 0
TCK
Text GLabel 8600 4650 2    50   Output ~ 0
TDO
Text GLabel 8600 4750 2    50   Input ~ 0
TMS
Wire Wire Line
	8450 4550 8600 4550
Wire Wire Line
	8450 4650 8600 4650
Wire Wire Line
	8450 4750 8600 4750
Wire Wire Line
	7850 5250 7750 5250
Connection ~ 7850 5250
Wire Wire Line
	7850 5150 7850 5250
Wire Wire Line
	7750 5250 7650 5250
Connection ~ 7750 5250
Wire Wire Line
	7750 5150 7750 5250
Connection ~ 7650 5250
Wire Wire Line
	7950 5250 7850 5250
Wire Wire Line
	7950 5150 7950 5250
Wire Wire Line
	7650 5150 7650 5250
$Comp
L power:GND #PWR?
U 1 1 629825A1
P 7650 5350
AR Path="/60EE1618/629825A1" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/629825A1" Ref="#PWR098"  Part="1" 
F 0 "#PWR098" H 7650 5100 50  0001 C CNN
F 1 "GND" H 7655 5177 50  0000 C CNN
F 2 "" H 7650 5350 50  0001 C CNN
F 3 "" H 7650 5350 50  0001 C CNN
	1    7650 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 5250 7650 5350
Wire Wire Line
	5900 4650 5900 5700
Wire Wire Line
	5900 5700 8750 5700
Wire Wire Line
	8750 5700 8750 4850
Wire Wire Line
	4350 4650 5900 4650
Wire Wire Line
	8450 4850 8750 4850
NoConn ~ 7150 4900
Text GLabel 8600 2900 2    50   Output ~ 0
RDB
Wire Wire Line
	8450 2900 8600 2900
Wire Wire Line
	8450 3000 8600 3000
Text GLabel 8600 3000 2    50   Output ~ 0
WRB
$Comp
L power:GND #PWR?
U 1 1 635CDFA5
P 2150 7500
AR Path="/60EE1618/635CDFA5" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/635CDFA5" Ref="#PWR094"  Part="1" 
F 0 "#PWR094" H 2150 7250 50  0001 C CNN
F 1 "GND" H 2155 7327 50  0000 C CNN
F 2 "" H 2150 7500 50  0001 C CNN
F 3 "" H 2150 7500 50  0001 C CNN
	1    2150 7500
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 635CDFAB
P 750 7200
AR Path="/60EE1618/635CDFAB" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFAB" Ref="C38"  Part="1" 
F 0 "C38" H 842 7246 50  0001 L CNN
F 1 "1u" H 842 7200 50  0001 L CNN
F 2 "" H 750 7200 50  0001 C CNN
F 3 "~" H 750 7200 50  0001 C CNN
	1    750  7200
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 635CDFB1
P 750 6900
AR Path="/60EE1618/635CDFB1" Ref="#PWR?"  Part="1" 
AR Path="/6224E7FB/635CDFB1" Ref="#PWR093"  Part="1" 
F 0 "#PWR093" H 750 6750 50  0001 C CNN
F 1 "+5V" H 765 7073 50  0000 C CNN
F 2 "" H 750 6900 50  0001 C CNN
F 3 "" H 750 6900 50  0001 C CNN
	1    750  6900
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 635CDFB7
P 950 7200
AR Path="/60EE1618/635CDFB7" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFB7" Ref="C39"  Part="1" 
F 0 "C39" H 1042 7246 50  0001 L CNN
F 1 "1u" H 1042 7200 50  0001 L CNN
F 2 "" H 950 7200 50  0001 C CNN
F 3 "~" H 950 7200 50  0001 C CNN
	1    950  7200
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 635CDFBD
P 1150 7200
AR Path="/60EE1618/635CDFBD" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFBD" Ref="C40"  Part="1" 
F 0 "C40" H 1242 7246 50  0001 L CNN
F 1 "1u" H 1242 7200 50  0001 L CNN
F 2 "" H 1150 7200 50  0001 C CNN
F 3 "~" H 1150 7200 50  0001 C CNN
	1    1150 7200
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 635CDFC3
P 1350 7200
AR Path="/60EE1618/635CDFC3" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFC3" Ref="C41"  Part="1" 
F 0 "C41" H 1442 7246 50  0001 L CNN
F 1 "1u" H 1442 7200 50  0001 L CNN
F 2 "" H 1350 7200 50  0001 C CNN
F 3 "~" H 1350 7200 50  0001 C CNN
	1    1350 7200
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 635CDFC9
P 1550 7200
AR Path="/60EE1618/635CDFC9" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFC9" Ref="C42"  Part="1" 
F 0 "C42" H 1642 7246 50  0001 L CNN
F 1 "1u" H 1642 7200 50  0001 L CNN
F 2 "" H 1550 7200 50  0001 C CNN
F 3 "~" H 1550 7200 50  0001 C CNN
	1    1550 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	750  6900 750  7000
Wire Wire Line
	950  7000 950  7100
Wire Wire Line
	750  7300 750  7400
Wire Wire Line
	950  7300 950  7400
Wire Wire Line
	1150 7300 1150 7400
Wire Wire Line
	1350 7300 1350 7400
Wire Wire Line
	1550 7300 1550 7400
Wire Wire Line
	1150 7000 1150 7100
Wire Wire Line
	1350 7000 1350 7100
Wire Wire Line
	1550 7000 1550 7100
Connection ~ 750  7000
Wire Wire Line
	750  7000 750  7100
Connection ~ 950  7000
Wire Wire Line
	950  7000 750  7000
Connection ~ 1150 7000
Wire Wire Line
	1150 7000 950  7000
Connection ~ 1350 7000
Wire Wire Line
	1350 7000 1150 7000
Wire Wire Line
	1550 7000 1350 7000
Wire Wire Line
	750  7400 950  7400
Connection ~ 950  7400
Wire Wire Line
	950  7400 1150 7400
Connection ~ 1150 7400
Wire Wire Line
	1150 7400 1350 7400
Connection ~ 1350 7400
Wire Wire Line
	1350 7400 1550 7400
Connection ~ 1550 7400
$Comp
L Device:C_Small C?
U 1 1 635CDFEB
P 1750 7200
AR Path="/60EE1618/635CDFEB" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFEB" Ref="C43"  Part="1" 
F 0 "C43" H 1842 7246 50  0001 L CNN
F 1 "1u" H 1842 7200 50  0001 L CNN
F 2 "" H 1750 7200 50  0001 C CNN
F 3 "~" H 1750 7200 50  0001 C CNN
	1    1750 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 7400 1550 7400
Wire Wire Line
	1550 7000 1750 7000
Wire Wire Line
	1750 7000 1750 7100
Connection ~ 1550 7000
Wire Wire Line
	1750 7300 1750 7400
$Comp
L Device:C_Small C?
U 1 1 635CDFF6
P 1950 7200
AR Path="/60EE1618/635CDFF6" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635CDFF6" Ref="C44"  Part="1" 
F 0 "C44" H 2042 7246 50  0001 L CNN
F 1 "1u" H 2042 7200 50  0001 L CNN
F 2 "" H 1950 7200 50  0001 C CNN
F 3 "~" H 1950 7200 50  0001 C CNN
	1    1950 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 7000 1950 7000
Wire Wire Line
	1950 7000 1950 7100
Connection ~ 1750 7000
$Comp
L Device:C_Small C?
U 1 1 635D31AA
P 2150 7200
AR Path="/60EE1618/635D31AA" Ref="C?"  Part="1" 
AR Path="/6224E7FB/635D31AA" Ref="C45"  Part="1" 
F 0 "C45" H 2242 7246 50  0001 L CNN
F 1 "1u" H 2242 7200 50  0001 L CNN
F 2 "" H 2150 7200 50  0001 C CNN
F 3 "~" H 2150 7200 50  0001 C CNN
	1    2150 7200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 7000 2150 7000
Wire Wire Line
	2150 7000 2150 7100
Connection ~ 1950 7000
Connection ~ 1750 7400
Connection ~ 1950 7400
Wire Wire Line
	1950 7400 1950 7300
Wire Wire Line
	1750 7400 1950 7400
Wire Wire Line
	2150 7400 2150 7500
Wire Wire Line
	1950 7400 2150 7400
Wire Wire Line
	2150 7400 2150 7300
Connection ~ 2150 7400
Text GLabel 2900 4550 0    50   Input ~ 0
RESETB
Wire Wire Line
	2900 4550 3050 4550
Wire Wire Line
	4350 3050 4500 3050
Text GLabel 4500 3050 2    50   Output ~ 0
RESET
$EndSCHEMATC
