/* Include files */

#include "Autotrans_shift_breach_sfun.h"
#include "Autotrans_shift_breach_sfun_debug_macros.h"
#include "c1_Autotrans_shift_breach.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _Autotrans_shift_breachMachineNumber_;

/* Function Declarations */

/* Function Definitions */
void Autotrans_shift_breach_initializer(void)
{
}

void Autotrans_shift_breach_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_Autotrans_shift_breach_method_dispatcher(SimStruct *simstructPtr,
  unsigned int chartFileNumber, const char* specsCksum, int_T method, void *data)
{
  if (chartFileNumber==1) {
    c1_Autotrans_shift_breach_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  return 0;
}

unsigned int sf_Autotrans_shift_breach_process_check_sum_call( int nlhs, mxArray
  * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>1 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"machine")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1248155439U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(93303136U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2409703152U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2558146768U);
    } else if (!strcmp(commandName,"exportedFcn")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0U);
    } else if (!strcmp(commandName,"makefile")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3669180227U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3079455613U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(889268403U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(4045103064U);
    } else if (nrhs==3 && !strcmp(commandName,"chart")) {
      unsigned int chartFileNumber;
      chartFileNumber = (unsigned int)mxGetScalar(prhs[2]);
      switch (chartFileNumber) {
       case 1:
        {
          extern void sf_c1_Autotrans_shift_breach_get_check_sum(mxArray *plhs[]);
          sf_c1_Autotrans_shift_breach_get_check_sum(plhs);
          break;
        }

       default:
        ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
      }
    } else if (!strcmp(commandName,"target")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(568235647U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2712774503U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(71367846U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(4068185268U);
    } else {
      return 0;
    }
  } else {
    ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1132410738U);
    ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1648514170U);
    ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2450982231U);
    ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1752017742U);
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_Autotrans_shift_breach_autoinheritance_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(aiChksum, "jDn9kQaoiCYO9oYlqCDK0G") == 0) {
          extern mxArray *sf_c1_Autotrans_shift_breach_get_autoinheritance_info
            (void);
          plhs[0] = sf_c1_Autotrans_shift_breach_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_Autotrans_shift_breach_get_eml_resolved_functions_info( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        extern const mxArray
          *sf_c1_Autotrans_shift_breach_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c1_Autotrans_shift_breach_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_Autotrans_shift_breach_third_party_uses_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the third_party_uses_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_third_party_uses_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "1IOx9xEHjVQ9AQWMp3SpUC") == 0) {
          extern mxArray *sf_c1_Autotrans_shift_breach_third_party_uses_info
            (void);
          plhs[0] = sf_c1_Autotrans_shift_breach_third_party_uses_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_Autotrans_shift_breach_updateBuildInfo_args_info( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the updateBuildInfo_args_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_updateBuildInfo_args_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "1IOx9xEHjVQ9AQWMp3SpUC") == 0) {
          extern mxArray *sf_c1_Autotrans_shift_breach_updateBuildInfo_args_info
            (void);
          plhs[0] = sf_c1_Autotrans_shift_breach_updateBuildInfo_args_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

void Autotrans_shift_breach_debug_initialize(struct SfDebugInstanceStruct*
  debugInstance)
{
  _Autotrans_shift_breachMachineNumber_ = sf_debug_initialize_machine
    (debugInstance,"Autotrans_shift_breach","sfun",0,1,0,0,0);
  sf_debug_set_machine_event_thresholds(debugInstance,
    _Autotrans_shift_breachMachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(debugInstance,
    _Autotrans_shift_breachMachineNumber_,0);
}

void Autotrans_shift_breach_register_exported_symbols(SimStruct* S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_Autotrans_shift_breach_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info(
      "Autotrans_shift_breach", "Autotrans_shift_breach");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_Autotrans_shift_breach_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
