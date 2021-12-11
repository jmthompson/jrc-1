EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 7 7
Title "JRC-1 Miscellaneous"
Date "2021-12-04"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74xx:74HC74 U18
U 1 1 62825044
P 8500 4500
F 0 "U18" H 8300 4750 50  0000 C CNN
F 1 "SN74AC74N" H 8700 4750 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 8500 4500 50  0001 C CNN
F 3 "" H 8500 4500 50  0001 C CNN
	1    8500 4500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC74 U18
U 2 1 62825937
P 8500 5650
F 0 "U18" H 8300 5900 50  0000 C CNN
F 1 "SN74AC74N" H 8650 5900 50  0001 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 8500 5650 50  0001 C CNN
F 3 "" H 8500 5650 50  0001 C CNN
	2    8500 5650
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC74 U18
U 3 1 62825F3F
P 6550 4500
F 0 "U18" H 6300 4850 50  0000 L CNN
F 1 "SN74AC74N" H 6780 4455 50  0001 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 6550 4500 50  0001 C CNN
F 3 "" H 6550 4500 50  0001 C CNN
	3    6550 4500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR089
U 1 1 62828384
P 6550 3850
F 0 "#PWR089" H 6550 3700 50  0001 C CNN
F 1 "+5V" H 6565 4023 50  0000 C CNN
F 2 "" H 6550 3850 50  0001 C CNN
F 3 "" H 6550 3850 50  0001 C CNN
	1    6550 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 3850 6550 3900
$Comp
L power:GND #PWR090
U 1 1 6282B1B1
P 6550 5250
F 0 "#PWR090" H 6550 5000 50  0001 C CNN
F 1 "GND" H 6555 5077 50  0000 C CNN
F 2 "" H 6550 5250 50  0001 C CNN
F 3 "" H 6550 5250 50  0001 C CNN
	1    6550 5250
	1    0    0    -1  
$EndComp
$Comp
L osc:Osc_8pin U20
U 1 1 62833C22
P 7300 4500
F 0 "U20" H 7150 4850 60  0000 R CNN
F 1 "8.0M" H 7500 4850 60  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_Socket" H 7300 4500 60  0001 C CNN
F 3 "" H 7300 4500 60  0001 C CNN
	1    7300 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 4000 7300 3900
Connection ~ 6550 3900
Wire Wire Line
	6550 3900 6550 4100
Wire Wire Line
	7300 5000 7300 5100
Connection ~ 6550 5100
Wire Wire Line
	6550 5100 6550 4900
Wire Wire Line
	6550 5100 6550 5250
Wire Wire Line
	7700 4500 8200 4500
Wire Wire Line
	8500 3900 8500 4200
Wire Wire Line
	8500 4800 7950 4800
Wire Wire Line
	7950 4800 7950 3900
Wire Wire Line
	8200 4400 8050 4400
Wire Wire Line
	8050 4400 8050 4900
Wire Wire Line
	8050 4900 8900 4900
Wire Wire Line
	8900 4900 8900 4600
Wire Wire Line
	8900 4600 8800 4600
Wire Wire Line
	7950 6050 8500 6050
Wire Wire Line
	8500 6050 8500 5950
Wire Wire Line
	8200 5550 7950 5550
Connection ~ 7950 5550
Wire Wire Line
	7950 5550 7950 5650
Wire Wire Line
	8200 5650 7950 5650
Connection ~ 7950 5650
Wire Wire Line
	7950 5650 7950 6050
Connection ~ 7950 3900
Wire Wire Line
	7950 3900 8500 3900
Connection ~ 7300 3900
Wire Wire Line
	7300 3900 6550 3900
Wire Wire Line
	7300 3900 7950 3900
Wire Wire Line
	7300 5100 6550 5100
Wire Wire Line
	8500 5050 8500 5350
Wire Wire Line
	7950 5050 8500 5050
Wire Wire Line
	7950 5050 7950 5550
