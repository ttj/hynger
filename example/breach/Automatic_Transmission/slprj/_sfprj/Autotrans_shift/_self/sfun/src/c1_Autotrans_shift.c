/* Include files */

#include <stddef.h>
#include "blas.h"
#include "Autotrans_shift_sfun.h"
#include "c1_Autotrans_shift.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "Autotrans_shift_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define c1_event_DOWN                  (1)
#define c1_event_UP                    (2)
#define CALL_EVENT                     (-1)
#define c1_IN_NO_ACTIVE_CHILD          ((uint8_T)0U)
#define c1_IN_first                    ((uint8_T)1U)
#define c1_IN_fourth                   ((uint8_T)2U)
#define c1_IN_second                   ((uint8_T)3U)
#define c1_IN_third                    ((uint8_T)4U)
#define c1_IN_downshifting             ((uint8_T)1U)
#define c1_IN_steady_state             ((uint8_T)2U)
#define c1_IN_upshifting               ((uint8_T)3U)

/* Variable Declarations */

/* Variable Definitions */
static real_T _sfTime_;

/* Function Declarations */
static void initialize_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance);
static void initialize_params_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance);
static void enable_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance);
static void disable_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance);
static void c1_update_debugger_state_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance);
static void set_sim_state_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct *
  chartInstance, const mxArray *c1_st);
static void c1_set_sim_state_side_effects_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance);
static void finalize_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance);
static void sf_gateway_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance);
static void initSimStructsc1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct *
  chartInstance);
static void c1_gear_state(SFc1_Autotrans_shiftInstanceStruct *chartInstance);
static void c1_selection_state(SFc1_Autotrans_shiftInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c1_machineNumber, uint32_T
  c1_chartNumber, uint32_T c1_instanceNumber);
static const mxArray *c1_sf_marshallOut(void *chartInstanceVoid, void *c1_inData);
static int32_T c1_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void c1_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static const mxArray *c1_b_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData);
static uint8_T c1_b_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_b_tp_downshifting, const char_T
  *c1_identifier);
static uint8_T c1_c_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void c1_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static const mxArray *c1_c_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData);
static real_T c1_d_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_gear, const char_T *c1_identifier);
static real_T c1_e_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void c1_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData);
static uint32_T c1_f_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_b_temporalCounter_i1, const char_T
  *c1_identifier);
static uint32_T c1_g_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static const mxArray *c1_h_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_b_setSimStateSideEffectsInfo, const char_T
  *c1_identifier);
static const mxArray *c1_i_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId);
static void init_dsm_address_info(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance)
{
  real_T *c1_gear;
  c1_gear = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c1_sfEvent = CALL_EVENT;
  _sfTime_ = sf_get_time(chartInstance->S);
  chartInstance->c1_doSetSimStateSideEffects = 0U;
  chartInstance->c1_setSimStateSideEffectsInfo = NULL;
  chartInstance->c1_is_active_gear_state = 0U;
  chartInstance->c1_is_gear_state = c1_IN_NO_ACTIVE_CHILD;
  chartInstance->c1_tp_gear_state = 0U;
  chartInstance->c1_tp_first = 0U;
  chartInstance->c1_tp_fourth = 0U;
  chartInstance->c1_tp_second = 0U;
  chartInstance->c1_tp_third = 0U;
  chartInstance->c1_is_active_selection_state = 0U;
  chartInstance->c1_is_selection_state = c1_IN_NO_ACTIVE_CHILD;
  chartInstance->c1_tp_selection_state = 0U;
  chartInstance->c1_tp_downshifting = 0U;
  chartInstance->c1_temporalCounter_i1 = 0U;
  chartInstance->c1_tp_steady_state = 0U;
  chartInstance->c1_tp_upshifting = 0U;
  chartInstance->c1_temporalCounter_i1 = 0U;
  chartInstance->c1_is_active_c1_Autotrans_shift = 0U;
  if (!(sf_get_output_port_reusable(chartInstance->S, 1) != 0)) {
    *c1_gear = 0.0;
  }
}

static void initialize_params_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance)
{
  real_T c1_d0;
  sf_mex_import_named("TWAIT", sf_mex_get_sfun_param(chartInstance->S, 0, 0),
                      &c1_d0, 0, 0, 0U, 0, 0U, 0);
  chartInstance->c1_TWAIT = c1_d0;
}

static void enable_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance)
{
  _sfTime_ = sf_get_time(chartInstance->S);
  sf_call_output_fcn_enable(chartInstance->S, 0, "CALC_TH", 0);
}

static void disable_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance)
{
  _sfTime_ = sf_get_time(chartInstance->S);
  sf_call_output_fcn_disable(chartInstance->S, 0, "CALC_TH", 0);
}

static void c1_update_debugger_state_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance)
{
  uint32_T c1_prevAniVal;
  c1_prevAniVal = _SFD_GET_ANIMATION();
  _SFD_SET_ANIMATION(0U);
  _SFD_SET_HONOR_BREAKPOINTS(0U);
  if (chartInstance->c1_is_active_c1_Autotrans_shift == 1U) {
    _SFD_CC_CALL(CHART_ACTIVE_TAG, 0U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_selection_state == c1_IN_downshifting) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_active_gear_state == 1U) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 0U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_gear_state == c1_IN_fourth) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_gear_state == c1_IN_second) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_gear_state == c1_IN_third) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_gear_state == c1_IN_first) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_active_selection_state == 1U) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 5U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_selection_state == c1_IN_upshifting) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c1_sfEvent);
  }

  if (chartInstance->c1_is_selection_state == c1_IN_steady_state) {
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
  } else {
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
  }

  _SFD_SET_ANIMATION(c1_prevAniVal);
  _SFD_SET_HONOR_BREAKPOINTS(1U);
  _SFD_ANIMATE();
}

