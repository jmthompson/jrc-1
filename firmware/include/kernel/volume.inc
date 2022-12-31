; Maximum number of mounted volumes
MAX_VOLUMES = 8

;:
; Volume structure
;
; +0 : Device ID
; +1 : Volume type
; +2 : Starting block
; +6 : Number of blocks
;
; Structure size, rounded up to power of 2
;
VOLUME_STRUCT_SIZE = 16

;;
; Supported volume types
;
VOL_TYPE_UNKNOWN = 0
VOL_TYPE_FAT16   = 1
VOL_TYPE_FAT32   = 2