Text GLabel 9700 4400 2    50   Output ~ 0
PHI2
$Comp
L Device:C_Small C?
U 1 1 628D0752
P 950 7100
AR Path="/60EE1618/628D0752" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/628D0752" Ref="C?"  Part="1" 
AR Path="/626CE278/628D0752" Ref="C41"  Part="1" 
F 0 "C41" H 1042 7146 50  0001 L CNN
F 1 "1u" H 1042 7100 50  0001 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.00mm" H 950 7100 50  0001 C CNN
F 3 "~" H 950 7100 50  0001 C CNN
	1    950  7100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 628D0758
P 950 6800
AR Path="/60EE1618/628D0758" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/628D0758" Ref="#PWR?"  Part="1" 
AR Path="/626CE278/628D0758" Ref="#PWR085"  Part="1" 
F 0 "#PWR085" H 950 6650 50  0001 C CNN
F 1 "+5V" H 965 6973 50  0000 C CNN
F 2 "" H 950 6800 50  0001 C CNN
F 3 "" H 950 6800 50  0001 C CNN
	1    950  6800
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 628D075E
P 1150 7100
AR Path="/60EE1618/628D075E" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/628D075E" Ref="C?"  Part="1" 
AR Path="/626CE278/628D075E" Ref="C42"  Part="1" 
F 0 "C42" H 1242 7146 50  0001 L CNN
F 1 "1u" H 1242 7100 50  0001 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.00mm" H 1150 7100 50  0001 C CNN
F 3 "~" H 1150 7100 50  0001 C CNN
	1    1150 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 628D0764
P 1550 7100
AR Path="/60EE1618/628D0764" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/628D0764" Ref="C?"  Part="1" 
AR Path="/626CE278/628D0764" Ref="C44"  Part="1" 
F 0 "C44" H 1642 7146 50  0001 L CNN
F 1 "1u" H 1642 7100 50  0001 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.00mm" H 1550 7100 50  0001 C CNN
F 3 "~" H 1550 7100 50  0001 C CNN
	1    1550 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  6800 950  6900
Wire Wire Line
	1150 6900 1150 7000
Wire Wire Line
	950  7200 950  7300
Wire Wire Line
	1150 7200 1150 7300
Wire Wire Line
	1550 7200 1550 7300
Wire Wire Line
	1550 6900 1550 7000
Connection ~ 950  6900
Wire Wire Line
	950  6900 950  7000
Connection ~ 1150 6900
Wire Wire Line
	1150 6900 950  6900
Wire Wire Line
	1550 6900 1350 6900
Wire Wire Line
	950  7300 1150 7300
Connection ~ 1150 7300
Wire Wire Line
	1150 7300 1350 7300
Connection ~ 1550 7300
NoConn ~ 9950 1600
NoConn ~ 9950 1800
Text GLabel 9700 4600 2    50   Output ~ 0
PHI1
Connection ~ 8900 4600
NoConn ~ 8800 5550
NoConn ~ 8800 5750
Wire Wire Line
	7950 4800 7950 5050
Connection ~ 7950 4800
Connection ~ 7950 5050
$Comp
L Device:R_Small_US R1
U 1 1 61FA304D
P 9400 4400
F 0 "R1" V 9300 4400 50  0000 C CNN
F 1 "100" V 9300 4500 50  0001 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 9400 4400 50  0001 C CNN
F 3 "~" H 9400 4400 50  0001 C CNN
	1    9400 4400
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R2
U 1 1 61FA586C
P 9400 4600
F 0 "R2" V 9500 4600 50  0000 C CNN
F 1 "100" V 9300 4600 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 9400 4600 50  0001 C CNN
F 3 "~" H 9400 4600 50  0001 C CNN
	1    9400 4600
	0    1    1    0   
$EndComp
Wire Wire Line
	8800 4400 9300 4400
Wire Wire Line
	8900 4600 9300 4600
Wire Wire Line
	9500 4400 9700 4400
Wire Wire Line
	9500 4600 9700 4600