static const mxArray *get_sim_state_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance)
{
  const mxArray *c1_st;
  const mxArray *c1_y = NULL;
  real_T c1_hoistedGlobal;
  real_T c1_u;
  const mxArray *c1_b_y = NULL;
  uint8_T c1_b_hoistedGlobal;
  uint8_T c1_b_u;
  const mxArray *c1_c_y = NULL;
  uint8_T c1_c_hoistedGlobal;
  uint8_T c1_c_u;
  const mxArray *c1_d_y = NULL;
  uint8_T c1_d_hoistedGlobal;
  uint8_T c1_d_u;
  const mxArray *c1_e_y = NULL;
  uint8_T c1_e_hoistedGlobal;
  uint8_T c1_e_u;
  const mxArray *c1_f_y = NULL;
  uint8_T c1_f_hoistedGlobal;
  uint8_T c1_f_u;
  const mxArray *c1_g_y = NULL;
  uint32_T c1_g_hoistedGlobal;
  uint32_T c1_g_u;
  const mxArray *c1_h_y = NULL;
  real_T *c1_gear;
  c1_gear = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c1_st = NULL;
  c1_st = NULL;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_createcellmatrix(7, 1), false);
  c1_hoistedGlobal = *c1_gear;
  c1_u = c1_hoistedGlobal;
  c1_b_y = NULL;
  sf_mex_assign(&c1_b_y, sf_mex_create("y", &c1_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 0, c1_b_y);
  c1_b_hoistedGlobal = chartInstance->c1_is_active_c1_Autotrans_shift;
  c1_b_u = c1_b_hoistedGlobal;
  c1_c_y = NULL;
  sf_mex_assign(&c1_c_y, sf_mex_create("y", &c1_b_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 1, c1_c_y);
  c1_c_hoistedGlobal = chartInstance->c1_is_active_gear_state;
  c1_c_u = c1_c_hoistedGlobal;
  c1_d_y = NULL;
  sf_mex_assign(&c1_d_y, sf_mex_create("y", &c1_c_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 2, c1_d_y);
  c1_d_hoistedGlobal = chartInstance->c1_is_active_selection_state;
  c1_d_u = c1_d_hoistedGlobal;
  c1_e_y = NULL;
  sf_mex_assign(&c1_e_y, sf_mex_create("y", &c1_d_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 3, c1_e_y);
  c1_e_hoistedGlobal = chartInstance->c1_is_gear_state;
  c1_e_u = c1_e_hoistedGlobal;
  c1_f_y = NULL;
  sf_mex_assign(&c1_f_y, sf_mex_create("y", &c1_e_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 4, c1_f_y);
  c1_f_hoistedGlobal = chartInstance->c1_is_selection_state;
  c1_f_u = c1_f_hoistedGlobal;
  c1_g_y = NULL;
  sf_mex_assign(&c1_g_y, sf_mex_create("y", &c1_f_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 5, c1_g_y);
  c1_g_hoistedGlobal = chartInstance->c1_temporalCounter_i1;
  c1_g_u = c1_g_hoistedGlobal;
  c1_h_y = NULL;
  sf_mex_assign(&c1_h_y, sf_mex_create("y", &c1_g_u, 7, 0U, 0U, 0U, 0), false);
  sf_mex_setcell(c1_y, 6, c1_h_y);
  sf_mex_assign(&c1_st, c1_y, false);
  return c1_st;
}

static void set_sim_state_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct *
  chartInstance, const mxArray *c1_st)
{
  const mxArray *c1_u;
  real_T *c1_gear;
  c1_gear = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c1_u = sf_mex_dup(c1_st);
  *c1_gear = c1_d_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c1_u,
    0)), "gear");
  chartInstance->c1_is_active_c1_Autotrans_shift = c1_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 1)),
     "is_active_c1_Autotrans_shift");
  chartInstance->c1_is_active_gear_state = c1_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c1_u, 2)), "is_active_gear_state");
  chartInstance->c1_is_active_selection_state = c1_b_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c1_u, 3)),
     "is_active_selection_state");
  chartInstance->c1_is_gear_state = c1_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c1_u, 4)), "is_gear_state");
  chartInstance->c1_is_selection_state = c1_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c1_u, 5)), "is_selection_state");
  chartInstance->c1_temporalCounter_i1 = c1_f_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c1_u, 6)), "temporalCounter_i1");
  sf_mex_assign(&chartInstance->c1_setSimStateSideEffectsInfo,
                c1_h_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c1_u, 7)), "setSimStateSideEffectsInfo"), true);
  sf_mex_destroy(&c1_u);
  chartInstance->c1_doSetSimStateSideEffects = 1U;
  c1_update_debugger_state_c1_Autotrans_shift(chartInstance);
  sf_mex_destroy(&c1_st);
}

static void c1_set_sim_state_side_effects_c1_Autotrans_shift
  (SFc1_Autotrans_shiftInstanceStruct *chartInstance)
{
  if (chartInstance->c1_doSetSimStateSideEffects != 0) {
    if (chartInstance->c1_is_active_gear_state == 1U) {
      chartInstance->c1_tp_gear_state = 1U;
    } else {
      chartInstance->c1_tp_gear_state = 0U;
    }

    if (chartInstance->c1_is_gear_state == c1_IN_first) {
      chartInstance->c1_tp_first = 1U;
    } else {
      chartInstance->c1_tp_first = 0U;
    }

    if (chartInstance->c1_is_gear_state == c1_IN_fourth) {
      chartInstance->c1_tp_fourth = 1U;
    } else {
      chartInstance->c1_tp_fourth = 0U;
    }

    if (chartInstance->c1_is_gear_state == c1_IN_second) {
      chartInstance->c1_tp_second = 1U;
    } else {
      chartInstance->c1_tp_second = 0U;
    }

    if (chartInstance->c1_is_gear_state == c1_IN_third) {
      chartInstance->c1_tp_third = 1U;
    } else {
      chartInstance->c1_tp_third = 0U;
    }

    if (chartInstance->c1_is_active_selection_state == 1U) {
      chartInstance->c1_tp_selection_state = 1U;
    } else {
      chartInstance->c1_tp_selection_state = 0U;
    }

    if (chartInstance->c1_is_selection_state == c1_IN_downshifting) {
      chartInstance->c1_tp_downshifting = 1U;
      if (sf_mex_sub(chartInstance->c1_setSimStateSideEffectsInfo,
                     "setSimStateSideEffectsInfo", 1, 8) == 0.0) {
        chartInstance->c1_temporalCounter_i1 = 0U;
      }
    } else {
      chartInstance->c1_tp_downshifting = 0U;
    }

    if (chartInstance->c1_is_selection_state == c1_IN_steady_state) {
      chartInstance->c1_tp_steady_state = 1U;
    } else {
      chartInstance->c1_tp_steady_state = 0U;
    }

    if (chartInstance->c1_is_selection_state == c1_IN_upshifting) {
      chartInstance->c1_tp_upshifting = 1U;
      if (sf_mex_sub(chartInstance->c1_setSimStateSideEffectsInfo,
                     "setSimStateSideEffectsInfo", 1, 10) == 0.0) {
        chartInstance->c1_temporalCounter_i1 = 0U;
      }
    } else {
      chartInstance->c1_tp_upshifting = 0U;
    }

    chartInstance->c1_doSetSimStateSideEffects = 0U;
  }
}

