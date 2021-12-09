-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1.78 SJ Web Edition"

-- DATE "12/08/2021 22:33:55"

-- 
-- Device: Altera EPM7064SLC44-7 Package PLCC44
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE;
LIBRARY MAX;
USE IEEE.STD_LOGIC_1164.ALL;
USE MAX.MAX_COMPONENTS.ALL;

ENTITY 	jigl IS
    PORT (
	A4 : IN std_logic;
	A5 : IN std_logic;
	A8 : IN std_logic;
	A9 : IN std_logic;
	A10 : IN std_logic;
	A11 : IN std_logic;
	A12 : IN std_logic;
	A13 : IN std_logic;
	A14 : IN std_logic;
	A15 : IN std_logic;
	A16 : IN std_logic;
	A17 : IN std_logic;
	A18 : IN std_logic;
	A19 : IN std_logic;
	A20 : IN std_logic;
	VDA : IN std_logic;
	VPA : IN std_logic;
	nRESET : IN std_logic;
	RESET : OUT std_logic;
	nROMCS : OUT std_logic;
	nRAM1CS : OUT std_logic;
	nRAM2CS : OUT std_logic;
	nVIASEL : OUT std_logic;
	nSPISEL : OUT std_logic;
	nUARTSEL : OUT std_logic;
	nSLOTEN : OUT std_logic;
	nSLOT1SEL : OUT std_logic;
	nSLOT2SEL : OUT std_logic;
	nSLOT3SEL : OUT std_logic
	);
END jigl;

-- Design Ports Information
-- A4	=>  Location: PIN_39
-- A5	=>  Location: PIN_36
-- A8	=>  Location: PIN_26
-- A9	=>  Location: PIN_1
-- A10	=>  Location: PIN_44
-- A11	=>  Location: PIN_41
-- A12	=>  Location: PIN_40
-- A13	=>  Location: PIN_25
-- A14	=>  Location: PIN_34
-- A15	=>  Location: PIN_2
-- A16	=>  Location: PIN_14
-- A17	=>  Location: PIN_28
-- A18	=>  Location: PIN_29
-- A19	=>  Location: PIN_37
-- A20	=>  Location: PIN_27
-- VDA	=>  Location: PIN_31
-- VPA	=>  Location: PIN_16
-- nRESET	=>  Location: PIN_17
-- RESET	=>  Location: PIN_21
-- nRAM2CS	=>  Location: PIN_20
-- nROMCS	=>  Location: PIN_19
-- nRAM1CS	=>  Location: PIN_18
-- nSLOT1SEL	=>  Location: PIN_12
-- nSLOT2SEL	=>  Location: PIN_6
-- nSLOT3SEL	=>  Location: PIN_5
-- nSPISEL	=>  Location: PIN_4
-- nSLOTEN	=>  Location: PIN_11
-- nVIASEL	=>  Location: PIN_8
-- nUARTSEL	=>  Location: PIN_9


