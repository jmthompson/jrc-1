;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Keyboard key codes                                                ;
;                                                                   ;
; Codes < $80 are ASCII-equivalent and can generally be used as-is. ;
; Codes >= $80 are special keys (Fn keys, shift/ctrl/alt, etc)      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

KEY_BREAK      = $00
KEY_BACKSPACE  = $08
KEY_TAB        = $09
KEY_ENTER      = $0D
KEY_ESC        = $1B
KEY_SPACE      = $20

KEY_APOSTROPHE = $27
KEY_COMMA      = $2C
KEY_MINUS      = $2D
KEY_PERIOD     = $2E
KEY_DIV        = $2F

KEY_0          = $30
KEY_1          = $31
KEY_2          = $32
KEY_3          = $33
KEY_4          = $34
KEY_5          = $35
KEY_6          = $36
KEY_7          = $37
KEY_8          = $38
KEY_9          = $39

KEY_SEMICOLON  = $3B
KEY_EQUALS     = $3D

KEY_L_BRACKET  = $5B
KEY_BACKSLASH  = $5C
KEY_R_BRACKET  = $5D
KEY_BACKTICK   = $60

KEY_A          = $61
KEY_B          = $62
KEY_C          = $63
KEY_D          = $64
KEY_E          = $65
KEY_F          = $66
KEY_G          = $67
KEY_H          = $68
KEY_I          = $69
KEY_J          = $6A
KEY_K          = $6B
KEY_L          = $6C
KEY_M          = $6D
KEY_N          = $6E
KEY_O          = $6F
KEY_P          = $70
KEY_Q          = $71
KEY_R          = $72
KEY_S          = $73
KEY_T          = $74
KEY_U          = $75
KEY_V          = $76
KEY_W          = $77
KEY_X          = $78
KEY_Y          = $79
KEY_Z          = $7A

;;
; Non-ASCII keys
;

; Cursor keys
KEY_HOME        = $81
KEY_END         = $82
KEY_INSERT      = $83
KEY_DELETE      = $84
KEY_PAGE_DOWN   = $85
KEY_PAGE_UP     = $86
KEY_LEFT_ARROW  = $87
KEY_RIGHT_ARROW = $88
KEY_UP_ARROW    = $89
KEY_DOWN_ARROW  = $8A

; Misc
KEY_MENU        = $8B
KEY_PRTSCR      = $8C
KEY_PAUSE       = $8D
KEY_L_GUI       = $8E
KEY_R_GUI       = $8F

; Keypad keys
KEY_KP0        = $90
KEY_KP1        = $91
KEY_KP2        = $92
KEY_KP3        = $93
KEY_KP4        = $94
KEY_KP5        = $95
KEY_KP6        = $96
KEY_KP7        = $97
KEY_KP8        = $98
KEY_KP9        = $99
KEY_KP_COMMA   = $9A
KEY_KP_DIV     = $9B
KEY_KP_ENTER   = $9C
KEY_KP_EQUALS  = $9D
KEY_KP_MINUS   = $9E
KEY_KP_PERIOD  = $9F
KEY_KP_PLUS    = $A0
KEY_KP_TIMES   = $A1

; Language keys
KEY_LANG1      = $A2
KEY_LANG2      = $A3
KEY_LANG3      = $A4
KEY_LANG4      = $A5
KEY_LANG5      = $A6
KEY_SYSRQ      = $A7

; ACPI
KEY_POWER      = $A8
KEY_SLEEP      = $A9
KEY_WAKE       = $AA

; Multimedia keys
KEY_MEDIA        = $AB
KEY_PLAY         = $AC
KEY_STOP         = $AD
KEY_NEXT_TRACK   = $AE
KEY_PREV_TRACK   = $AF
KEY_VOL_DOWN     = $B0
KEY_VOL_UP       = $B1
KEY_MUTE         = $B2
KEY_CALC         = $B3
KEY_COMPUTER     = $B4
KEY_EMAIL        = $B5
KEY_WEB_BACK     = $B6
KEY_WEB_FAVOR    = $B7
KEY_WEB_FORWARD  = $B8
KEY_WEB_HOME     = $B9
KEY_WEB_REFRESH  = $BA
KEY_WEB_SEARCH   = $BB
KEY_WEB_STOP     = $BC

; International keys
KEY_INTL1   = $BD
KEY_INTL2   = $BE
KEY_INTL3   = $BF
KEY_INTL4   = $C0
KEY_INTL5   = $C1
KEY_EUROPE2 = $C2

; Modifiers and toggles
KEY_L_ALT   = $C3
KEY_R_ALT   = $C4
KEY_L_CTRL  = $C5
KEY_R_CTRL  = $C6
KEY_L_SHIFT = $C7
KEY_R_SHIFT = $C8
KEY_CAPS    = $C9
KEY_NUM     = $CA
KEY_SCROLL  = $CB

; Game pad keys

KEY_GAME1_B1 = $D0
KEY_GAME1_B2 = $D1
KEY_GAME1_B3 = $D2
KEY_GAME1_B4 = $D3
KEY_GAME1_B5 = $D4
KEY_GAME1_B6 = $D5
KEY_GAME1_B7 = $D6
KEY_GAME1_B8 = $D7
KEY_GAME2_B1 = $D8
KEY_GAME2_B2 = $D9
KEY_GAME2_B3 = $DA
KEY_GAME2_B4 = $DB
KEY_GAME2_B5 = $DC
KEY_GAME2_B6 = $DD
KEY_GAME2_B7 = $DE
KEY_GAME2_B8 = $DF

; Fn keys
KEY_F1  = $E0
KEY_F2  = $E1
KEY_F3  = $E2
KEY_F4  = $E3
KEY_F5  = $E4
KEY_F6  = $E5
KEY_F7  = $E6
KEY_F8  = $E7
KEY_F9  = $E8
KEY_F10 = $E9
KEY_F11 = $EA
KEY_F12 = $EB
KEY_F13 = $EC
KEY_F14 = $ED
KEY_F15 = $EE
KEY_F16 = $EF
KEY_F17 = $F0
KEY_F18 = $F1
KEY_F19 = $F2
KEY_F20 = $F3
KEY_F21 = $F4
KEY_F22 = $F5
KEY_F23 = $F6
KEY_F24 = $F7

; Prefix bytes
KEY_PFX_KEYUP = $F8
KEY_PFX_MOUSE = $F9
