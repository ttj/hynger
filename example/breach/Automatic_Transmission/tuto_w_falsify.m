% Model

mdl = 'Autotrans_shift';
Sys = CreateSimulinkSystem(mdl, {}, {}, [], 'VarStep2');
Sys.tspan = 0:.1:50;

formulas = QMITL_ReadFile('spec_wstl.stl');

params_prop = {'w', 'vmax'};

params_u = {'throttle_u0', 'dt_u0'};

ranges = [ 0 100; ...
           0 20 ...
         ]

P = CreateParamSet(Sys, params_u, ranges);

P = SetParam(P, 'dt_u1', 20);
P = SetParam(P, 'brake_u1', 325);

Pr = Refine(P, 10);
Pr = ComputeTraj(Sys,Pr, Sys.tspan);

Pr = SetParam(Pr, 'w', 1);
[Pr, val] =SEvalProp(Sys, Pr, phi,0);

figure;
SplotProp(Pr, phi);
view(48,50);
%save2pdf('/Users/alex/workspace/LATEX/Figsforall/WSTLbof.pdf')

pause
params_prop.names = {'w','dt_u1', 'brake_u1'};
params_prop.values = [1, 20, 325];

falsif_opt.params = {'throttle_u0', 'dt_u0'};
falsif_opt.ranges = [0 100; 0 20];
  
falsif_opt.nb_init = 10;
falsif_opt.nb_iter = 50;

Pf = Falsify(Sys, phi, falsif_opt, params_prop);


Pr2 = SetParam(Pr, 'w', 1000);
[Pr2, val2] = SEvalProp(Sys, Pr2, phi,0);
figure;
SplotProp(Pr2, phi);
view(48,50);
%save2pdf('/Users/alex/workspace/LATEX/Figsforall/WSTLsmooth.pdf')

pause
params_prop.names = {'w','dt_u1', 'brake_u1'};
params_prop.values = [1000, 20, 325];

falsif_opt.params = {'throttle_u0', 'dt_u0'};
falsif_opt.ranges = [0 100; 0 20];
  
falsif_opt.nb_init = 10;
falsif_opt.nb_iter = 50;

Pf = Falsify(Sys, phi, falsif_opt, params_prop);
Psave(Sys, 'Pr', 'Pr2');