ARCHITECTURE structure OF jigl IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_A4 : std_logic;
SIGNAL ww_A5 : std_logic;
SIGNAL ww_A8 : std_logic;
SIGNAL ww_A9 : std_logic;
SIGNAL ww_A10 : std_logic;
SIGNAL ww_A11 : std_logic;
SIGNAL ww_A12 : std_logic;
SIGNAL ww_A13 : std_logic;
SIGNAL ww_A14 : std_logic;
SIGNAL ww_A15 : std_logic;
SIGNAL ww_A16 : std_logic;
SIGNAL ww_A17 : std_logic;
SIGNAL ww_A18 : std_logic;
SIGNAL ww_A19 : std_logic;
SIGNAL ww_A20 : std_logic;
SIGNAL ww_VDA : std_logic;
SIGNAL ww_VPA : std_logic;
SIGNAL ww_nRESET : std_logic;
SIGNAL ww_RESET : std_logic;
SIGNAL ww_nROMCS : std_logic;
SIGNAL ww_nRAM1CS : std_logic;
SIGNAL ww_nRAM2CS : std_logic;
SIGNAL ww_nVIASEL : std_logic;
SIGNAL ww_nSPISEL : std_logic;
SIGNAL ww_nUARTSEL : std_logic;
SIGNAL ww_nSLOTEN : std_logic;
SIGNAL ww_nSLOT1SEL : std_logic;
SIGNAL ww_nSLOT2SEL : std_logic;
SIGNAL ww_nSLOT3SEL : std_logic;
SIGNAL \ram2~1_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \ram2~1_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~1_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nROMCS~3_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRAM1CS~4_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot1~5_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot3~6_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \slot2~4_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \sloten~4_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \spi~3_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \uart~5_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pterm0_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pterm1_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pterm2_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pterm3_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pterm4_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pterm5_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pxor_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pclk_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_pena_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_paclr_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \via~3_papre_bus\ : std_logic_vector(51 DOWNTO 0);
SIGNAL \nRESET~dataout\ : std_logic;
SIGNAL \nRESET~1_dataout\ : std_logic;
SIGNAL \A19~dataout\ : std_logic;
SIGNAL \A20~dataout\ : std_logic;
SIGNAL \ram2~1_dataout\ : std_logic;
SIGNAL \A18~dataout\ : std_logic;
SIGNAL \A12~dataout\ : std_logic;
SIGNAL \A13~dataout\ : std_logic;
SIGNAL \A14~dataout\ : std_logic;
SIGNAL \A15~dataout\ : std_logic;
SIGNAL \A16~dataout\ : std_logic;
SIGNAL \A17~dataout\ : std_logic;
SIGNAL \A11~dataout\ : std_logic;
SIGNAL \nROMCS~3_dataout\ : std_logic;
SIGNAL \VDA~dataout\ : std_logic;
SIGNAL \VPA~dataout\ : std_logic;
SIGNAL \nRAM1CS~4_dataout\ : std_logic;
SIGNAL \A8~dataout\ : std_logic;
SIGNAL \A9~dataout\ : std_logic;
SIGNAL \A10~dataout\ : std_logic;
SIGNAL \slot1~5_dataout\ : std_logic;
SIGNAL \slot2~4_dataout\ : std_logic;
SIGNAL \slot3~6_dataout\ : std_logic;
SIGNAL \A4~dataout\ : std_logic;
SIGNAL \A5~dataout\ : std_logic;
SIGNAL \spi~3_dataout\ : std_logic;
SIGNAL \sloten~4_dataout\ : std_logic;
SIGNAL \via~3_dataout\ : std_logic;
SIGNAL \uart~5_dataout\ : std_logic;
SIGNAL \ALT_INV_A4~dataout\ : std_logic;
SIGNAL \ALT_INV_A5~dataout\ : std_logic;
SIGNAL \ALT_INV_A8~dataout\ : std_logic;
SIGNAL \ALT_INV_A9~dataout\ : std_logic;
SIGNAL \ALT_INV_A10~dataout\ : std_logic;
SIGNAL \ALT_INV_A11~dataout\ : std_logic;
SIGNAL \ALT_INV_A16~dataout\ : std_logic;
SIGNAL \ALT_INV_A17~dataout\ : std_logic;
SIGNAL \ALT_INV_A18~dataout\ : std_logic;
SIGNAL \ALT_INV_A19~dataout\ : std_logic;
SIGNAL \ALT_INV_A20~dataout\ : std_logic;
SIGNAL \ALT_INV_nRESET~dataout\ : std_logic;

BEGIN

ww_A4 <= A4;
ww_A5 <= A5;
ww_A8 <= A8;
ww_A9 <= A9;
ww_A10 <= A10;
ww_A11 <= A11;
ww_A12 <= A12;
ww_A13 <= A13;
ww_A14 <= A14;
ww_A15 <= A15;
ww_A16 <= A16;
ww_A17 <= A17;
ww_A18 <= A18;
ww_A19 <= A19;
ww_A20 <= A20;
ww_VDA <= VDA;
ww_VPA <= VPA;
ww_nRESET <= nRESET;
RESET <= ww_RESET;
nROMCS <= ww_nROMCS;
nRAM1CS <= ww_nRAM1CS;
nRAM2CS <= ww_nRAM2CS;
nVIASEL <= ww_nVIASEL;
nSPISEL <= ww_nSPISEL;
nUARTSEL <= ww_nUARTSEL;
nSLOTEN <= ww_nSLOTEN;
nSLOT1SEL <= ww_nSLOT1SEL;
nSLOT2SEL <= ww_nSLOT2SEL;
nSLOT3SEL <= ww_nSLOT3SEL;

