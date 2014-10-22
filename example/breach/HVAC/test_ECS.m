clear all;

% Init model and create Breach Sys structure
Init_ECS;
tspan = 0:1:1440;

load Breach_Params;
Sys = CreateSimulinkSystem('ECS_Model', 'logged', par.Names, par.p0);

% Init requirement formulas 

formulas = QMITL_ReadFile('ECS_prop.stl');
Propsave(Sys, formulas{:})

% Init parameter set

P = CreateParamSet(Sys, {'t_morning', 't_evening', 'hot_lim', 'cold_lim'});


P = SetParam(P, {'t_morning', 't_evening', 'hot_lim', 'cold_lim'}, [8*60, ...
                    18*60, 72, 69]');

P = ComputeTraj(Sys, P, tspan);

figure;
SplotVar(P);

Psave(Sys, 'P');
Breach(Sys);