static void finalize_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance)
{
  sf_mex_destroy(&chartInstance->c1_setSimStateSideEffectsInfo);
}

static void sf_gateway_c1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance)
{
  real_T *c1_speed;
  real_T *c1_gear;
  real_T *c1_up_th;
  real_T *c1_down_th;
  c1_down_th = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c1_up_th = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c1_gear = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c1_speed = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  c1_set_sim_state_side_effects_c1_Autotrans_shift(chartInstance);
  _SFD_SYMBOL_SCOPE_PUSH(0U, 0U);
  _sfTime_ = sf_get_time(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c1_speed, 0U);
  _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
  _SFD_DATA_RANGE_CHECK(chartInstance->c1_TWAIT, 2U);
  _SFD_DATA_RANGE_CHECK(*c1_up_th, 3U);
  _SFD_DATA_RANGE_CHECK(*c1_down_th, 4U);
  chartInstance->c1_sfEvent = CALL_EVENT;
  if (chartInstance->c1_temporalCounter_i1 < MAX_uint32_T) {
    chartInstance->c1_temporalCounter_i1++;
  }

  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
  if (chartInstance->c1_is_active_c1_Autotrans_shift == 0U) {
    _SFD_CC_CALL(CHART_ENTER_ENTRY_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
    chartInstance->c1_is_active_c1_Autotrans_shift = 1U;
    _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
    chartInstance->c1_is_active_gear_state = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 0U, chartInstance->c1_sfEvent);
    chartInstance->c1_tp_gear_state = 1U;
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
    if (chartInstance->c1_is_gear_state == c1_IN_first) {
    } else {
      chartInstance->c1_is_gear_state = c1_IN_first;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_first = 1U;
      *c1_gear = 1.0;
      _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
    }

    chartInstance->c1_is_active_selection_state = 1U;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 5U, chartInstance->c1_sfEvent);
    chartInstance->c1_tp_selection_state = 1U;
    _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
    chartInstance->c1_is_selection_state = c1_IN_steady_state;
    _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
    chartInstance->c1_tp_steady_state = 1U;
  } else {
    if (chartInstance->c1_is_active_gear_state == 0U) {
    } else {
      c1_gear_state(chartInstance);
    }

    if (chartInstance->c1_is_active_selection_state == 0U) {
    } else {
      c1_selection_state(chartInstance);
    }
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
  _SFD_SYMBOL_SCOPE_POP();
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_Autotrans_shiftMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc1_Autotrans_shift(SFc1_Autotrans_shiftInstanceStruct *
  chartInstance)
{
  (void)chartInstance;
}

static void c1_gear_state(SFc1_Autotrans_shiftInstanceStruct *chartInstance)
{
  boolean_T c1_out;
  boolean_T c1_b_out;
  boolean_T c1_c_out;
  boolean_T c1_d_out;
  boolean_T c1_e_out;
  boolean_T c1_f_out;
  boolean_T c1_g_out;
  boolean_T c1_h_out;
  real_T *c1_gear;
  c1_gear = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
  switch (chartInstance->c1_is_gear_state) {
   case c1_IN_first:
    CV_STATE_EVAL(0, 0, 1);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 2U, chartInstance->c1_sfEvent);
    c1_out = (CV_TRANSITION_EVAL(2U, (int32_T)_SFD_CCP_CALL(2U, 0,
                chartInstance->c1_sfEvent == c1_event_UP != 0U,
                chartInstance->c1_sfEvent)) != 0);
    if (c1_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 2U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_first = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_gear_state = c1_IN_second;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_second = 1U;
      *c1_gear = 2.0;
      _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
    } else {
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 1U,
                   chartInstance->c1_sfEvent);
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 1U, chartInstance->c1_sfEvent);
    break;

   case c1_IN_fourth:
    CV_STATE_EVAL(0, 0, 2);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 4U, chartInstance->c1_sfEvent);
    c1_b_out = (CV_TRANSITION_EVAL(4U, (int32_T)_SFD_CCP_CALL(4U, 0,
      chartInstance->c1_sfEvent == c1_event_DOWN != 0U,
      chartInstance->c1_sfEvent)) != 0);
    if (c1_b_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_fourth = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 2U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_gear_state = c1_IN_third;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_third = 1U;
      *c1_gear = 3.0;
      _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
    } else {
      _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 2U,
                   chartInstance->c1_sfEvent);
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c1_sfEvent);
    break;

   case c1_IN_second:
    CV_STATE_EVAL(0, 0, 3);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 1U, chartInstance->c1_sfEvent);
    c1_c_out = (CV_TRANSITION_EVAL(1U, (int32_T)_SFD_CCP_CALL(1U, 0,
      chartInstance->c1_sfEvent == c1_event_UP != 0U, chartInstance->c1_sfEvent))
                != 0);
    if (c1_c_out) {
      if (_SFD_TRANSITION_CONFLICT_CHECK_ENABLED()) {
        unsigned int transitionList[2];
        unsigned int numTransitions = 1;
        transitionList[0] = 1;
        _SFD_TRANSITION_CONFLICT_CHECK_BEGIN();
        c1_d_out = (chartInstance->c1_sfEvent == c1_event_DOWN);
        if (c1_d_out) {
          transitionList[numTransitions] = 6;
          numTransitions++;
        }

        _SFD_TRANSITION_CONFLICT_CHECK_END();
        if (numTransitions > 1) {
          _SFD_TRANSITION_CONFLICT(&(transitionList[0]),numTransitions);
        }
      }

      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_second = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_gear_state = c1_IN_third;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_third = 1U;
      *c1_gear = 3.0;
      _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
    } else {
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 6U,
                   chartInstance->c1_sfEvent);
      c1_e_out = (CV_TRANSITION_EVAL(6U, (int32_T)_SFD_CCP_CALL(6U, 0,
        chartInstance->c1_sfEvent == c1_event_DOWN != 0U,
        chartInstance->c1_sfEvent)) != 0);
      if (c1_e_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_second = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
        chartInstance->c1_is_gear_state = c1_IN_first;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_first = 1U;
        *c1_gear = 1.0;
        _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
      } else {
        _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 3U,
                     chartInstance->c1_sfEvent);
      }
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 3U, chartInstance->c1_sfEvent);
    break;

   case c1_IN_third:
    CV_STATE_EVAL(0, 0, 4);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 0U, chartInstance->c1_sfEvent);
    c1_f_out = (CV_TRANSITION_EVAL(0U, (int32_T)_SFD_CCP_CALL(0U, 0,
      chartInstance->c1_sfEvent == c1_event_UP != 0U, chartInstance->c1_sfEvent))
                != 0);
    if (c1_f_out) {
      if (_SFD_TRANSITION_CONFLICT_CHECK_ENABLED()) {
        unsigned int transitionList[2];
        unsigned int numTransitions = 1;
        transitionList[0] = 0;
        _SFD_TRANSITION_CONFLICT_CHECK_BEGIN();
        c1_g_out = (chartInstance->c1_sfEvent == c1_event_DOWN);
        if (c1_g_out) {
          transitionList[numTransitions] = 5;
          numTransitions++;
        }

        _SFD_TRANSITION_CONFLICT_CHECK_END();
        if (numTransitions > 1) {
          _SFD_TRANSITION_CONFLICT(&(transitionList[0]),numTransitions);
        }
      }

      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 0U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_third = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_gear_state = c1_IN_fourth;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 2U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_fourth = 1U;
      *c1_gear = 4.0;
      _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
    } else {
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 5U,
                   chartInstance->c1_sfEvent);
      c1_h_out = (CV_TRANSITION_EVAL(5U, (int32_T)_SFD_CCP_CALL(5U, 0,
        chartInstance->c1_sfEvent == c1_event_DOWN != 0U,
        chartInstance->c1_sfEvent)) != 0);
      if (c1_h_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 5U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_third = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 4U, chartInstance->c1_sfEvent);
        chartInstance->c1_is_gear_state = c1_IN_second;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 3U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_second = 1U;
        *c1_gear = 2.0;
        _SFD_DATA_RANGE_CHECK_MIN_MAX(*c1_gear, 1U, 1.0, 4.0);
      } else {
        _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 4U,
                     chartInstance->c1_sfEvent);
      }
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 4U, chartInstance->c1_sfEvent);
    break;

   default:
    CV_STATE_EVAL(0, 0, 0);
    chartInstance->c1_is_gear_state = c1_IN_NO_ACTIVE_CHILD;
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 1U, chartInstance->c1_sfEvent);
    break;
  }

  _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c1_sfEvent);
}

