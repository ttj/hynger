#ifndef __c1_Autotrans_shift_h__
#define __c1_Autotrans_shift_h__

/* Include files */
#include "sf_runtime/sfc_sf.h"
#include "sf_runtime/sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc1_Autotrans_shiftInstanceStruct
#define typedef_SFc1_Autotrans_shiftInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c1_sfEvent;
  uint8_T c1_tp_downshifting;
  uint8_T c1_tp_gear_state;
  uint8_T c1_tp_fourth;
  uint8_T c1_tp_second;
  uint8_T c1_tp_third;
  uint8_T c1_tp_first;
  uint8_T c1_tp_selection_state;
  uint8_T c1_tp_upshifting;
  uint8_T c1_tp_steady_state;
  boolean_T c1_isStable;
  uint8_T c1_is_active_c1_Autotrans_shift;
  uint8_T c1_is_gear_state;
  uint8_T c1_is_active_gear_state;
  uint8_T c1_is_selection_state;
  uint8_T c1_is_active_selection_state;
  real_T c1_TWAIT;
  uint32_T c1_temporalCounter_i1;
  uint8_T c1_doSetSimStateSideEffects;
  const mxArray *c1_setSimStateSideEffectsInfo;
} SFc1_Autotrans_shiftInstanceStruct;

#endif                                 /*typedef_SFc1_Autotrans_shiftInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c1_Autotrans_shift_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c1_Autotrans_shift_get_check_sum(mxArray *plhs[]);
extern void c1_Autotrans_shift_method_dispatcher(SimStruct *S, int_T method,
  void *data);

#endif
