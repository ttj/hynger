Sys = CreateSimulinkSystem('Simulink_crazycontroller', 'logged', {'cycle_dur'}, 0.01)
                           );
Sys.tspan = 0:1e-4:.3;

P = CreateParamSet(Sys);
Pf = ComputeTraj(Sys,P,Sys.tspan); 

formulas = QMITL_ReadFile('spec.stl');
 
save('Simulink_crazycontroller_breach_properties', formulas{:});
 
Pprop = CreateParamSet(Sys, {'eps'});
Pprop = SetParam(Pprop, {'eps'}, 1e-3);
 
Psave(Sys,'Pprop');
 