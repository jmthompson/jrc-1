JRC-1 Memory Map
================

|--------------------------------| $00/0000
|         Base RAM (60K)         |
|--------------------------------| $00/F000
|         I/O Area (2K)          |
|--------------------------------| $00/F800
|         Boot ROM (2K)          |
|--------------------------------| $01/0000
|      Extended RAM (944K)       |
|--------------------------------| $0F/C000
|        Video RAM (16K)         |
|--------------------------------| $10/0000
|       System ROM (256K)        |
|--------------------------------| $14/0000

Due to the way the hardware maps the ROM into the processor address space, the
boot ROM area from $00/F800-FFFF also appears at $10/F800-FFFF. This is where
the code "really" lives in the EEPROM image.

The space in banks $14-$1F are dead space, and will usually just read back as
containing the bank number byte at all locations. At bank $20 and beyond the
memory map just repeats, as A21-A23 are not decoded by the hardware.

* Bank 0

$0000 - $CFFF : [ unused, available for application use ]
$D000 - $E6FF : System buffers
$E700 - $E7FF : System direct page
$E800 - $EFFF : System stack
$F000 - $F7FF : I/O (see table below)
$F800 - $FFFF : Boot ROM (boot/interrupt vectors, I/O drivers)

The I/O is divided into eight 256-byte pages. For each page $FnXX the
value n corresponds to a slot number from 0-7. Slot 0 is for on-board
devices, 1-3 are the three slots on the board, and 4-7 are currently
reserved.

The on-board devices are assigne 16-byte I/O windows in the slot 0 space
as follows:

$F000 - $F00F : VIA
$F010 - $F01F : SPI
$F020 - $F02F : UART

All other space is reserved.
