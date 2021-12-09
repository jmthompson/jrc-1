EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 8 9
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
L power:GND #PWR?
U 1 1 62056784
P 1200 7600
AR Path="/60EE1618/62056784" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/62056784" Ref="#PWR?"  Part="1" 
AR Path="/61B43476/62056784" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/62056784" Ref="#PWR052"  Part="1" 
F 0 "#PWR052" H 1200 7350 50  0001 C CNN
F 1 "GND" H 1205 7427 50  0000 C CNN
F 2 "" H 1200 7600 50  0001 C CNN
F 3 "" H 1200 7600 50  0001 C CNN
	1    1200 7600
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 6205678A
P 1200 7300
AR Path="/60EE1618/6205678A" Ref="C?"  Part="1" 
AR Path="/61ADDFAC/6205678A" Ref="C?"  Part="1" 
AR Path="/61B43476/6205678A" Ref="C?"  Part="1" 
AR Path="/6256DBED/6205678A" Ref="C30"  Part="1" 
F 0 "C30" H 1292 7346 50  0001 L CNN
F 1 "1u" H 1292 7300 50  0001 L CNN
F 2 "" H 1200 7300 50  0001 C CNN
F 3 "~" H 1200 7300 50  0001 C CNN
	1    1200 7300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62602CC2
P 1200 7000
AR Path="/60EE1618/62602CC2" Ref="#PWR?"  Part="1" 
AR Path="/61ADDFAC/62602CC2" Ref="#PWR?"  Part="1" 
AR Path="/61B43476/62602CC2" Ref="#PWR?"  Part="1" 
AR Path="/6256DBED/62602CC2" Ref="#PWR051"  Part="1" 
F 0 "#PWR051" H 1200 6850 50  0001 C CNN
F 1 "+5V" H 1215 7173 50  0000 C CNN
F 2 "" H 1200 7000 50  0001 C CNN
F 3 "" H 1200 7000 50  0001 C CNN
	1    1200 7000
	1    0    0    -1  
$EndComp
Text Notes 900  6700 0    50   ~ 0
Bypass Capacitor\n
Wire Notes Line
	700  6750 700  7850
Wire Notes Line
	700  7850 1750 7850
Wire Notes Line
	1750 6750 700  6750
Wire Notes Line
	1750 7850 1750 6750
Wire Wire Line
	1200 7000 1200 7200
Wire Wire Line
	1200 7400 1200 7600
$EndSCHEMATC
