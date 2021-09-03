`timescale 1ns / 1ps

/**
 * JIGL
 * JRC Integrated Glue Logic
 *
 * This device bank address capture and device selection lgoic
 */

module jigl (
    input wire A5,
    input wire A6,
    input wire A7,
    input wire A11,
    input wire A12,
    input wire A13,
    input wire A14,
    input wire A15,
    input wire [4:0] DB,
    input wire nRW,
    input wire VDA,
	 input wire VPA,
    input wire PHI2,
    input wire nRESET,
    output wire RESET,
    output wire A16,
    output wire A17,
    output wire A18,
    output wire nRD,
    output wire nWR,
	 output wire nWSEN,
    output wire nROMCS,
    output wire nRAM1CS,
    output wire nRAM2CS,
    output wire nIO1SEL,
    output wire nIO2SEL,
    output wire nIO3SEL,
    output wire nIO4SEL
);

reg [4:0] bank;
wire A19;
wire A20;

assign A16 = bank[0];
assign A17 = bank[1];
assign A18 = bank[2];
assign A19 = bank[3];
assign A20 = bank[4];

wire rd;
wire wr;
wire wsen = 1'b0;

wire bank0;
wire lowrom;
wire highrom;
wire io;
wire io1;
wire io2;
wire io3;
wire io4;
wire ram;
wire ram1;
wire ram2;

// These signals are active low
assign nRD = ~rd;
assign nWR = ~wr;
assign nWSEN = ~wsen;
assign nROMCS = ~(lowrom || highrom);
assign RnAM1CS = ~(ram1 && ~io && ~lowrom);
assign nRAM2CS = ~ram2;
assign nIO1SEL = ~io1;
assign nIO2SEL = ~io2;
assign nIO3SEL = ~io3;
assign nIO4SEL = ~io4;
assign RESET   = ~nRESET;

// rd is only active during phi2 high
assign rd = PHI2 && nRW;

// wr is only active during phi2 high, but not for rom
assign wr = PHI2 && ~nRW;

// True if current acess is in bank 0
assign bank0 = (bank == 5'b0); 

// True if current acess is the LOWROM area ($00/F800 - $FFFF)
assign lowrom = bank0 && A15 && A14 && A13 && A12 && A11;

// True if the current acess is in HIGHROM ($F8-$FF)
assign highrom = A20;

// True if current acess is in RAM
assign ram = ~A20;

// True if the current access is in RAM 1
assign ram1 = ram && ~A19;

// True if the current access is in RAM 2
assign ram2 = ram && A19;

// True if the current acess is in the I/O area ($00/F000 - $F3FF)
assign io = bank0 && A15 && A14 && A13 && A12 && ~A11 && VDA;

// True if I/O device 0 is being accessed
assign io0 = io && ~A7 && ~A6 && ~A5;

// True if I/O device 1 is being accessed
assign io1 = io && ~A7 && ~A6 && A5;

// True if I/O device 2 is being accessed
assign io2 = io && ~A7 && A6 && ~A5;

// True if I/O device 3 is being accessed
assign io3 = io && ~A7 && A6 && A5;

// True if I/O device 4 is being accessed
assign io4 = io && A7 && ~A6 && ~A5;


// Capture bank address on phi2 rising edge
always @(posedge PHI2)
begin
   if (RESET == 1'b1) begin
        bank <= 5'b0;
    end else begin
        bank <= DB;
    end
end

endmodule
