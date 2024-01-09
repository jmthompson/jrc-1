.scope          Monitor

                .global         COLON_EXPECTED
                .global         INVALID_OPERAND
                .global         UNKNOWN_COMMAND
                .global         UNKNOWN_OPCODE
                .global         UNKNOWN_REGISTER

                .section        "OSROM"

COLON_EXPECTED:
                .byte           "':' expected", 0
INVALID_OPERAND:
                .byte           "Invalid operand", 0
UNKNOWN_COMMAND:
                .byte           "Unknown command", 0
UNKNOWN_OPCODE:
                .byte           "Unknown opcode", 0
UNKNOWN_REGISTER:
                .byte           "Unknown register", 0

.endscope