$Comp
L Device:C_Small C?
U 1 1 61FB63C2
P 1350 7100
AR Path="/60EE1618/61FB63C2" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/61FB63C2" Ref="C?"  Part="1" 
AR Path="/626CE278/61FB63C2" Ref="C43"  Part="1" 
F 0 "C43" H 1442 7146 50  0001 L CNN
F 1 "1u" H 1442 7100 50  0001 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.00mm" H 1350 7100 50  0001 C CNN
F 3 "~" H 1350 7100 50  0001 C CNN
	1    1350 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 6900 1350 7000
Wire Wire Line
	1350 7200 1350 7300
Connection ~ 1350 6900
Wire Wire Line
	1350 6900 1150 6900
Connection ~ 1350 7300
Wire Wire Line
	1350 7300 1550 7300
Wire Wire Line
	7300 1100 9250 1100
Connection ~ 7300 1100
Wire Wire Line
	7300 1200 7300 1100
Wire Wire Line
	5250 1100 5250 1200
Wire Wire Line
	9250 1100 9250 1200
Connection ~ 5250 1100
Wire Wire Line
	6700 2900 5250 2900
Wire Wire Line
	9250 2900 7300 2900
Wire Wire Line
	9250 2800 9250 2900
NoConn ~ 5750 2200
NoConn ~ 5750 2100
NoConn ~ 5750 2000
NoConn ~ 5750 1900
Wire Wire Line
	4750 2200 4650 2200
Wire Wire Line
	4650 2200 4650 2100
Connection ~ 4650 2100
Wire Wire Line
	4750 2100 4650 2100
Wire Wire Line
	4650 2100 4650 2000
Wire Wire Line
	4650 2000 4650 1900
Connection ~ 4650 2000
Wire Wire Line
	4750 2000 4650 2000
Wire Wire Line
	4650 1900 4750 1900
Connection ~ 4650 2200
Wire Wire Line
	4650 2500 4650 2400
Text GLabel 4600 1500 0    50   Input ~ 0
PHI2
Wire Wire Line
	4750 1500 4600 1500
Text GLabel 4600 1600 0    50   Input ~ 0
RWB
Wire Wire Line
	4750 1600 4600 1600
Text GLabel 4600 1700 0    50   Input ~ 0
RDB
Wire Wire Line
	4750 1700 4600 1700
Text GLabel 4600 1800 0    50   Input ~ 0
WRB
Wire Wire Line
	4750 1800 4600 1800
Connection ~ 5250 2900
Wire Wire Line
	4750 2500 4650 2500
Connection ~ 4650 2500
Wire Wire Line
	4650 2500 4650 2900
Wire Wire Line
	4650 2900 5250 2900
Wire Wire Line
	5900 1800 5750 1800
Text GLabel 5900 1800 2    50   Output ~ 0
XWRB
Wire Wire Line
	5900 1700 5750 1700
Text GLabel 5900 1700 2    50   Output ~ 0
XRDB
Wire Wire Line
	5900 1600 5750 1600
Text GLabel 5900 1600 2    50   Output ~ 0
XRWB
Wire Wire Line
	5900 1500 5750 1500
Text GLabel 5900 1500 2    50   Output ~ 0
XPHI2
$Comp
L 74xx:74HC245 U?
U 1 1 61EF9927
P 9250 2000
AR Path="/62BE9D15/61EF9927" Ref="U?"  Part="1" 
AR Path="/60EE1618/61EF9927" Ref="U?"  Part="1" 
AR Path="/6224E7FB/61EF9927" Ref="U?"  Part="1" 
AR Path="/61C6B24D/61EF9927" Ref="U?"  Part="1" 
AR Path="/626CE278/61EF9927" Ref="U21"  Part="1" 
F 0 "U21" H 9000 2650 50  0000 C CNN
F 1 "SN74AHCT245N" H 9550 2650 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 9250 2000 50  0001 C CNN
F 3 "" H 9250 2000 50  0001 C CNN
	1    9250 2000
	1    0    0    -1  
