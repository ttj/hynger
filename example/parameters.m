% University of Texas at Arlington
% 
% OPTIONS: select the converter type by changing the mode variable
%
% usage: first, open Simulink/StateFlow model dc2dc_dcm.slx / dc2dc_dcm.mdl
%        second: execute this file, parameters.m
% this sets up parameters for simulation, then simulates the models 
% and generates plots

clc  % clears command window
clear all; % warning, all results and workspace cleared

option_sim = 0; % call simulation and plot from this script
option_extrema = 0; % component variation; only supports buck converter for now

% converter types
MODE_BUCK = 1;
MODE_BOOST = 2;
MODE_BUCKBOOST = 3;

mode = MODE_BUCK; % selected converter to model
% mode = MODE_BOOST;
% mode = MODE_BUCKBOOST;

% source voltage noise for stateflow simulation
Vs_noise = 1;
%0.1;

% initial current and voltage
%i0 = 0;
%v0 = 0;

i0 = 4.5;
v0 = 48;

switch mode
% Buck converter modeling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case MODE_BUCK
%         
%         C = 25e-6; % capacitor value
%         L = 50e-6; % inductor
%         R = 10;% resistor (for DCM R=10)
%         T = 0.00001;% switching period
%         Vs = 12;% input (source) voltage
%         Vref = 5;% desired output voltage
%         Tmax = T*100;% max simulation time (spaceex uses shorter time by default)
%         rs=4.7;% switching loss
%         rL=50e-3;% ESR inductor loss
%         cr=1.25;%Correction applied to duty ratio to cater losses

%       %PROTOTYPE BUCK IN THE LAB%%%%%%%%%%%%%%%%%%%
        T = 1/60000;
        Vs = 100;
        Vref = 48;
        C = 2.2e-3;
        L = 2.65e-3;
        R=5; % was 10
        rs=3.5;% switching loss
        rL=520e-3;% ESR inductor loss
        Tmax = T*1800;% 
        cr=1.265;%Correction applied to duty ratio to cater losses
        %%%  END PROTOTYPE BUCK IN THE LAB  %%%%%%%%

% Define transition matrices

        Ac_nom = [-1*(rs+rL)/L, -(1/L); (1/C), -(1/(R*C))];% switch closed
        Bc_nom = [(1/L); 0];

        Ao_nom = [-rL/L, -(1/L); (1/C), -(1/(R*C))];% switch open
        Bo_nom = [0; 0];
        
        Ad_nom = [0, 0; 0, -(1/(R*C))];%For DCM
        Bd_nom = [0; 0];%For DCM
        
D = cr*Vref / Vs;% duty cycle

% output filename
        outname = 'buck';
        
% Boost converter modeling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case MODE_BOOST
        C = 25e-6;
        L = 50e-6;
        R = 10; %(For DCM R=10)
        rs=1.8;
        rL=1000e-6;%change for different parameters
        cr=1.8;%Correction applied to duty ratio to cater losses
        
        Ac_nom = [-1*(rs+rL)/L, 0; 0, -(1/(R*C))];
        Bc_nom = [(1/L); 0];

        Ao_nom = [-rL/L, -(1/L); (1/C), -(1/(R*C))];
        Bo_nom = [(1/L); 0];
        
        Ad_nom = [0, 0; 0, -(1/(R*C))];%For DCM
        Bd_nom = [0; 0];%For DCM
        
        % switching period
        T = 0.00001;
        Tmax = T*140;
        
        % input (source) voltage
        Vs = 20;
        % desired output voltage
        Vref = 30;
        % duty cycle
        % Vs = Vo(1 - D), so Vs / Vo = 1 - D, Vs / Vo - 1 = -D, D = 1 - Vs / Vo, D = (Vo - Vs) / Vo
        D = cr*(Vref - Vs) / Vref;
        
        outname = 'boost';
        
   % BuckBoost converter modeling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case MODE_BUCKBOOST
        C = 6e-5;
        L = 4e-5;
        R = 10;% For DCM R=10
        rs=1.5;
        rL=900e-6;
        cr=1.28;%Correction applied to duty ratio to cater losses
        
        Ac_nom = [-1*(rs+rL)/L, 0; 0, -(1/(R*C))];
        Bc_nom = [(1/L); 0];

        Ao_nom = [-rL/L, -(1/L); (1/C), -(1/(R*C))];
        Bo_nom = [0; 0];
        
        Ad_nom = [0, 0; 0, -(1/(R*C))];%For DCM
        Bd_nom = [0; 0];%For DCM
        
        % switching period
        T = 4e-6;
        Tmax = T*500;
        
        % input (source) voltage
        Vs = 20;
        % desired output voltage
        Vref = 15;
        % duty cycle (boost if D > .5, buck if D < .5)
        % Vo = Vs D / (1 - D)
        % Vo / Vs = D / (1 - D)
        % (Vo / Vs) * (1 - D) = D
        % Vo/Vs - DVo/Vs = D
        % Vo/Vs = D(1 + Vo/Vs)
        % Vo/Vs / (1 + Vo/Vs) = D
        %D = Vref/Vs / (1 + Vref/Vs);
        D = cr*Vref/(cr*Vref + Vs);
        
        outname = 'buckboost';
    otherwise
        % error
        'Error'
end

Vtol = Vref / 200; % voltage ripple tolerance (+/- 0.5%)

if option_extrema
    sys = matrices_extrema(R,L,C);
else
    sys(1).Ac = Ac_nom;
    sys(1).Bc = Bc_nom;
    sys(1).Ao = Ao_nom;
    sys(1).Bo = Bo_nom;
    sys(1).Ad = Ad_nom;%For DCM
    sys(1).Bd = Bd_nom;%For DCM
    
    % set parameters used in stateflow simulation
    a00c = sys(1).Ac(1,1);
    a01c = sys(1).Ac(1,2);
    a10c = sys(1).Ac(2,1);
    a11c = sys(1).Ac(2,2);
    
    b0c = sys(1).Bc(1);
    b1c = sys(1).Bc(2);
    
    a00o = sys(1).Ao(1,1);
    a01o = sys(1).Ao(1,2);
    a10o = sys(1).Ao(2,1);
    a11o = sys(1).Ao(2,2);
    
    b0o = sys(1).Bo(1);
    b1o = sys(1).Bo(2);
    
    %DCM
    
    a00d = sys(1).Ad(1,1);
    a01d = sys(1).Ad(1,2);
    a10d = sys(1).Ad(2,1);
    a11d = sys(1).Ad(2,2);
    
    b0d = sys(1).Bd(1);
    b1d = sys(1).Bd(2);
    
end

Tmax = 100 * T;

% write spaceex file
write_spaceex(outname, 'buckboost', sys, length(sys), Tmax, T, D, Vs, i0, v0);

if option_sim
    %simulate the model
    [tout,yout]=sim('dc2dc_dcm');
    %plot the results
    figure
    plot(tout,yout(:,3),'b-','LineWidth',2);grid;
    xlabel('Time,Sec');ylabel('Capacitor Voltage, Volts');
    legend('Capacitor Voltage - Hybrid Automaton Stateflow')
    figure
    plot(tout,yout(:,2),'r-','LineWidth',2);grid;
    xlabel('Time,Sec');ylabel('Inductor Current, Amps');
    legend('Inductor Current - Hybrid Automaton Stateflow')
    figure
    plot(yout(:,2),yout(:,3),'g-','LineWidth',2);grid;
    xlabel('Inductor Current, Amps');ylabel('Capacitor Voltage, Volts');
end