static void c1_selection_state(SFc1_Autotrans_shiftInstanceStruct *chartInstance)
{
  boolean_T c1_temp;
  boolean_T c1_b_temp;
  boolean_T c1_out;
  int32_T c1_previousEvent;
  boolean_T c1_b_out;
  boolean_T c1_c_out;
  boolean_T c1_d_out;
  boolean_T c1_e_out;
  boolean_T c1_c_temp;
  boolean_T c1_d_temp;
  boolean_T c1_f_out;
  int32_T c1_b_previousEvent;
  boolean_T c1_g_out;
  real_T *c1_speed;
  real_T *c1_down_th;
  real_T *c1_up_th;
  c1_down_th = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c1_up_th = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c1_speed = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 5U, chartInstance->c1_sfEvent);
  sf_call_output_fcn_call(chartInstance->S, 0, "CALC_TH", 0);
  switch (chartInstance->c1_is_selection_state) {
   case c1_IN_downshifting:
    CV_STATE_EVAL(5, 0, 1);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 12U,
                 chartInstance->c1_sfEvent);
    c1_temp = (_SFD_CCP_CALL(12U, 0, chartInstance->c1_sfEvent == CALL_EVENT !=
                0U, chartInstance->c1_sfEvent) != 0);
    if (c1_temp) {
      c1_temp = (_SFD_CCP_CALL(12U, 1, chartInstance->c1_temporalCounter_i1 >=
                  _SFD_TRANS_TEMPORAL_THRESHOLD((uint32_T)
        chartInstance->c1_TWAIT, 32U, 12U) != 0U, chartInstance->c1_sfEvent) !=
                 0);
    }

    c1_b_temp = c1_temp;
    if (c1_b_temp) {
      c1_b_temp = (_SFD_CCP_CALL(12U, 2, *c1_speed <= *c1_down_th != 0U,
        chartInstance->c1_sfEvent) != 0);
    }

    c1_out = (CV_TRANSITION_EVAL(12U, (int32_T)c1_b_temp) != 0);
    if (c1_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 12U, chartInstance->c1_sfEvent);
      c1_previousEvent = chartInstance->c1_sfEvent;
      chartInstance->c1_sfEvent = c1_event_DOWN;
      _SFD_CE_CALL(EVENT_BEFORE_BROADCAST_TAG, c1_event_DOWN,
                   chartInstance->c1_sfEvent);
      if (chartInstance->c1_is_active_gear_state == 0U) {
      } else {
        c1_gear_state(chartInstance);
      }

      _SFD_CE_CALL(EVENT_AFTER_BROADCAST_TAG, c1_event_DOWN,
                   chartInstance->c1_sfEvent);
      chartInstance->c1_sfEvent = c1_previousEvent;
      chartInstance->c1_tp_downshifting = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_selection_state = c1_IN_steady_state;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_steady_state = 1U;
    } else {
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 11U,
                   chartInstance->c1_sfEvent);
      c1_b_out = (CV_TRANSITION_EVAL(11U, (int32_T)_SFD_CCP_CALL(11U, 0,
        *c1_speed > *c1_down_th != 0U, chartInstance->c1_sfEvent)) != 0);
      if (c1_b_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 11U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_downshifting = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
        chartInstance->c1_is_selection_state = c1_IN_steady_state;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_steady_state = 1U;
      } else {
        _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 6U,
                     chartInstance->c1_sfEvent);
      }
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 6U, chartInstance->c1_sfEvent);
    break;

   case c1_IN_steady_state:
    CV_STATE_EVAL(5, 0, 2);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 8U, chartInstance->c1_sfEvent);
    c1_c_out = (CV_TRANSITION_EVAL(8U, (int32_T)_SFD_CCP_CALL(8U, 0, *c1_speed >
      *c1_up_th != 0U, chartInstance->c1_sfEvent)) != 0);
    if (c1_c_out) {
      if (_SFD_TRANSITION_CONFLICT_CHECK_ENABLED()) {
        unsigned int transitionList[2];
        unsigned int numTransitions = 1;
        transitionList[0] = 8;
        _SFD_TRANSITION_CONFLICT_CHECK_BEGIN();
        c1_d_out = (*c1_speed < *c1_down_th);
        if (c1_d_out) {
          transitionList[numTransitions] = 9;
          numTransitions++;
        }

        _SFD_TRANSITION_CONFLICT_CHECK_END();
        if (numTransitions > 1) {
          _SFD_TRANSITION_CONFLICT(&(transitionList[0]),numTransitions);
        }
      }

      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 8U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_steady_state = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_selection_state = c1_IN_upshifting;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 8U, chartInstance->c1_sfEvent);
      chartInstance->c1_temporalCounter_i1 = 0U;
      chartInstance->c1_tp_upshifting = 1U;
    } else {
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 9U,
                   chartInstance->c1_sfEvent);
      c1_e_out = (CV_TRANSITION_EVAL(9U, (int32_T)_SFD_CCP_CALL(9U, 0, *c1_speed
        < *c1_down_th != 0U, chartInstance->c1_sfEvent)) != 0);
      if (c1_e_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 9U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_steady_state = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
        chartInstance->c1_is_selection_state = c1_IN_downshifting;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
        chartInstance->c1_temporalCounter_i1 = 0U;
        chartInstance->c1_tp_downshifting = 1U;
      } else {
        _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 7U,
                     chartInstance->c1_sfEvent);
      }
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 7U, chartInstance->c1_sfEvent);
    break;

   case c1_IN_upshifting:
    CV_STATE_EVAL(5, 0, 3);
    _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 13U,
                 chartInstance->c1_sfEvent);
    c1_c_temp = (_SFD_CCP_CALL(13U, 0, chartInstance->c1_sfEvent == CALL_EVENT
      != 0U, chartInstance->c1_sfEvent) != 0);
    if (c1_c_temp) {
      c1_c_temp = (_SFD_CCP_CALL(13U, 1, chartInstance->c1_temporalCounter_i1 >=
        _SFD_TRANS_TEMPORAL_THRESHOLD((uint32_T)chartInstance->c1_TWAIT, 32U,
        13U) != 0U, chartInstance->c1_sfEvent) != 0);
    }

    c1_d_temp = c1_c_temp;
    if (c1_d_temp) {
      c1_d_temp = (_SFD_CCP_CALL(13U, 2, *c1_speed >= *c1_up_th != 0U,
        chartInstance->c1_sfEvent) != 0);
    }

    c1_f_out = (CV_TRANSITION_EVAL(13U, (int32_T)c1_d_temp) != 0);
    if (c1_f_out) {
      _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 13U, chartInstance->c1_sfEvent);
      c1_b_previousEvent = chartInstance->c1_sfEvent;
      chartInstance->c1_sfEvent = c1_event_UP;
      _SFD_CE_CALL(EVENT_BEFORE_BROADCAST_TAG, c1_event_UP,
                   chartInstance->c1_sfEvent);
      if (chartInstance->c1_is_active_gear_state == 0U) {
      } else {
        c1_gear_state(chartInstance);
      }

      _SFD_CE_CALL(EVENT_AFTER_BROADCAST_TAG, c1_event_UP,
                   chartInstance->c1_sfEvent);
      chartInstance->c1_sfEvent = c1_b_previousEvent;
      chartInstance->c1_tp_upshifting = 0U;
      _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c1_sfEvent);
      chartInstance->c1_is_selection_state = c1_IN_steady_state;
      _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
      chartInstance->c1_tp_steady_state = 1U;
    } else {
      _SFD_CT_CALL(TRANSITION_BEFORE_PROCESSING_TAG, 10U,
                   chartInstance->c1_sfEvent);
      c1_g_out = (CV_TRANSITION_EVAL(10U, (int32_T)_SFD_CCP_CALL(10U, 0,
        *c1_speed < *c1_up_th != 0U, chartInstance->c1_sfEvent)) != 0);
      if (c1_g_out) {
        _SFD_CT_CALL(TRANSITION_ACTIVE_TAG, 10U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_upshifting = 0U;
        _SFD_CS_CALL(STATE_INACTIVE_TAG, 8U, chartInstance->c1_sfEvent);
        chartInstance->c1_is_selection_state = c1_IN_steady_state;
        _SFD_CS_CALL(STATE_ACTIVE_TAG, 7U, chartInstance->c1_sfEvent);
        chartInstance->c1_tp_steady_state = 1U;
      } else {
        _SFD_CS_CALL(STATE_ENTER_DURING_FUNCTION_TAG, 8U,
                     chartInstance->c1_sfEvent);
      }
    }

    _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 8U, chartInstance->c1_sfEvent);
    break;

   default:
    CV_STATE_EVAL(5, 0, 0);
    chartInstance->c1_is_selection_state = c1_IN_NO_ACTIVE_CHILD;
    _SFD_CS_CALL(STATE_INACTIVE_TAG, 6U, chartInstance->c1_sfEvent);
    break;
  }

  _SFD_CS_CALL(EXIT_OUT_OF_FUNCTION_TAG, 5U, chartInstance->c1_sfEvent);
}