$EndComp
Text GLabel 8600 1500 0    50   BiDi ~ 0
XD0
Wire Wire Line
	8750 1500 8600 1500
Text GLabel 8600 1600 0    50   BiDi ~ 0
XD1
Wire Wire Line
	8750 1600 8600 1600
Text GLabel 8600 1700 0    50   BiDi ~ 0
XD2
Wire Wire Line
	8750 1700 8600 1700
Text GLabel 8600 1800 0    50   BiDi ~ 0
XD3
Wire Wire Line
	8750 1800 8600 1800
Text GLabel 8600 1900 0    50   BiDi ~ 0
XD4
Wire Wire Line
	8750 1900 8600 1900
Text GLabel 8600 2000 0    50   BiDi ~ 0
XD5
Wire Wire Line
	8750 2000 8600 2000
Text GLabel 8600 2100 0    50   BiDi ~ 0
XD6
Wire Wire Line
	8750 2100 8600 2100
Text GLabel 8600 2200 0    50   BiDi ~ 0
XD7
Wire Wire Line
	8750 2200 8600 2200
Text GLabel 9900 1500 2    50   BiDi ~ 0
D0
Wire Wire Line
	9750 1500 9900 1500
Text GLabel 9900 1600 2    50   BiDi ~ 0
D1
Wire Wire Line
	9750 1600 9900 1600
Text GLabel 9900 1700 2    50   BiDi ~ 0
D2
Wire Wire Line
	9750 1700 9900 1700
Text GLabel 9900 1800 2    50   BiDi ~ 0
D3
Wire Wire Line
	9750 1800 9900 1800
Text GLabel 9900 1900 2    50   BiDi ~ 0
D4
Wire Wire Line
	9750 1900 9900 1900
Text GLabel 9900 2000 2    50   BiDi ~ 0
D5
Wire Wire Line
	9750 2000 9900 2000
Text GLabel 9900 2100 2    50   BiDi ~ 0
D6
Wire Wire Line
	9750 2100 9900 2100
Text GLabel 9900 2200 2    50   BiDi ~ 0
D7
Wire Wire Line
	9750 2200 9900 2200
Text GLabel 8600 2400 0    50   Input ~ 0
RWB
Wire Wire Line
	8750 2400 8600 2400
Wire Wire Line
	7300 2800 7300 2900
Wire Wire Line
	6800 2500 6700 2500
Wire Wire Line
	6700 2500 6700 2900
Connection ~ 7300 2900
Connection ~ 6700 2900
Wire Wire Line
	6700 2900 7300 2900
Wire Wire Line
	6800 2400 6700 2400
Wire Wire Line
	6650 2200 6800 2200
Text GLabel 6650 2200 0    50   Input ~ 0
A7
Wire Wire Line
	6650 2100 6800 2100
Text GLabel 6650 2100 0    50   Input ~ 0
A6
Wire Wire Line
	6650 2000 6800 2000
Text GLabel 6650 2000 0    50   Input ~ 0
A5
Wire Wire Line
	6650 1900 6800 1900
Text GLabel 6650 1900 0    50   Input ~ 0
A4
Wire Wire Line
	6650 1800 6800 1800
Text GLabel 6650 1800 0    50   Input ~ 0
A3
Wire Wire Line
	6650 1700 6800 1700
Text GLabel 6650 1700 0    50   Input ~ 0
A2
Wire Wire Line
	6650 1600 6800 1600
Text GLabel 6650 1600 0    50   Input ~ 0
A1
Wire Wire Line
	6650 1500 6800 1500
Text GLabel 6650 1500 0    50   Input ~ 0
A0
Wire Wire Line
	7950 2200 7800 2200
Text GLabel 7950 2200 2    50   Output ~ 0
XA7
Wire Wire Line
	7950 2100 7800 2100
Text GLabel 7950 2100 2    50   Output ~ 0
XA6
Wire Wire Line
	7950 2000 7800 2000
Text GLabel 7950 2000 2    50   Output ~ 0
XA5
Wire Wire Line
	7950 1900 7800 1900