\ram2~1_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & NOT \A20~dataout\ & \A19~dataout\);

\ram2~1_pterm2_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\ram2~1_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\ram2~1_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & NOT \nRESET~dataout\);

\nRESET~1_pterm2_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\nRESET~1_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRESET~1_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & NOT \A19~dataout\ & NOT \A18~dataout\ & \A20~dataout\);

\nROMCS~3_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & \A11~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\);

\nROMCS~3_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\nROMCS~3_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nROMCS~3_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRAM1CS~4_pterm0_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \A20~dataout\);

\nRAM1CS~4_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & \A11~dataout\ & NOT \A18~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\);

\nRAM1CS~4_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & \VDA~dataout\ & NOT \A18~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\);

\nRAM1CS~4_pterm3_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & \VPA~dataout\ & NOT \A18~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\);

\nRAM1CS~4_pterm4_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \A19~dataout\);

\nRAM1CS~4_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRAM1CS~4_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRAM1CS~4_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRAM1CS~4_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\nRAM1CS~4_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\nRAM1CS~4_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
\VDA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & \A8~dataout\);

\slot1~5_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
\VPA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & \A8~dataout\);

\slot1~5_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\slot1~5_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot1~5_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
\VDA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \A9~dataout\ & \A8~dataout\);

\slot3~6_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
\VPA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \A9~dataout\ & \A8~dataout\);

\slot3~6_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\slot3~6_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot3~6_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
\VDA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \A9~dataout\ & NOT \A8~dataout\);

\slot2~4_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
\VPA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \A9~dataout\ & NOT \A8~dataout\);

\slot2~4_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\slot2~4_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\slot2~4_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\sloten~4_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\sloten~4_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \A8~dataout\ & \VDA~dataout\);

\sloten~4_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & \VPA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \A8~dataout\);

\sloten~4_pterm3_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & \A9~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & \VDA~dataout\);

\sloten~4_pterm4_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & \A9~dataout\ & \VPA~dataout\ & NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\);

\sloten~4_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\sloten~4_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\sloten~4_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\sloten~4_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\sloten~4_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\sloten~4_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \VDA~dataout\ & 
NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & NOT \A8~dataout\ & NOT 
\A5~dataout\ & \A4~dataout\);

\spi~3_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \VPA~dataout\ & 
NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & NOT \A8~dataout\ & NOT 
\A5~dataout\ & \A4~dataout\);

\spi~3_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\spi~3_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\spi~3_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \VDA~dataout\
& NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & NOT \A8~dataout\ & NOT 
\A4~dataout\ & \A5~dataout\);

\uart~5_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \VPA~dataout\
& NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & NOT \A8~dataout\ & NOT 
\A4~dataout\ & \A5~dataout\);

\uart~5_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc
& vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\uart~5_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\uart~5_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pterm0_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pterm1_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \VDA~dataout\ & 
NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & NOT \A8~dataout\ & NOT 
\A4~dataout\ & NOT \A5~dataout\);

\via~3_pterm2_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & \VPA~dataout\ & 
NOT \A11~dataout\ & NOT \A19~dataout\ & NOT \A18~dataout\ & NOT \A20~dataout\ & NOT \A17~dataout\ & NOT \A16~dataout\ & \A15~dataout\ & \A14~dataout\ & \A13~dataout\ & \A12~dataout\ & NOT \A10~dataout\ & NOT \A9~dataout\ & NOT \A8~dataout\ & NOT 
\A4~dataout\ & NOT \A5~dataout\);

\via~3_pterm3_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pterm4_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pterm5_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pxor_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pclk_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & 
gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_pena_bus\ <= (vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & 
vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc & vcc);

\via~3_paclr_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);

