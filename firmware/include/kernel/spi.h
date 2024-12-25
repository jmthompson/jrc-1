__attribute__((simple_call)) extern void spi_select(unsigned int);
__attribute__((simple_call)) extern void spi_select_sdc(void);
__attribute__((simple_call)) extern void spi_deselect(void);
__attribute__((simple_call)) extern void spi_slow_speed(void);
__attribute__((simple_call)) extern void spi_fast_speed(void);

__attribute__((simple_call)) extern unsigned char spi_transfer(unsigned char);