Text GLabel 7950 1900 2    50   Output ~ 0
XA4
Wire Wire Line
	7950 1800 7800 1800
Text GLabel 7950 1800 2    50   Output ~ 0
XA3
Wire Wire Line
	7950 1700 7800 1700
Text GLabel 7950 1700 2    50   Output ~ 0
XA2
Wire Wire Line
	7950 1600 7800 1600
Text GLabel 7950 1600 2    50   Output ~ 0
XA1
Wire Wire Line
	7950 1500 7800 1500
Text GLabel 7950 1500 2    50   Output ~ 0
XA0
Text GLabel 8600 2500 0    50   Input ~ 0
SLOTENB
Wire Wire Line
	8750 2500 8600 2500
Wire Wire Line
	1750 6900 1750 7000
Wire Wire Line
	1750 7300 1950 7300
Connection ~ 1950 7300
Wire Wire Line
	1950 7200 1950 7300
Wire Wire Line
	1750 7200 1750 7300
Wire Wire Line
	1950 6900 1750 6900
Wire Wire Line
	1950 6900 1950 7000
Connection ~ 1750 6900
$Comp
L Device:C_Small C?
U 1 1 61F16B61
P 1950 7100
AR Path="/60EE1618/61F16B61" Ref="C?"  Part="1" 
AR Path="/61C6B24D/61F16B61" Ref="C?"  Part="1" 
AR Path="/626CE278/61F16B61" Ref="C46"  Part="1" 
F 0 "C46" H 2042 7146 50  0001 L CNN
F 1 "0.1u" H 2042 7100 50  0001 L CNN
F 2 "Capacitor_THT:C_Rect_L4.6mm_W2.0mm_P2.50mm_MKS02_FKP02" H 1950 7100 50  0001 C CNN
F 3 "~" H 1950 7100 50  0001 C CNN
	1    1950 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 61F16B6D
P 1750 7100
AR Path="/60EE1618/61F16B6D" Ref="C?"  Part="1" 
AR Path="/61C6B24D/61F16B6D" Ref="C?"  Part="1" 
AR Path="/626CE278/61F16B6D" Ref="C45"  Part="1" 
F 0 "C45" H 1842 7146 50  0001 L CNN
F 1 "0.1u" H 1842 7100 50  0001 L CNN
F 2 "Capacitor_THT:C_Rect_L4.6mm_W2.0mm_P2.50mm_MKS02_FKP02" H 1750 7100 50  0001 C CNN
F 3 "~" H 1750 7100 50  0001 C CNN
	1    1750 7100
	1    0    0    -1  
$EndComp
$Comp
L 65xx:W65C22SxPL U?
U 1 1 61F35928
P 2500 2550
AR Path="/61B43476/61F35928" Ref="U?"  Part="1" 
AR Path="/62053143/61F35928" Ref="U?"  Part="1" 
AR Path="/6256DBED/61F35928" Ref="U?"  Part="1" 
AR Path="/626CE278/61F35928" Ref="U16"  Part="1" 
F 0 "U16" H 2150 3850 50  0000 C CNN
F 1 "W65C22SxPL" H 2800 3850 50  0000 C CIB
F 2 "Package_LCC:PLCC-44_THT-Socket" H 2500 2700 50  0001 C CNN
F 3 "http://www.westerndesigncenter.com/wdc/documentation/w65c22.pdf" H 2500 2700 50  0001 C CNN
	1    2500 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 61F35935
P 5250 4100
AR Path="/61B43476/61F35935" Ref="#PWR?"  Part="1" 
AR Path="/62053143/61F35935" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/61F35935" Ref="#PWR?"  Part="1" 
AR Path="/626CE278/61F35935" Ref="#PWR088"  Part="1" 
F 0 "#PWR088" H 5250 3850 50  0001 C CNN
F 1 "GND" H 5255 3927 50  0000 C CNN
F 2 "" H 5250 4100 50  0001 C CNN
F 3 "" H 5250 4100 50  0001 C CNN
	1    5250 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 4000 5250 4100