\via~3_papre_bus\ <= (gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd
& gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd & gnd);
\ALT_INV_A4~dataout\ <= NOT \A4~dataout\;
\ALT_INV_A5~dataout\ <= NOT \A5~dataout\;
\ALT_INV_A8~dataout\ <= NOT \A8~dataout\;
\ALT_INV_A9~dataout\ <= NOT \A9~dataout\;
\ALT_INV_A10~dataout\ <= NOT \A10~dataout\;
\ALT_INV_A11~dataout\ <= NOT \A11~dataout\;
\ALT_INV_A16~dataout\ <= NOT \A16~dataout\;
\ALT_INV_A17~dataout\ <= NOT \A17~dataout\;
\ALT_INV_A18~dataout\ <= NOT \A18~dataout\;
\ALT_INV_A19~dataout\ <= NOT \A19~dataout\;
\ALT_INV_A20~dataout\ <= NOT \A20~dataout\;
\ALT_INV_nRESET~dataout\ <= NOT \nRESET~dataout\;

-- Location: PIN_17
\nRESET~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_nRESET,
	dataout => \nRESET~dataout\);

-- Location: LC17
\nRESET~1\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "normal",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \nRESET~1_pterm0_bus\,
	pterm1 => \nRESET~1_pterm1_bus\,
	pterm2 => \nRESET~1_pterm2_bus\,
	pterm3 => \nRESET~1_pterm3_bus\,
	pterm4 => \nRESET~1_pterm4_bus\,
	pterm5 => \nRESET~1_pterm5_bus\,
	pxor => \nRESET~1_pxor_bus\,
	pclk => \nRESET~1_pclk_bus\,
	papre => \nRESET~1_papre_bus\,
	paclr => \nRESET~1_paclr_bus\,
	pena => \nRESET~1_pena_bus\,
	dataout => \nRESET~1_dataout\);

-- Location: PIN_37
\A19~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A19,
	dataout => \A19~dataout\);

-- Location: PIN_27
\A20~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A20,
	dataout => \A20~dataout\);

-- Location: LC19
\ram2~1\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \ram2~1_pterm0_bus\,
	pterm1 => \ram2~1_pterm1_bus\,
	pterm2 => \ram2~1_pterm2_bus\,
	pterm3 => \ram2~1_pterm3_bus\,
	pterm4 => \ram2~1_pterm4_bus\,
	pterm5 => \ram2~1_pterm5_bus\,
	pxor => \ram2~1_pxor_bus\,
	pclk => \ram2~1_pclk_bus\,
	papre => \ram2~1_papre_bus\,
	paclr => \ram2~1_paclr_bus\,
	pena => \ram2~1_pena_bus\,
	dataout => \ram2~1_dataout\);

-- Location: PIN_29
\A18~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A18,
	dataout => \A18~dataout\);

-- Location: PIN_40
\A12~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A12,
	dataout => \A12~dataout\);

-- Location: PIN_25
\A13~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A13,
	dataout => \A13~dataout\);

-- Location: PIN_34
\A14~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A14,
	dataout => \A14~dataout\);

-- Location: PIN_2
\A15~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A15,
	dataout => \A15~dataout\);

-- Location: PIN_14
\A16~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A16,
	dataout => \A16~dataout\);

-- Location: PIN_28
\A17~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A17,
	dataout => \A17~dataout\);

-- Location: PIN_41
\A11~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A11,
	dataout => \A11~dataout\);

-- Location: LC20
\nROMCS~3\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \nROMCS~3_pterm0_bus\,
	pterm1 => \nROMCS~3_pterm1_bus\,
	pterm2 => \nROMCS~3_pterm2_bus\,
	pterm3 => \nROMCS~3_pterm3_bus\,
	pterm4 => \nROMCS~3_pterm4_bus\,
	pterm5 => \nROMCS~3_pterm5_bus\,
	pxor => \nROMCS~3_pxor_bus\,
	pclk => \nROMCS~3_pclk_bus\,
	papre => \nROMCS~3_papre_bus\,
	paclr => \nROMCS~3_paclr_bus\,
	pena => \nROMCS~3_pena_bus\,
	dataout => \nROMCS~3_dataout\);

