#include "__cf_Autotrans_shift_breach.h"
#include <math.h>
#include "Autotrans_shift_breach_acc.h"
#include "Autotrans_shift_breach_acc_private.h"
#include <stdio.h>
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
void gixsqetl0k ( SimStruct * const S ) { ew10rzwqr2 * _rtDW ; _rtDW = ( (
ew10rzwqr2 * ) ssGetRootDWork ( S ) ) ; _rtDW -> f5zcdja33y = true ; } void
k2uck2t2gv ( SimStruct * const S ) { ew10rzwqr2 * _rtDW ; _rtDW = ( (
ew10rzwqr2 * ) ssGetRootDWork ( S ) ) ; _rtDW -> f5zcdja33y = false ; } void
ch34zigaue ( SimStruct * const S ) { n3qi1whofz * _rtB ; loikxjbxjg * _rtP ;
ew10rzwqr2 * _rtDW ; _rtDW = ( ( ew10rzwqr2 * ) ssGetRootDWork ( S ) ) ; _rtP
= ( ( loikxjbxjg * ) ssGetDefaultParam ( S ) ) ; _rtB = ( ( n3qi1whofz * )
_ssGetBlockIO ( S ) ) ; _rtB -> owqvowo5ha = rt_Lookup2D_Normal ( _rtP -> P_0
, 6 , _rtP -> P_1 , 4 , _rtP -> P_2 , ( ( mtnexwdpxa * ) ssGetU ( S ) ) ->
fsgwekhkkv , _rtB -> hsgy4zkqe3 ) ; _rtB -> o3u3cslc34 = rt_Lookup2D_Normal (
_rtP -> P_3 , 6 , _rtP -> P_4 , 4 , _rtP -> P_5 , ( ( mtnexwdpxa * ) ssGetU (
S ) ) -> fsgwekhkkv , _rtB -> hsgy4zkqe3 ) ; _rtDW -> cqgsptyxjk = 4 ; }
boolean_T ch34zigaueFNI ( SimStruct * const S , int_T controlPortIdx , int_T
tid ) { ch34zigaue ( S ) ; UNUSED_PARAMETER ( controlPortIdx ) ;
UNUSED_PARAMETER ( tid ) ; return ( 1 ) ; } void a5v0sekykn ( SimStruct *
const S ) { } static void mdlOutputs ( SimStruct * S , int_T tid ) { real_T
n2rwvsubi1 ; real_T ff0brfow4i ; n3qi1whofz * _rtB ; loikxjbxjg * _rtP ;
f1xhd02yjc * _rtX ; ew10rzwqr2 * _rtDW ; _rtDW = ( ( ew10rzwqr2 * )
ssGetRootDWork ( S ) ) ; _rtX = ( ( f1xhd02yjc * ) ssGetContStates ( S ) ) ;
_rtP = ( ( loikxjbxjg * ) ssGetDefaultParam ( S ) ) ; _rtB = ( ( n3qi1whofz *
) _ssGetBlockIO ( S ) ) ; n2rwvsubi1 = _rtX -> azm34qp5pu ; _rtB ->
a35ha4xmd4 = _rtP -> P_9 * _rtX -> azm34qp5pu * _rtP -> P_10 ;
ssCallAccelRunBlock ( S , 2 , 3 , SS_CALL_MDL_OUTPUTS ) ; if ( ( ( f1xhd02yjc
* ) ssGetContStates ( S ) ) -> kdcsyngxxk >= _rtP -> P_12 ) { if ( ( (
f1xhd02yjc * ) ssGetContStates ( S ) ) -> kdcsyngxxk != _rtP -> P_12 ) { ( (
f1xhd02yjc * ) ssGetContStates ( S ) ) -> kdcsyngxxk = _rtP -> P_12 ;
ssSetSolverNeedsReset ( S ) ; } } else if ( ( ( f1xhd02yjc * )
ssGetContStates ( S ) ) -> kdcsyngxxk <= _rtP -> P_13 ) { if ( ( ( f1xhd02yjc
* ) ssGetContStates ( S ) ) -> kdcsyngxxk != _rtP -> P_13 ) { ( ( f1xhd02yjc
* ) ssGetContStates ( S ) ) -> kdcsyngxxk = _rtP -> P_13 ;
ssSetSolverNeedsReset ( S ) ; } } _rtB -> nyeosjdjr3 = ( ( f1xhd02yjc * )
ssGetContStates ( S ) ) -> kdcsyngxxk ; ssCallAccelRunBlock ( S , 2 , 5 ,
SS_CALL_MDL_OUTPUTS ) ; if ( ssIsSampleHit ( S , 2 , 0 ) ) {
ssCallAccelRunBlock ( S , 1 , 0 , SS_CALL_MDL_OUTPUTS ) ; ssCallAccelRunBlock
( S , 2 , 8 , SS_CALL_MDL_OUTPUTS ) ; _rtB -> od5uhirhrg = rt_Lookup ( _rtP
-> P_14 , 4 , _rtB -> hsgy4zkqe3 , _rtP -> P_15 ) ; } _rtB -> drufz3wq0f =
_rtP -> P_16 * n2rwvsubi1 ; n2rwvsubi1 = _rtB -> od5uhirhrg * _rtB ->
drufz3wq0f / _rtB -> nyeosjdjr3 ; ff0brfow4i = _rtB -> nyeosjdjr3 / rt_Lookup
( _rtP -> P_17 , 21 , n2rwvsubi1 , _rtP -> P_18 ) ; _rtB -> hmldh4mfpc =
muDoubleScalarPower ( ff0brfow4i , 2.0 ) ; _rtB -> gsoqrd3dsa = _rtB ->
hmldh4mfpc * rt_Lookup ( _rtP -> P_19 , 21 , n2rwvsubi1 , _rtP -> P_20 ) *
_rtB -> od5uhirhrg ; ssCallAccelRunBlock ( S , 2 , 19 , SS_CALL_MDL_OUTPUTS )
; ssCallAccelRunBlock ( S , 2 , 20 , SS_CALL_MDL_OUTPUTS ) ;
ssCallAccelRunBlock ( S , 2 , 21 , SS_CALL_MDL_OUTPUTS ) ; if ( ssIsSampleHit
( S , 1 , 0 ) ) { ssCallAccelRunBlock ( S , 2 , 22 , SS_CALL_MDL_OUTPUTS ) ;
ssCallAccelRunBlock ( S , 2 , 23 , SS_CALL_MDL_OUTPUTS ) ; } _rtB ->
fjs5nupi3e = ( rt_Lookup2D_Normal ( _rtP -> P_21 , 10 , _rtP -> P_22 , 11 ,
_rtP -> P_23 , ( ( mtnexwdpxa * ) ssGetU ( S ) ) -> fsgwekhkkv , _rtB ->
nyeosjdjr3 ) - _rtB -> hmldh4mfpc ) * _rtP -> P_24 ; _rtB -> krp2zqsstm = (
_rtP -> P_25 * _rtB -> gsoqrd3dsa - ( ( 0.02 * muDoubleScalarPower ( _rtB ->
a35ha4xmd4 , 2.0 ) + 40.0 ) + ( ( mtnexwdpxa * ) ssGetU ( S ) ) -> clefvdrcq2
) * muDoubleScalarSign ( _rtB -> a35ha4xmd4 ) ) * _rtP -> P_26 ;
UNUSED_PARAMETER ( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { n3qi1whofz * _rtB ;
loikxjbxjg * _rtP ; _rtP = ( ( loikxjbxjg * ) ssGetDefaultParam ( S ) ) ;
_rtB = ( ( n3qi1whofz * ) _ssGetBlockIO ( S ) ) ; UNUSED_PARAMETER ( tid ) ;
}
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { n3qi1whofz * _rtB ; loikxjbxjg
* _rtP ; pqmvzr1kvu * _rtXdot ; _rtXdot = ( ( pqmvzr1kvu * ) ssGetdX ( S ) )
; _rtP = ( ( loikxjbxjg * ) ssGetDefaultParam ( S ) ) ; _rtB = ( ( n3qi1whofz
* ) _ssGetBlockIO ( S ) ) ; _rtXdot -> azm34qp5pu = _rtB -> krp2zqsstm ; {
boolean_T lsat ; boolean_T usat ; lsat = ( ( ( f1xhd02yjc * ) ssGetContStates
( S ) ) -> kdcsyngxxk <= _rtP -> P_13 ) ; usat = ( ( ( f1xhd02yjc * )
ssGetContStates ( S ) ) -> kdcsyngxxk >= _rtP -> P_12 ) ; if ( ( ! lsat && !
usat ) || ( lsat && ( _rtB -> fjs5nupi3e > 0 ) ) || ( usat && ( _rtB ->
fjs5nupi3e < 0 ) ) ) { ( ( pqmvzr1kvu * ) ssGetdX ( S ) ) -> kdcsyngxxk =
_rtB -> fjs5nupi3e ; } else { ( ( pqmvzr1kvu * ) ssGetdX ( S ) ) ->
kdcsyngxxk = 0.0 ; } } } static void mdlInitializeSizes ( SimStruct * S ) {
ssSetChecksumVal ( S , 0 , 987875822U ) ; ssSetChecksumVal ( S , 1 ,
2523366596U ) ; ssSetChecksumVal ( S , 2 , 2945497407U ) ; ssSetChecksumVal (
S , 3 , 308281638U ) ; { mxArray * slVerStructMat = NULL ; mxArray * slStrMat
= mxCreateString ( "simulink" ) ; char slVerChar [ 10 ] ; int status =
mexCallMATLAB ( 1 , & slVerStructMat , 1 , & slStrMat , "ver" ) ; if ( status
== 0 ) { mxArray * slVerMat = mxGetField ( slVerStructMat , 0 , "Version" ) ;
if ( slVerMat == NULL ) { status = 1 ; } else { status = mxGetString (
slVerMat , slVerChar , 10 ) ; } } mxDestroyArray ( slStrMat ) ;
mxDestroyArray ( slVerStructMat ) ; if ( ( status == 1 ) || ( strcmp (
slVerChar , "8.3" ) != 0 ) ) { return ; } } ssSetOptions ( S ,
SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork ( S ) != sizeof (
ew10rzwqr2 ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( n3qi1whofz ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofU ( S ) != sizeof
( mtnexwdpxa ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal ExternalInputs sizes do "
"not match for accelerator mex file." ) ; ssSetErrorStatus ( S , msg ) ; } if
( ssGetSizeofY ( S ) != sizeof ( aa1k5lsz3f ) ) { static char msg [ 256 ] ;
sprintf ( msg , "Unexpected error: Internal ExternalOutputs sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
loikxjbxjg ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetDefaultParam ( S , (
real_T * ) & o2iu0a2jke ) ; rt_InitInfAndNaN ( sizeof ( real_T ) ) ; } static
void mdlInitializeSampleTimes ( SimStruct * S ) { { SimStruct * childS ;
SysOutputFcn * callSysFcns ; childS = ssGetSFunction ( S , 0 ) ; callSysFcns
= ssGetCallSystemOutputFcnList ( childS ) ; callSysFcns [ 3 + 0 ] = (
SysOutputFcn ) ch34zigaueFNI ; } } static void mdlTerminate ( SimStruct * S )
{ }
#include "simulink.c"
