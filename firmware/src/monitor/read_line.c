#include <stddef.h>
#include <kernel/console.h>
#include <calypsi/intrinsics65816.h>

__attribute__((simple_call))
int getc_seriala(void);

__attribute__((simple_call))
void putc_seriala(char character);

size_t read_line(char *buffer, size_t buffsz)
{
    size_t count = 0;
    char *pos = buffer;

    while(count < buffsz-1) {
        int ch = getc_seriala();

        if (ch < 0) {
            __wait_for_interrupt();
        }
        else if ((ch == BS) && (count > 0)) {
          putc_seriala((char) ch);
          pos--;
          count--;
        }
        else if (ch == CR) {
            break;
        }
        else if (ch >= ' ') {
          *pos++ = (char) ch;
          putc_seriala((char) ch);
          count++;
        }
    }

    *pos = '\0';
    return count;
}
