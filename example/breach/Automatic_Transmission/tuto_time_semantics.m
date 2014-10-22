%% Init system and nominal trajectory (in P0)

tuto_simulink_system;
close all;

%%  define property 

% predicate checking if we are in gear2

QMITL_Formula('gear2', 'abs(gear[t]-2) < 0.1')
QMITL_Formula('phi', 'ev (alw_[0, t1] (gear2))');

params_phi.names = {'t1'};
params_phi.values =  [1];


%% Eval and plot property phi1

P0= SetParam(P0, params_phi.names, params_phi.values);

% Eval satisfaction function for phi1, P0 and P0.traj at time tau=0

BreachGlobOpt.RobustSemantics = 0;

val = QMITL_Eval(Sys, phi, P0, P0.traj,0)
  
% plot satisfaction function with sub formula, space semantics 

figure;
depth = 3;
SplotSat(Sys, P0, phi, depth);
pause

%% Same thing with time robustness (left)

BreachGlobOpt.RobustSemantics = -1;
val_left = QMITL_Eval(Sys, phi, P0, P0.traj,0)


figure;
depth = 3;
SplotSat(Sys, P0, phi, depth);
pause

%% Same thing with time robustness (right)

BreachGlobOpt.RobustSemantics = 1;

val_right = QMITL_Eval(Sys, phi, P0, P0.traj,0)

figure;
depth = 3;
SplotSat(Sys, P0, phi, depth);
pause
%% Eval and plot satisfaction function as a function of system input

Pu = CreateParamSet(Sys, {'dt_u0'}, [0 10], 100); % 100 samples with dt_u0 in range [0 10]
Pu = ComputeTraj(Sys, Pu, Sys.tspan); 
Pu = SetParam(Pu, params_phi.names, params_phi.values);

% space semantics
BreachGlobOpt.RobustSemantics = 0;
Pu = SEvalProp(Sys, Pu, phi);
figure;
SplotProp(Pu, phi);
title('Space Semantics')
pause
% time semantics
BreachGlobOpt.RobustSemantics = -1;
Pu = SEvalProp(Sys, Pu, phi);
figure;
SplotProp(Pu, phi);
title('Time Semantics')
pause
