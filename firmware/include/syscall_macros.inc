;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Syscall handler macros. These assist in setting up the handler environment   ;
; such as defining call parameters.                                            ;
;                                                                              ;
; Syscalls must be defined as follows:                                         ;
;                                                                              ;
; .proc syscall_name                                                           ;
;   BEGIN_PARAMS                                                               ;
;     PARAM i_first_arg, .word                                                 ;
;     PARAM i_second_arg, .word                                                ;
;     PARAM o_ret_value, .dword                                                ;
;   END_PARAMS                                                                 ;
;                                                                              ;
;   ... code here ...                                                          ;
;                                                                              ;
;   rtl                                                                        ;
; .endproc                                                                     ;
;                                                                              ;
; This syscall woudl be called like this:                                      ;
;                                                                              ;
;   pha                                                                        ;
;   pha       ; space for dword return value                                   ;
;   pea first_arg                                                              ;
;   pea second_parg                                                            ;
;   cop $xx                                                                    ;
;   pla                                                                        ;
;   sta result                                                                 ;
;   pla                                                                        ;
;   sta result + 2                                                             ;
;                                                                              ;
; The use of .proc to define the function makes sure that the names of the     ;
; parameters will not conflict with other, similarly-named parameters in other ;
; functions in the same source file.                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
; Begin defining the input/output parameters for a syscall
;
.macro  BEGIN_PARAMS
.struct
  .byte
.endmacro

;;
; Declare a single parameter with name "name" and type "type". The type must include
; the leading dot, e.g ".word", ".dword".
;
.macro PARAM name,type
  name type
.endmacro

;;
; Signal the end of parameter definitions
;
.macro END_PARAMS
.endstruct
.endmacro

;;
; Exit with a success code (0)
;
.macro SUCCESS
        ldaw    #0
        rtl
.endmacro

;;
; Exit a syscall with an error code.
;
.macro  ERROR code
.ifnblank code
        ldaw    #code
.endif
        sec
        rtl
.endmacro