Text GLabel 1750 1450 0    50   Input ~ 0
RESETB
Wire Wire Line
	1900 1450 1750 1450
Text GLabel 1750 2950 0    50   BiDi ~ 0
D0
Wire Wire Line
	1900 2950 1750 2950
Text GLabel 1750 3050 0    50   BiDi ~ 0
D1
Wire Wire Line
	1900 3050 1750 3050
Text GLabel 1750 3150 0    50   BiDi ~ 0
D2
Wire Wire Line
	1900 3150 1750 3150
Text GLabel 1750 3250 0    50   BiDi ~ 0
D3
Wire Wire Line
	1900 3250 1750 3250
Text GLabel 1750 3350 0    50   BiDi ~ 0
D4
Wire Wire Line
	1900 3350 1750 3350
Text GLabel 1750 3450 0    50   BiDi ~ 0
D5
Wire Wire Line
	1900 3450 1750 3450
Text GLabel 1750 3550 0    50   BiDi ~ 0
D6
Wire Wire Line
	1900 3550 1750 3550
Text GLabel 1750 3650 0    50   BiDi ~ 0
D7
Wire Wire Line
	1900 3650 1750 3650
Text GLabel 1750 1550 0    50   Input ~ 0
PHI2
Wire Wire Line
	1900 1550 1750 1550
Text GLabel 1750 2050 0    50   Input ~ 0
VIASELB
Wire Wire Line
	1900 2050 1750 2050
Wire Wire Line
	2500 1100 950  1100
Wire Wire Line
	950  1100 950  1950
Wire Wire Line
	950  1950 1900 1950
Connection ~ 2500 1100
Text GLabel 1750 1750 0    50   Output ~ 0
VIAIRQB
Wire Wire Line
	1900 1750 1750 1750
Text GLabel 1750 2250 0    50   Input ~ 0
A0
Wire Wire Line
	1900 2250 1750 2250
Text GLabel 1750 2350 0    50   Input ~ 0
A1
Wire Wire Line
	1900 2350 1750 2350
Text GLabel 1750 2450 0    50   Input ~ 0
A2
Wire Wire Line
	1900 2450 1750 2450
Text GLabel 1750 2550 0    50   Input ~ 0
A3
Wire Wire Line
	1900 2550 1750 2550
Text GLabel 1750 2750 0    50   Input ~ 0
RWB
Wire Wire Line
	1900 2750 1750 2750
Text GLabel 3250 1450 2    50   BiDi ~ 0
PA0
Wire Wire Line
	3100 1450 3250 1450
Text GLabel 3250 1550 2    50   BiDi ~ 0
PA1
Wire Wire Line
	3100 1550 3250 1550
Text GLabel 3250 1650 2    50   BiDi ~ 0
PA2
Wire Wire Line
	3100 1650 3250 1650
Text GLabel 3250 1750 2    50   BiDi ~ 0
PA3
Wire Wire Line
	3100 1750 3250 1750
Text GLabel 3250 1850 2    50   BiDi ~ 0
PA4
Wire Wire Line
	3100 1850 3250 1850
Text GLabel 3250 1950 2    50   BiDi ~ 0
PA5
Wire Wire Line
	3100 1950 3250 1950
Text GLabel 3250 2050 2    50   BiDi ~ 0
PA6
Wire Wire Line
	3100 2050 3250 2050
Text GLabel 3250 2150 2    50   BiDi ~ 0
PA7
Wire Wire Line
	3100 2150 3250 2150
Wire Wire Line
	3100 2650 3250 2650
Wire Wire Line
	3100 2750 3250 2750
Wire Wire Line
	3100 2850 3250 2850
Wire Wire Line
	3100 2950 3250 2950
Wire Wire Line
	3100 3050 3250 3050
Wire Wire Line
	3100 3150 3250 3150
Wire Wire Line
	3100 3250 3250 3250
Wire Wire Line
	3100 3350 3250 3350
