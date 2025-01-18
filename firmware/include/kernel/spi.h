#pragma once

#include <kernel/types.h>

SIMPLE_CALL void spi_select(unsigned int);
SIMPLE_CALL void spi_select_sdc(void);
SIMPLE_CALL void spi_deselect(void);
SIMPLE_CALL void spi_slow_speed(void);
SIMPLE_CALL void spi_fast_speed(void);
SIMPLE_CALL unsigned char spi_transfer(unsigned char);
