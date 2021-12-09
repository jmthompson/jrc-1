`timescale 1ns / 1ps

/**
 * JIGL
 * JRC Integrated Glue Logic
 *
 * This device bank address capture and device selection lgoic
 */

module jigl (
	 input wire A4,
	 input wire A5,
    input wire A8,
    input wire A9,
    input wire A10,
    input wire A11,
    input wire A12,
    input wire A13,
    input wire A14,
    input wire A15,
    input wire A16,
    input wire A17,
    input wire A18,
    input wire A19,
    input wire A20,
    input wire VDA,
    input wire VPA,
	 input wire nRESET,
    output wire RESET,
    output wire nROMCS,
    output wire nRAM1CS,
    output wire nRAM2CS,
    output wire nVIASEL,
    output wire nSPISEL,
    output wire nUARTSEL,
    output wire nSLOTEN,
    output wire nSLOT1SEL,
    output wire nSLOT2SEL,
    output wire nSLOT3SEL
);

// True if current acess is in bank 0
wire bank0 = ~A20 && ~A19 && ~A18 && ~A17 && ~A16;

// True if current acess is the LOWROM area ($00/F800 - $FFFF)
wire lowrom = bank0 && A15 && A14 && A13 && A12 && A11;

// True if the current acess is in HIGHROM ($10/0000 - $13/FFFF)
wire highrom = A20 && ~A19 && ~A18;

// True if current acess is in RAM
wire ram    = ~A20;
wire ram1 = ram && ~A19;
wire ram2 = ram && A19;

// True for accesses in the $00/F000 - $F7FF range
wire io = bank0 && A15 && A14 && A13 && A12 && ~A11 && (VDA || VPA);

// Internal I/O devices
wire intio = io && ~A10 && ~A9 && ~A8;
wire via   = intio && ~A5 && ~A4;
wire spi   = intio && ~A5 && A4;
wire uart  = intio && A5 && ~A4;

// Slots
wire slot1 = io && ~A10 && ~A9 && A8;
wire slot2 = io && ~A10 && A9 && ~A8;
wire slot3 = io && ~A10 && A9 && A8;
wire sloten = slot1 || slot2 || slot3;

// Assign active low output signals
assign RESET = ~nRESET;
assign nROMCS = ~(lowrom || highrom);
assign nRAM1CS = ~(ram1 && ~io && ~lowrom);
assign nRAM2CS = ~ram2;
assign nVIASEL = ~via;
assign nSPISEL = ~spi;
assign nUARTSEL = ~uart;
assign nSLOTEN = ~sloten;
assign nSLOT1SEL = ~slot1;
assign nSLOT2SEL = ~slot2;
assign nSLOT3SEL = ~slot3;

endmodule