Text GLabel 3250 2650 2    50   BiDi ~ 0
PB0
Text GLabel 3250 2750 2    50   BiDi ~ 0
PB1
Text GLabel 3250 2850 2    50   BiDi ~ 0
PB2
Text GLabel 3250 2950 2    50   BiDi ~ 0
PB3
Text GLabel 3250 3050 2    50   BiDi ~ 0
PB4
Text GLabel 3250 3150 2    50   BiDi ~ 0
PB5
Text GLabel 3250 3250 2    50   BiDi ~ 0
PB6
Text GLabel 3250 3350 2    50   BiDi ~ 0
PB7
Wire Wire Line
	3100 2350 3250 2350
Wire Wire Line
	3100 2450 3250 2450
Text GLabel 3250 2350 2    50   BiDi ~ 0
CA1
Text GLabel 3250 2450 2    50   BiDi ~ 0
CA2
Wire Wire Line
	3100 3550 3250 3550
Wire Wire Line
	3100 3650 3250 3650
Text GLabel 3250 3550 2    50   BiDi ~ 0
CB1
Text GLabel 3250 3650 2    50   BiDi ~ 0
CB2
Wire Wire Line
	5250 4000 2500 4000
Wire Wire Line
	1550 7300 1750 7300
Connection ~ 1750 7300
Wire Wire Line
	1550 6900 1750 6900
Connection ~ 1550 6900
$Comp
L 74xx:74LS541 U17
U 1 1 620874B4
P 5250 2000
F 0 "U17" H 5000 2650 50  0000 C CNN
F 1 "CD74AC541E" H 5550 2650 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 5250 2000 50  0001 C CNN
F 3 "" H 5250 2000 50  0001 C CNN
	1    5250 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 2400 4650 2400
Connection ~ 4650 2400
Wire Wire Line
	4650 2400 4650 2200
$Comp
L 74xx:74LS541 U19
U 1 1 620A2232
P 7300 2000
F 0 "U19" H 7050 2650 50  0000 C CNN
F 1 "CD74AC541E" H 7600 2650 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 7300 2000 50  0001 C CNN
F 3 "" H 7300 2000 50  0001 C CNN
	1    7300 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 2500 6700 2400
Connection ~ 6700 2500
Wire Wire Line
	5250 1100 7300 1100
$Comp
L power:+5V #PWR?
U 1 1 61F3592E
P 5250 950
AR Path="/61B43476/61F3592E" Ref="#PWR?"  Part="1" 
AR Path="/62053143/61F3592E" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/61F3592E" Ref="#PWR?"  Part="1" 
AR Path="/626CE278/61F3592E" Ref="#PWR087"  Part="1" 
F 0 "#PWR087" H 5250 800 50  0001 C CNN
F 1 "+5V" H 5265 1123 50  0000 C CNN
F 2 "" H 5250 950 50  0001 C CNN
F 3 "" H 5250 950 50  0001 C CNN
	1    5250 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 950  5250 1100
Wire Wire Line
	2500 1100 5250 1100
Wire Wire Line
	5250 2800 5250 2900
Wire Wire Line
	5250 2900 5250 4000
Connection ~ 5250 4000
Wire Wire Line
	1950 7300 1950 7400
$Comp
L power:GND #PWR?
U 1 1 61FB3252
P 1950 7400
AR Path="/60EE1618/61FB3252" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/61FB3252" Ref="#PWR?"  Part="1" 
AR Path="/61B43476/61FB3252" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/61FB3252" Ref="#PWR?"  Part="1" 
AR Path="/626CE278/61FB3252" Ref="#PWR086"  Part="1" 
F 0 "#PWR086" H 1950 7150 50  0001 C CNN
F 1 "GND" H 1955 7227 50  0000 C CNN
F 2 "" H 1950 7400 50  0001 C CNN
F 3 "" H 1950 7400 50  0001 C CNN
	1    1950 7400
	1    0    0    -1  
$EndComp
$EndSCHEMATC
