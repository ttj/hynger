%% This tutorial explains how to use CreateExternSystm to use Breach with
%% a custom sim command in case CreateSimulinkSystem is not sufficient

mdl = 'Autotrans_shift';

signals = {'speed', 'RPM', 'gear', 'in_throttle', 'in_brake'};

param  = {'t1','throttle0','throttle1','brake0', 'brake1' };

p0 = [10, 100, 0,  0, 3000];

Sys = CreateExternSystem(mdl, signals, param, p0, @sim_autotrans_accel);

tspan = 0:0.01:30;
P = CreateParamSet(Sys);
P = ComputeTraj(Sys, P, tspan);

SplotVar(P);