-- Location: PIN_31
\VDA~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_VDA,
	dataout => \VDA~dataout\);

-- Location: PIN_16
\VPA~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_VPA,
	dataout => \VPA~dataout\);

-- Location: LC21
\nRAM1CS~4\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "normal",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \nRAM1CS~4_pterm0_bus\,
	pterm1 => \nRAM1CS~4_pterm1_bus\,
	pterm2 => \nRAM1CS~4_pterm2_bus\,
	pterm3 => \nRAM1CS~4_pterm3_bus\,
	pterm4 => \nRAM1CS~4_pterm4_bus\,
	pterm5 => \nRAM1CS~4_pterm5_bus\,
	pxor => \nRAM1CS~4_pxor_bus\,
	pclk => \nRAM1CS~4_pclk_bus\,
	papre => \nRAM1CS~4_papre_bus\,
	paclr => \nRAM1CS~4_paclr_bus\,
	pena => \nRAM1CS~4_pena_bus\,
	dataout => \nRAM1CS~4_dataout\);

-- Location: PIN_26
\A8~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A8,
	dataout => \A8~dataout\);

-- Location: PIN_1
\A9~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A9,
	dataout => \A9~dataout\);

-- Location: PIN_44
\A10~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A10,
	dataout => \A10~dataout\);

-- Location: LC1
\slot1~5\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \slot1~5_pterm0_bus\,
	pterm1 => \slot1~5_pterm1_bus\,
	pterm2 => \slot1~5_pterm2_bus\,
	pterm3 => \slot1~5_pterm3_bus\,
	pterm4 => \slot1~5_pterm4_bus\,
	pterm5 => \slot1~5_pterm5_bus\,
	pxor => \slot1~5_pxor_bus\,
	pclk => \slot1~5_pclk_bus\,
	papre => \slot1~5_papre_bus\,
	paclr => \slot1~5_paclr_bus\,
	pena => \slot1~5_pena_bus\,
	dataout => \slot1~5_dataout\);

-- Location: LC11
\slot2~4\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \slot2~4_pterm0_bus\,
	pterm1 => \slot2~4_pterm1_bus\,
	pterm2 => \slot2~4_pterm2_bus\,
	pterm3 => \slot2~4_pterm3_bus\,
	pterm4 => \slot2~4_pterm4_bus\,
	pterm5 => \slot2~4_pterm5_bus\,
	pxor => \slot2~4_pxor_bus\,
	pclk => \slot2~4_pclk_bus\,
	papre => \slot2~4_papre_bus\,
	paclr => \slot2~4_paclr_bus\,
	pena => \slot2~4_pena_bus\,
	dataout => \slot2~4_dataout\);

-- Location: LC14
\slot3~6\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \slot3~6_pterm0_bus\,
	pterm1 => \slot3~6_pterm1_bus\,
	pterm2 => \slot3~6_pterm2_bus\,
	pterm3 => \slot3~6_pterm3_bus\,
	pterm4 => \slot3~6_pterm4_bus\,
	pterm5 => \slot3~6_pterm5_bus\,
	pxor => \slot3~6_pxor_bus\,
	pclk => \slot3~6_pclk_bus\,
	papre => \slot3~6_papre_bus\,
	paclr => \slot3~6_paclr_bus\,
	pena => \slot3~6_pena_bus\,
	dataout => \slot3~6_dataout\);

-- Location: PIN_39
\A4~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A4,
	dataout => \A4~dataout\);

-- Location: PIN_36
\A5~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "input",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	oe => GND,
	padio => ww_A5,
	dataout => \A5~dataout\);

-- Location: LC16
\spi~3\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \spi~3_pterm0_bus\,
	pterm1 => \spi~3_pterm1_bus\,
	pterm2 => \spi~3_pterm2_bus\,
	pterm3 => \spi~3_pterm3_bus\,
	pterm4 => \spi~3_pterm4_bus\,
	pterm5 => \spi~3_pterm5_bus\,
	pxor => \spi~3_pxor_bus\,
	pclk => \spi~3_pclk_bus\,
	papre => \spi~3_papre_bus\,
	paclr => \spi~3_paclr_bus\,
	pena => \spi~3_pena_bus\,
	dataout => \spi~3_dataout\);

