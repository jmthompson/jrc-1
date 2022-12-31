.scope Monitor

        .export COLON_EXPECTED
        .export INVALID_OPERAND
        .export UNKNOWN_COMMAND
        .export UNKNOWN_OPCODE
        .export UNKNOWN_REGISTER

        .segment "OSROM"

COLON_EXPECTED:
        .byte "':' expected", 0
INVALID_OPERAND:
        .byte "Invalid operand", 0
UNKNOWN_COMMAND:
        .byte "Unknown command", 0
UNKNOWN_OPCODE:
        .byte "Unknown opcode", 0
UNKNOWN_REGISTER:
        .byte "Unknown register", 0

.endscope
