%Loads parameters for PLL SLSF Model
clc
clear all
%initial conditions
vi0 = 0.35; 
vp10 = 0;
vp0 = 0;
phiv0 = -0.4*2*pi;
phiref0 = 0;

%paprameter values
fref = 27e6;
f0 = 26.93e9;
N = 1000;
Ki = 200e6;
Kp = 25e6;
Ci = 25e-12;
Cp1 = 6.3e-12;
Cp3 = 2e-12;
Rp2 = 50e3;
Rp3 = 8e3;
td = 50e-12;
% input from the charge pump
Iiup = 10.1e-6;
Iidn = -10.1e-6;
Ipup = 505e-6;
Ipdn = -505e-6;
%bounds for voltages in terms of omega
omegail = 0;%lower bound for v_i
omegaiu = 0.7;%upper bound for v_i
omegapl = -4;%lower bound for v_p
omegapu = 12;%upper bound for v_p

%simulate the model
[tout,yout]=sim('pll2');

%plot the results
figure
plot(tout,yout(:,1),'b-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('Integral Input to VCO - V_i, Volts');
figure
plot(tout,yout(:,2),'b-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('Cap p1 Voltage - V_{p1}, Volts');
figure
plot(tout,yout(:,3),'b-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('Proportional Input to VCO - V_p, Volts');
figure
plot(tout,yout(:,4),'b-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('VCO Frequency - \phi_v, Radians');
legend('\phi_v - Hybrid Automaton Stateflow')
figure
plot(tout,yout(:,5),'r-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('Reference Frequency - Phi Ref, Radians');
legend('\phi_{ref} - Hybrid Automaton Stateflow')
figure
plot(yout(:,4),yout(:,5),'b-','LineWidth',2);grid;
xlabel('\phi_v, Radians');ylabel('\phi_{ref}, Radians');
figure
plot(tout,yout(:,4)-yout(:,5),'b-','LineWidth',2);grid;
xlabel('Time, Sec');ylabel('\phi_v - \phi_{ref}, Radians');
figure
plot(yout(:,1),(yout(:,4)-yout(:,5))/(2*pi),'b-','LineWidth',2);grid;
xlabel('V_i, Volts');ylabel('(\phi_v - \phi_{ref}) / 2*pi, Radians');
figure
plot(yout(:,3),(yout(:,4)-yout(:,5))/(2*pi),'b-','LineWidth',2);grid;
xlabel('V_p, Volts');ylabel('(\phi_v - \phi_{ref}) / 2*pi, Radians');
figure
plot(tout,(yout(:,4)-yout(:,5))/(2*pi),'b-','LineWidth',2);grid;
xlabel('Time, Sec');ylabel('(\phi_v - \phi_{ref}) / 2*pi, Radians');
figure
plot(yout(:,2),yout(:,3),'b-','LineWidth',2);grid;
xlabel('V_p1, Volts');ylabel('V_p, Volts');
figure
plot(yout(:,1),yout(:,2),'b-','LineWidth',2);grid;
xlabel('V_i, Volts');ylabel('V_p1, Volts');
