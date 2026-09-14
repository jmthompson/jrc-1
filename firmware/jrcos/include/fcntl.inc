;;
; fcntl constants. To be expanded later.
;


F_DUPFD := 0
F_GETFD := 1
F_SETFD := 2
F_GETFL := 3
F_SETFL := 4

O_NONBLOCK := 1       ; must be in lowest byte (bits 0-7)

; File descriptor modes
O_RDONLY := 1
O_WRONLY := 2
O_RDWR   := 3