static void init_script_number_translation(uint32_T c1_machineNumber, uint32_T
  c1_chartNumber, uint32_T c1_instanceNumber)
{
  (void)c1_machineNumber;
  (void)c1_chartNumber;
  (void)c1_instanceNumber;
}

const mxArray *sf_c1_Autotrans_shift_get_eml_resolved_functions_info(void)
{
  const mxArray *c1_nameCaptureInfo = NULL;
  c1_nameCaptureInfo = NULL;
  sf_mex_assign(&c1_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), false);
  return c1_nameCaptureInfo;
}

static const mxArray *c1_sf_marshallOut(void *chartInstanceVoid, void *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  int32_T c1_u;
  const mxArray *c1_y = NULL;
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  c1_u = *(int32_T *)c1_inData;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", &c1_u, 6, 0U, 0U, 0U, 0), false);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, false);
  return c1_mxArrayOutData;
}

static int32_T c1_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  int32_T c1_y;
  int32_T c1_i0;
  (void)chartInstance;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_i0, 1, 6, 0U, 0, 0U, 0);
  c1_y = c1_i0;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void c1_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_b_sfEvent;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  int32_T c1_y;
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)chartInstanceVoid;
  c1_b_sfEvent = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_sfEvent), &c1_thisId);
  sf_mex_destroy(&c1_b_sfEvent);
  *(int32_T *)c1_outData = c1_y;
  sf_mex_destroy(&c1_mxArrayInData);
}

