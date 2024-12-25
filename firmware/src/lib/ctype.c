#include <ctype.h>

#define _U _CTYPE_U
#define _L _CTYPE_L
#define _N _CTYPE_N
#define _S _CTYPE_S
#define _P _CTYPE_P
#define _C _CTYPE_C
#define _X _CTYPE_X
#define _B _CTYPE_B

static const char __attribute__((far)) ctypes[256] = {
  _C,   _C,     _C,     _C,     _C,     _C,     _C,     _C,
  _C, _C|_B|_S, _C|_S,  _C|_S,  _C|_S,  _C|_S,  _C,     _C,
  _C,   _C,     _C,     _C,     _C,     _C,     _C,     _C,
  _C,   _C,     _C,     _C,     _C,     _C,     _C,     _C,
  _S|_B,_P,     _P,     _P,     _P,     _P,     _P,     _P,
  _P,   _P,     _P,     _P,     _P,     _P,     _P,     _P,
  _N,   _N,     _N,     _N,     _N,     _N,     _N,     _N,
  _N,   _N,     _P,     _P,     _P,     _P,     _P,     _P,
  _P,   _U|_X,  _U|_X,  _U|_X,  _U|_X,  _U|_X,  _U|_X,  _U,
  _U,   _U,     _U,     _U,     _U,     _U,     _U,     _U,
  _U,   _U,     _U,     _U,     _U,     _U,     _U,     _U,
  _U,   _U,     _U,     _P,     _P,     _P,     _P,     _P,
  _P,   _L|_X,  _L|_X,  _L|_X,  _L|_X,  _L|_X,  _L|_X,  _L,
  _L,   _L,     _L,     _L,     _L,     _L,     _L,     _L,
  _L,   _L,     _L,     _L,     _L,     _L,     _L,     _L,
  _L,   _L,     _L,     _P,     _P,     _P,     _P,     _C,
};

int isalnum(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & (_U | _L | _N));
}

int isalpha(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & (_U | _L));
}

int iscntrl(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _C);
}

int isdigit(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _N);
}

int isgraph(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & (_P | _U | _L | _N));
}

int islower(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _L);
}

int isprint(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & (_P | _U | _L | _N | _B));
}

int ispunct(int c)
{
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _P);
}

int isspace(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _S);
}

int isupper(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _U);
}

int isxdigit(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & (_N | _X));
}

int tolower(int c) {
  if (isupper(c)) {
    return c - 'A' + 'a';
  } else {
    return c;
  }
}

int toupper(int c) {
  if (islower(c)) {
    return c - 'a' + 'A';
  } else {
    return c;
  }
}

#if __STDC_VERSION__ >= 199901L
int isblank(int c) {
  return (c == -1 ? 0 : ctypes[(unsigned char)c] & _B);
}
#endif
