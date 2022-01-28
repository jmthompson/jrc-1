Block Device Commands
=====================

[I] = input parameter
[O] = output parameter

* INIT ($01)

no command block

* STATUS ($02)

    0 : [O] status, 1 = online, 0 = offline
  1-4 : [O] unit size in blocks
 5-31 : [O] unit name, null-terminated

* MOUNT ($03)

no command block

* EJECT ($04)

no command block

* FORMAT ($05)

no command block

* READ_BLOCK ($06)

0-4 : [I] block number 
5-8 : [I] block buffer pointer

* WRITE_BLOCK ($07)

0-4 : [I] block number 
5-8 : [I] block buffer pointer