static const mxArray *c1_b_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  uint8_T c1_u;
  const mxArray *c1_y = NULL;
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  c1_u = *(uint8_T *)c1_inData;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", &c1_u, 3, 0U, 0U, 0U, 0), false);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, false);
  return c1_mxArrayOutData;
}

static uint8_T c1_b_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_b_tp_downshifting, const char_T
  *c1_identifier)
{
  uint8_T c1_y;
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_tp_downshifting),
    &c1_thisId);
  sf_mex_destroy(&c1_b_tp_downshifting);
  return c1_y;
}

static uint8_T c1_c_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  uint8_T c1_y;
  uint8_T c1_u0;
  (void)chartInstance;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_u0, 1, 3, 0U, 0, 0U, 0);
  c1_y = c1_u0;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void c1_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_b_tp_downshifting;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  uint8_T c1_y;
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)chartInstanceVoid;
  c1_b_tp_downshifting = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_tp_downshifting),
    &c1_thisId);
  sf_mex_destroy(&c1_b_tp_downshifting);
  *(uint8_T *)c1_outData = c1_y;
  sf_mex_destroy(&c1_mxArrayInData);
}

static const mxArray *c1_c_sf_marshallOut(void *chartInstanceVoid, void
  *c1_inData)
{
  const mxArray *c1_mxArrayOutData = NULL;
  real_T c1_u;
  const mxArray *c1_y = NULL;
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)chartInstanceVoid;
  c1_mxArrayOutData = NULL;
  c1_u = *(real_T *)c1_inData;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_create("y", &c1_u, 0, 0U, 0U, 0U, 0), false);
  sf_mex_assign(&c1_mxArrayOutData, c1_y, false);
  return c1_mxArrayOutData;
}

static real_T c1_d_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_gear, const char_T *c1_identifier)
{
  real_T c1_y;
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_gear), &c1_thisId);
  sf_mex_destroy(&c1_gear);
  return c1_y;
}

static real_T c1_e_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  real_T c1_y;
  real_T c1_d1;
  (void)chartInstance;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_d1, 1, 0, 0U, 0, 0U, 0);
  c1_y = c1_d1;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void c1_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c1_mxArrayInData, const char_T *c1_varName, void *c1_outData)
{
  const mxArray *c1_gear;
  const char_T *c1_identifier;
  emlrtMsgIdentifier c1_thisId;
  real_T c1_y;
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)chartInstanceVoid;
  c1_gear = sf_mex_dup(c1_mxArrayInData);
  c1_identifier = c1_varName;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_e_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_gear), &c1_thisId);
  sf_mex_destroy(&c1_gear);
  *(real_T *)c1_outData = c1_y;
  sf_mex_destroy(&c1_mxArrayInData);
}

static uint32_T c1_f_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_b_temporalCounter_i1, const char_T
  *c1_identifier)
{
  uint32_T c1_y;
  emlrtMsgIdentifier c1_thisId;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  c1_y = c1_g_emlrt_marshallIn(chartInstance, sf_mex_dup(c1_b_temporalCounter_i1),
    &c1_thisId);
  sf_mex_destroy(&c1_b_temporalCounter_i1);
  return c1_y;
}

static uint32_T c1_g_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  uint32_T c1_y;
  uint32_T c1_u1;
  (void)chartInstance;
  sf_mex_import(c1_parentId, sf_mex_dup(c1_u), &c1_u1, 1, 7, 0U, 0, 0U, 0);
  c1_y = c1_u1;
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static const mxArray *c1_h_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_b_setSimStateSideEffectsInfo, const char_T
  *c1_identifier)
{
  const mxArray *c1_y = NULL;
  emlrtMsgIdentifier c1_thisId;
  c1_y = NULL;
  c1_thisId.fIdentifier = c1_identifier;
  c1_thisId.fParent = NULL;
  sf_mex_assign(&c1_y, c1_i_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c1_b_setSimStateSideEffectsInfo), &c1_thisId), false);
  sf_mex_destroy(&c1_b_setSimStateSideEffectsInfo);
  return c1_y;
}

