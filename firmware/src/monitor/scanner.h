#pragma once

typedef struct token {
    enum {
        TK_UNKNOWN = -1,
        TK_EOL = 0,       // end of string
        TK_CHAR,          // single character
        TK_STRING,        // delimited string
        TK_CONST          // hex constant
    } type;

    const char *pos;      // start of token
    unsigned int len;     // length of token

    union {
        int char_value;
        long const_value;
        char *str_value;
    };
};

extern char *read_line();
