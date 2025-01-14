#pragma once

// Make VSCode stop erroring on custom Calypsi type qualifiers
#ifdef __INTELLISENSE__
#define __tiny
#define __near
#define __far
#define __far24
#define SIMPLE_CALL extern
#else
#define SIMPLE_CALL __attribute__((simple_call))
#endif
