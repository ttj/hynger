#include "__cf_Autotrans_shift_breach.h"
#ifndef RTW_HEADER_Autotrans_shift_breach_acc_private_h_
#define RTW_HEADER_Autotrans_shift_breach_acc_private_h_
#include "rtwtypes.h"
#include "multiword_types.h"
#if !defined(ss_VALIDATE_MEMORY)
#define ss_VALIDATE_MEMORY(S, ptr)   if(!(ptr)) {\
  ssSetErrorStatus(S, RT_MEMORY_ALLOCATION_ERROR);\
  }
#endif
#if !defined(rt_FREE)
#if !defined(_WIN32)
#define rt_FREE(ptr)   if((ptr) != (NULL)) {\
  free((ptr));\
  (ptr) = (NULL);\
  }
#else
#define rt_FREE(ptr)   if((ptr) != (NULL)) {\
  free((void *)(ptr));\
  (ptr) = (NULL);\
  }
#endif
#endif
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#endif
void gixsqetl0k ( SimStruct * const S ) ; void k2uck2t2gv ( SimStruct * const
S ) ; void ch34zigaue ( SimStruct * const S ) ; extern boolean_T
ch34zigaueFNI ( SimStruct * const S , int_T controlPortIdx , int_T tid ) ;
#endif
