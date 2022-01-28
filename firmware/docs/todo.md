TODO
====

This is just a scratch space for me to write down things that need
fixed or updated.

- Make BRK handler jump through a RAM vector that we default to being monitor_brk
- Make NMI handler jump through a RAM vector that we default to being monitor_nmi
- Add a user-settable vector for via_irq (or maybe one per interrupt source)
