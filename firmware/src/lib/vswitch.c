#define _FunctionAttr
#define _TableAttr
#define _SetReturnAddress __set_return_address

// **********************************************************************
//
// 6502
//
// **********************************************************************

#ifdef __CALYPSI_TARGET_6502__
#include <calypsi/intrinsics6502.h>

#if defined(__CALYPSI_TARGET_SYSTEM_MEGA65__) && defined(__CALYPSI_CODE_MODEL_BANKED__)
#undef _TableAttr
#define _TableAttr __far
#endif

#if defined(__CALYPSI_CODE_MODEL_BANKED__)
#undef _FunctionAttr
#define _FunctionAttr __non_banked
#endif

#undef _SetReturnAddress
#define _SetReturnAddress __set_return_address_low16

#define _LabTypeDefined
typedef __return_address16_t _LabType;

#define _TableTypeDefined
typedef void _TableAttr * __table_type;
#endif // __CALYPSI_TARGET_6502__

// **********************************************************************
//
// 6809
//
// **********************************************************************

#ifdef __CALYPSI_TARGET_6809__
#include <calypsi/intrinsics6809.h>

#if defined(__CALYPSI_CODE_MODEL_BANKED__)
#undef _FunctionAttr
#define _FunctionAttr __non_banked
#endif

#undef _SetReturnAddress
#define _SetReturnAddress __set_return_address_low16

#define _LabTypeDefined
typedef __return_address16_t _LabType;

#define _TableTypeDefined
typedef void _TableAttr * __table_type;
#endif // __CALYPSI_TARGET_6809__

// **********************************************************************
//
// MSP430
//
// **********************************************************************

#ifdef __CALYPSI_TARGET_MSP430__
#include <calypsi/intrinsicsMSP430.h>
#endif // __CALYPSI_TARGET_MSP430__

// **********************************************************************
//
// PDP-11
//
// **********************************************************************

#ifdef __CALYPSI_TARGET_PDP_11__
#include <calypsi/intrinsicsPDP-11.h>
#endif // __CALYPSI_TARGET_PDP_11__

// **********************************************************************
//
// 65816
//
// **********************************************************************

#ifdef __CALYPSI_TARGET_65816__
#include <calypsi/intrinsics65816.h>

#if !defined(__CALYPSI_DATA_MODEL_SMALL__) || !defined(__CALYPSI_CODE_MODEL_SMALL__)
#undef _TableAttr
#define _TableAttr __far
#endif

#undef _SetReturnAddress
#define _SetReturnAddress __set_return_address_low16

#define _LabTypeDefined
typedef __return_address16_t _LabType;

#define _TableTypeDefined
typedef void _TableAttr * __table_type;

#endif // __CALYPSI_TARGET_65816__

// **********************************************************************
//
// 68000
//
// **********************************************************************

#ifdef __CALYPSI_TARGET_68000__
#include <calypsi/intrinsics68000.h>
#endif // __CALYPSI_TARGET_68000__


// **********************************************************************
//
// Common defintions.
//
// **********************************************************************

#include <stdint.h>

#ifndef _ValueType
#define _ValueType unsigned short
#define _CountType unsigned short
#define _Size 16
#endif

#ifndef _LabTypeDefined
typedef void (*_LabType)();
#endif

#ifndef _TableTypeDefined
typedef void (*__table_type)();
#endif

#define _Suffix2(a, b) a ## b
#define _Suffix(a, b) _Suffix2(a, b)

struct _SwitchTableEntry {
  _ValueType value;
  _LabType lab;
};

struct _SwitchTable {
  _CountType   max;
  _LabType defaultDestination;
  struct _SwitchTableEntry entry[];
};

_FunctionAttr
void _Suffix(_ValueSwitch, _Size) (_ValueType value, __table_type vtable) {
  struct _SwitchTable _TableAttr *table = (struct _SwitchTable _TableAttr *) vtable;
  _CountType left = 0;
  _CountType right = table->max;

  while (1) {
    _CountType mid = (left + right) >> 1;
    struct _SwitchTableEntry _TableAttr *p =  &table->entry[mid];
    _ValueType elt = p->value;

    if (elt == value) {
      _SetReturnAddress(p->lab);
      return;
    }

    if (left == right) {
      break;
    }

    if (value < elt) {
      if (mid == 0) {
        break;
      }
      right = mid - 1;
    } else {
      int left1 = mid + 1;
      if (left1 == left) {
        left = mid;
      } else {
        left = left1;
      }
    }
  }
  // Use default label
  _SetReturnAddress(table->defaultDestination);
}
