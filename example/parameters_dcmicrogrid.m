% This mfile loads parameters for the DC microgrid
% Please refer to the block diagram for nomenclature of ODE parameters
clc
clear all

option_sim = 0  % select this option if you want to automatically simulate
% the model and plot the results
Fs = 60000;

% Load parameters for converter # 1
R1 = 20; %load resistance (Ohms)
L1 = 2.65e-3; %inductance (Henry)
C1 = 2.2e-3; %capacitance (Farad)
rL1 = 520e-3; % parasitic inductive resistance (Ohms)
rs1 = 200e-3; % switching loss (Ohms)
T1 = 1/60000; % Time period (seconds)

% Load parameters for converter # 2
R2 = 20;
L2 = 2.65e-3;
C2 = 2.2e-3;
rL2 = 520e-3;
rs2 = 200e-3;
T2 = 1/60000;

%load matrices and transfer function parameters
num1 = [0 1];%numerator of tf1 (for i_L)
den1 = [1/(0.5*2*pi*120) 1];%denominator of tf1
[a1,b1,c1,d1] = tf2ss(num1,den1);
num2 = [0 1];%numerator of tf2 (for v_C)
den2 = [1/(0.05*2*pi*Fs) 1];%denominator of tf2
[a2,b2,c2,d2] = tf2ss(num2,den2); 
num3 = [0 1];%numerator of tf of main control
den3 = [0.05 1];%denominator of tf of main control
[a3,b3,c3,d3] = tf2ss(num3,den3);

%Load matrices for dc microgrid
Vin = [100 100]; % DC input voltage vector
Vref = [48 48]; % reference voltage vector
Imax = [4 4]; % current rating vector for per unit current claculation
A = 25*[0 1;1 0]; %input for adjacency matrix
B = 1*A;
C = 0.5*A; % adjacency matrix for cooperative controller
RD = [0.00 0; 0 0.00]; % droop controller parameters; if 0 => not used
I = 3*[1 0; 0 1]; % I parameters for PI cooperative controller 
P = 0.05*[1 0; 0 1];% P parameters for PI cooperative controller
Pmc = 0.01; %P parameters for PI main controller
Imc = 1; %I parameters for PI main controller
% Calculate the equivalent parallel load for each converter
Req = R1*R2/(R1+R2); % the same load resistance is used in each converter
% Automatically calculate the ODE parameters for each converter
% converter 1
Vref1 = Vref(1);
Vin1 = Vin(1);

%% xi1 - Integrator of PI controller of the cooperative controller block
axi1 = C(1,2)*I(1,1)*c1/Imax(1);
%% xpi1 - Integrator of PI controller of the main controller block
a1xpi1 = Imc*c3;
a2xpi1 = Imc*c2;
%% Parameters for xmc1_dot
a1xmc1 = a3;
a2xmc1 = C(1,2)*P(1,1)*c1/Imax(1);
a3xmc1 = C(1,2)*P(1,1)*c1/Imax(1) + RD(1,1)*c1;
%% parameters of v1 - output for PI controller of the main control
a1v1 = Pmc*a1xpi1;
a2v1 = Pmc*a2xpi1;

% converter 2
Vref2 = Vref(2);
Vin2 = Vin(2);

%% xi2 - Integrator of PI controller of the cooperative controller block
axi2 = C(2,1)*I(2,2)*c1/Imax(2);
%% xpi2 - Integrator of PI controller of the main controller block
a1xpi2 = Imc*c3;
a2xpi2 = Imc*c2;
%% Parameters for xmc1_dot
a1xmc2 = a3;
a2xmc2 = C(2,1)*P(2,2)*c1/Imax(2);
a3xmc2 = C(1,2)*P(2,2)*c1/Imax(2) + RD(2,2)*c1;
%% parameters of v2 - output for PI controller of the main control
a1v2 = Pmc*a1xpi2;
a2v2 = Pmc*a2xpi2;

if option_sim
%simulate the model
[tout,yout] = sim('dc_microgrid2');

%plot results coverter # 1
figure
plot(tout,yout(:,3),'b-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('v_{C1}, Volts');
legend('Capacitor Voltage - Converter # 1','Location','SouthEast')
figure
plot(tout,yout(:,2),'r-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('i_{L1}, Amps');
legend('Inductor Current - Converter # 1')
figure
plot(yout(:,2),yout(:,3),'g-','LineWidth',2);grid;
xlabel('i_{L1}, Amps');ylabel('v_{C1}, Volts');
legend('Phase Plane Plot v_{C1} vs. i_{L1} - Converter # 1','Location','SouthEast');
%plot results coverter # 2
figure
plot(tout,yout(:,12),'b-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('v_{C2}, Volts');
legend('Capacitor Voltage - Converter # 2','Location','SouthEast')
figure
plot(tout,yout(:,10),'r-','LineWidth',2);grid;
xlabel('Time,Sec');ylabel('i_{L2}, Amps');
legend('Inductor Current - Converter # 2')
figure
plot(yout(:,10),yout(:,12),'g-','LineWidth',2);grid;
xlabel('i_{L1}, Amps');ylabel('v_{C1}, Volts');
legend('Phase Plane Plot v_{C2} vs. i_{L2} - Converter # 2','Location','SouthEast');
end