static const mxArray *c1_i_emlrt_marshallIn(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance, const mxArray *c1_u, const emlrtMsgIdentifier *c1_parentId)
{
  const mxArray *c1_y = NULL;
  (void)chartInstance;
  (void)c1_parentId;
  c1_y = NULL;
  sf_mex_assign(&c1_y, sf_mex_duplicatearraysafe(&c1_u), false);
  sf_mex_destroy(&c1_u);
  return c1_y;
}

static void init_dsm_address_info(SFc1_Autotrans_shiftInstanceStruct
  *chartInstance)
{
  (void)chartInstance;
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c1_Autotrans_shift_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1938354191U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(465890558U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(902731188U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2388276484U);
}

mxArray *sf_c1_Autotrans_shift_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("jDn9kQaoiCYO9oYlqCDK0G");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,3,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxData);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c1_Autotrans_shift_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

mxArray *sf_c1_Autotrans_shift_updateBuildInfo_args_info(void)
{
  mxArray *mxBIArgs = mxCreateCellMatrix(1,0);
  return mxBIArgs;
}

static const mxArray *sf_get_sim_state_info_c1_Autotrans_shift(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x7'type','srcId','name','auxInfo'{{M[1],M[25],T\"gear\",},{M[8],M[0],T\"is_active_c1_Autotrans_shift\",},{M[8],M[2],T\"is_active_gear_state\",},{M[8],M[7],T\"is_active_selection_state\",},{M[9],M[2],T\"is_gear_state\",},{M[9],M[7],T\"is_selection_state\",},{M[11],M[0],T\"temporalCounter_i1\",S'et','os','ct'{{T\"wu\",M1x2[1 8],M[1]}}}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 7, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c1_Autotrans_shift_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc1_Autotrans_shiftInstanceStruct *chartInstance;
    ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
    ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
    chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)
      chartInfo->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _Autotrans_shiftMachineNumber_,
           1,
           9,
           14,
           0,
           5,
           3,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           (void *)S);

        /* Each instance must initialize ist own list of scripts */
        init_script_number_translation(_Autotrans_shiftMachineNumber_,
          chartInstance->chartNumber,chartInstance->instanceNumber);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,_Autotrans_shiftMachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _Autotrans_shiftMachineNumber_,
            chartInstance->chartNumber,
            3,
            3,
            3);
          _SFD_SET_DATA_PROPS(0,1,1,0,"speed");
          _SFD_SET_DATA_PROPS(1,2,0,1,"gear");
          _SFD_SET_DATA_PROPS(2,10,0,0,"TWAIT");
          _SFD_SET_DATA_PROPS(3,1,1,0,"up_th");
          _SFD_SET_DATA_PROPS(4,1,1,0,"down_th");
          _SFD_EVENT_SCOPE(0,2);
          _SFD_EVENT_SCOPE(1,0);
          _SFD_EVENT_SCOPE(2,0);
          _SFD_STATE_INFO(0,0,1);
          _SFD_STATE_INFO(1,0,0);
          _SFD_STATE_INFO(2,0,0);
          _SFD_STATE_INFO(3,0,0);
          _SFD_STATE_INFO(4,0,0);
          _SFD_STATE_INFO(5,0,1);
          _SFD_STATE_INFO(6,0,0);
          _SFD_STATE_INFO(7,0,0);
          _SFD_STATE_INFO(8,0,0);
          _SFD_CH_SUBSTATE_COUNT(2);
          _SFD_CH_SUBSTATE_DECOMP(1);
          _SFD_CH_SUBSTATE_INDEX(0,0);
          _SFD_CH_SUBSTATE_INDEX(1,5);
          _SFD_ST_SUBSTATE_COUNT(0,4);
          _SFD_ST_SUBSTATE_INDEX(0,0,1);
          _SFD_ST_SUBSTATE_INDEX(0,1,2);
          _SFD_ST_SUBSTATE_INDEX(0,2,3);
          _SFD_ST_SUBSTATE_INDEX(0,3,4);
          _SFD_ST_SUBSTATE_COUNT(1,0);
          _SFD_ST_SUBSTATE_COUNT(2,0);
          _SFD_ST_SUBSTATE_COUNT(3,0);
          _SFD_ST_SUBSTATE_COUNT(4,0);
          _SFD_ST_SUBSTATE_COUNT(5,3);
          _SFD_ST_SUBSTATE_INDEX(5,0,6);
          _SFD_ST_SUBSTATE_INDEX(5,1,7);
          _SFD_ST_SUBSTATE_INDEX(5,2,8);
          _SFD_ST_SUBSTATE_COUNT(6,0);
          _SFD_ST_SUBSTATE_COUNT(7,0);
          _SFD_ST_SUBSTATE_COUNT(8,0);
        }

        _SFD_CV_INIT_CHART(2,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,4,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(1,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(2,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(3,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(4,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(5,3,1,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(6,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(7,0,0,0,0,0,NULL,NULL);
        }

        {
          _SFD_CV_INIT_STATE(8,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(3,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 0 };

          static unsigned int sEndGuardMap[] = { 2 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(1,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 0 };

          static unsigned int sEndGuardMap[] = { 2 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(2,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 0 };

          static unsigned int sEndGuardMap[] = { 2 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(0,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 0 };

          static unsigned int sEndGuardMap[] = { 4 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(6,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 0 };

          static unsigned int sEndGuardMap[] = { 4 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(4,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 0 };

          static unsigned int sEndGuardMap[] = { 4 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(5,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_CV_INIT_TRANS(7,0,NULL,NULL,0,NULL);

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 14 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(8,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(9,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 16 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(11,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 12, 0, 19 };

          static unsigned int sEndGuardMap[] = { 16, 17, 35 };

          static int sPostFixPredicateTree[] = { 0, 1, -3, 2, -3 };

          _SFD_CV_INIT_TRANS(12,3,&(sStartGuardMap[0]),&(sEndGuardMap[0]),5,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 12, 0, 19 };

          static unsigned int sEndGuardMap[] = { 16, 17, 33 };

          static int sPostFixPredicateTree[] = { 0, 1, -3, 2, -3 };

          _SFD_CV_INIT_TRANS(13,3,&(sStartGuardMap[0]),&(sEndGuardMap[0]),5,
                             &(sPostFixPredicateTree[0]));
        }

        {
          static unsigned int sStartGuardMap[] = { 1 };

          static unsigned int sEndGuardMap[] = { 14 };

          static int sPostFixPredicateTree[] = { 0 };

          _SFD_CV_INIT_TRANS(10,1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),1,
                             &(sPostFixPredicateTree[0]));
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_c_sf_marshallOut,(MexInFcnForType)c1_c_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_c_sf_marshallOut,(MexInFcnForType)c1_c_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_c_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c1_c_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c1_speed;
          real_T *c1_gear;
          real_T *c1_up_th;
          real_T *c1_down_th;
          c1_down_th = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
          c1_up_th = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c1_gear = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c1_speed = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c1_speed);
          _SFD_SET_DATA_VALUE_PTR(1U, c1_gear);
          _SFD_SET_DATA_VALUE_PTR(2U, &chartInstance->c1_TWAIT);
          _SFD_SET_DATA_VALUE_PTR(3U, c1_up_th);
          _SFD_SET_DATA_VALUE_PTR(4U, c1_down_th);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _Autotrans_shiftMachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "1IOx9xEHjVQ9AQWMp3SpUC";
}

static void sf_opaque_initialize_c1_Autotrans_shift(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar);
  initialize_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c1_Autotrans_shift(void *chartInstanceVar)
{
  enable_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c1_Autotrans_shift(void *chartInstanceVar)
{
  disable_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c1_Autotrans_shift(void *chartInstanceVar)
{
  sf_gateway_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c1_Autotrans_shift(SimStruct* S)
{
  ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
  ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c1_Autotrans_shift
    ((SFc1_Autotrans_shiftInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c1_Autotrans_shift();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c1_Autotrans_shift(SimStruct* S, const
  mxArray *st)
{
  ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
  ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[3];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxDuplicateArray(st);      /* high level simctx */
  prhs[2] = (mxArray*) sf_get_sim_state_info_c1_Autotrans_shift();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 3, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c1_Autotrans_shift(SimStruct* S)
{
  return sf_internal_get_sim_state_c1_Autotrans_shift(S);
}

static void sf_opaque_set_sim_state_c1_Autotrans_shift(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c1_Autotrans_shift(S, st);
}

static void sf_opaque_terminate_c1_Autotrans_shift(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc1_Autotrans_shiftInstanceStruct*) chartInstanceVar)->S;
    ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_Autotrans_shift_optimization_info();
    }

    finalize_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
      chartInstanceVar);
    utFree((void *)chartInstanceVar);
    if (crtInfo != NULL) {
      utFree((void *)crtInfo);
    }

    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c1_Autotrans_shift(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)(ssGetUserData(S));
    ChartInfoStruct * chartInfo = (ChartInfoStruct *)(crtInfo->instanceInfo);
    initialize_params_c1_Autotrans_shift((SFc1_Autotrans_shiftInstanceStruct*)
      (chartInfo->chartInstance));
  }
}

static void mdlSetWorkWidths_c1_Autotrans_shift(SimStruct *S)
{
  /* Actual parameters from chart:
     TWAIT
   */
  const char_T *rtParamNames[] = { "TWAIT" };

  ssSetNumRunTimeParams(S,ssGetSFcnParamsCount(S));

  /* registration for TWAIT*/
  ssRegDlgParamAsRunTimeParam(S, 0, 0, rtParamNames[0], SS_DOUBLE);
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_Autotrans_shift_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(sf_get_instance_specialization(),infoStruct,1);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(sf_get_instance_specialization(),
                infoStruct,1,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop
      (sf_get_instance_specialization(),infoStruct,1,
       "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(sf_get_instance_specialization(),infoStruct,1);
    sf_mark_output_events_with_multiple_callers(S,sf_get_instance_specialization
      (),infoStruct,1,1);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,1,3);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,1,1);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=1; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 3; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,1);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(2179025461U));
  ssSetChecksum1(S,(3866970667U));
  ssSetChecksum2(S,(20248632U));
  ssSetChecksum3(S,(2271818973U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c1_Autotrans_shift(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Stateflow");
  }
}

static void mdlStart_c1_Autotrans_shift(SimStruct *S)
{
  SFc1_Autotrans_shiftInstanceStruct *chartInstance;
  ChartRunTimeInfo * crtInfo = (ChartRunTimeInfo *)utMalloc(sizeof
    (ChartRunTimeInfo));
  chartInstance = (SFc1_Autotrans_shiftInstanceStruct *)utMalloc(sizeof
    (SFc1_Autotrans_shiftInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc1_Autotrans_shiftInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 0;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c1_Autotrans_shift;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c1_Autotrans_shift;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c1_Autotrans_shift;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c1_Autotrans_shift;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c1_Autotrans_shift;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c1_Autotrans_shift;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c1_Autotrans_shift;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c1_Autotrans_shift;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c1_Autotrans_shift;
  chartInstance->chartInfo.mdlStart = mdlStart_c1_Autotrans_shift;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c1_Autotrans_shift;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->chartInfo.debugInstance = sfGlobalDebugInstanceStruct;
  chartInstance->S = S;
  crtInfo->instanceInfo = (&(chartInstance->chartInfo));
  crtInfo->isJITEnabled = false;
  ssSetUserData(S,(void *)(crtInfo));  /* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c1_Autotrans_shift_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c1_Autotrans_shift(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c1_Autotrans_shift(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c1_Autotrans_shift(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c1_Autotrans_shift_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