-- Location: LC3
\sloten~4\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \sloten~4_pterm0_bus\,
	pterm1 => \sloten~4_pterm1_bus\,
	pterm2 => \sloten~4_pterm2_bus\,
	pterm3 => \sloten~4_pterm3_bus\,
	pterm4 => \sloten~4_pterm4_bus\,
	pterm5 => \sloten~4_pterm5_bus\,
	pxor => \sloten~4_pxor_bus\,
	pclk => \sloten~4_pclk_bus\,
	papre => \sloten~4_papre_bus\,
	paclr => \sloten~4_paclr_bus\,
	pena => \sloten~4_pena_bus\,
	dataout => \sloten~4_dataout\);

-- Location: LC5
\via~3\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \via~3_pterm0_bus\,
	pterm1 => \via~3_pterm1_bus\,
	pterm2 => \via~3_pterm2_bus\,
	pterm3 => \via~3_pterm3_bus\,
	pterm4 => \via~3_pterm4_bus\,
	pterm5 => \via~3_pterm5_bus\,
	pxor => \via~3_pxor_bus\,
	pclk => \via~3_pclk_bus\,
	papre => \via~3_papre_bus\,
	paclr => \via~3_paclr_bus\,
	pena => \via~3_pena_bus\,
	dataout => \via~3_dataout\);

-- Location: LC4
\uart~5\ : max_mcell
-- pragma translate_off
GENERIC MAP (
	operation_mode => "invert",
	output_mode => "comb",
	pexp_mode => "off")
-- pragma translate_on
PORT MAP (
	pterm0 => \uart~5_pterm0_bus\,
	pterm1 => \uart~5_pterm1_bus\,
	pterm2 => \uart~5_pterm2_bus\,
	pterm3 => \uart~5_pterm3_bus\,
	pterm4 => \uart~5_pterm4_bus\,
	pterm5 => \uart~5_pterm5_bus\,
	pxor => \uart~5_pxor_bus\,
	pclk => \uart~5_pclk_bus\,
	papre => \uart~5_papre_bus\,
	paclr => \uart~5_paclr_bus\,
	pena => \uart~5_pena_bus\,
	dataout => \uart~5_dataout\);

-- Location: PIN_21
\RESET~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \nRESET~1_dataout\,
	oe => VCC,
	padio => ww_RESET);

-- Location: PIN_20
\nRAM2CS~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \ram2~1_dataout\,
	oe => VCC,
	padio => ww_nRAM2CS);

-- Location: PIN_19
\nROMCS~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \nROMCS~3_dataout\,
	oe => VCC,
	padio => ww_nROMCS);

-- Location: PIN_18
\nRAM1CS~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \nRAM1CS~4_dataout\,
	oe => VCC,
	padio => ww_nRAM1CS);

-- Location: PIN_12
\nSLOT1SEL~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \slot1~5_dataout\,
	oe => VCC,
	padio => ww_nSLOT1SEL);

-- Location: PIN_6
\nSLOT2SEL~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \slot2~4_dataout\,
	oe => VCC,
	padio => ww_nSLOT2SEL);

-- Location: PIN_5
\nSLOT3SEL~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \slot3~6_dataout\,
	oe => VCC,
	padio => ww_nSLOT3SEL);

-- Location: PIN_4
\nSPISEL~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \spi~3_dataout\,
	oe => VCC,
	padio => ww_nSPISEL);

-- Location: PIN_11
\nSLOTEN~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \sloten~4_dataout\,
	oe => VCC,
	padio => ww_nSLOTEN);

-- Location: PIN_8
\nVIASEL~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \via~3_dataout\,
	oe => VCC,
	padio => ww_nVIASEL);

-- Location: PIN_9
\nUARTSEL~I\ : max_io
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	operation_mode => "output",
	weak_pull_up => "false")
-- pragma translate_on
PORT MAP (
	datain => \uart~5_dataout\,
	oe => VCC,
	padio => ww_nUARTSEL);
END structure;


