% This mfile loads parameters for the DC microgrid
% Please refer to the block diagram for nomenclature of ODE parameters
clc
clear all


% TODO: Omar, everything here should be parameterized on N, i.e. you should
% be using vectors and matrices for everything, such as R(1), R(2), etc.,
% then use the appropriate vector in the Stateflow part by having a second
% input to the block with the ID, i.e., converter 1 would have a constant 1
% input and converter 2 would have a constant 2 input, which would be an
% input variable called say id, then everything in the Stateflow model
% would reference R(id), etc. The way it's set up now would make it very
% hard to add additional converters, and would make it impossible to
% programmatically add more converters (e.g., to accept a value for N from a
% user and create the corresponding composition of N converters)
%
% Additionally, each converter should be a referenced submodel or a
% subsystem, as the way it is now, you have to manually modify everything if you make a change in one agent model.
%
% Go look at the solar array model again to see how this can be done, as the way this is set up now, the modeling is super ugly and hard to modify anything without wasting a lot of time: https://bitbucket.org/verivital/solar
% 

option_sim = 0  % set this option = 1 if you want to automatically simulate
% the model and plot the results

% scenario: 0 = startup, 1 = steady state
opt_scenario = 1;

Fs = 15000; % control frequency, hertz

% Load parameters for converter # 1
R1 = 20; %load resistance (Ohms)
L1 = 2.65e-3; %inductance (Henry)
C1 = 2.2e-3; %capacitance (Farad)
rL1 = 520e-3; % parasitic inductive resistance (Ohms)
rs1 = 200e-3; % switching loss (Ohms)
T1 = 1/Fs; % Time period (seconds)

% Load parameters for converter # 2
R2 = 20;
L2 = 2.65e-3;
C2 = 2.2e-3;
rL2 = 520e-3;
rs2 = 200e-3;
T2 = 1/Fs;

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
axi1 = C(1,2)*I(1,1)*c1/Imax(1); %Considering Imax(1) = Imax(2); This may change for different ratings of the converters
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

% initial conditions
% startup
if opt_scenario == 0
	Tmax = 2;
	
	% attack parameters
	time_attack = 0.8;
	attack_amplitude = 0.8; %volts
	attack_frequency = 60; %hertz
	
	t_0 = 0;
	iL1_0 = 0;
	vC1_0 = 0;
	xpu1_0 = 0;
	xi1_0 = 0;
	xmc1_0 = 0;
	xvo1_0 = 0;
	xpi1_0 = 0;

	iL2_0 = 0;
	vC2_0 = 0;
	xpu2_0 = 0;
	xi2_0 = 0;
	xmc2_0 = 0;
	xvo2_0 = 0;
	xpi2_0 = 0;
% steady state
elseif opt_scenario == 1
	Tmax = 0.05;%0.25
	
	% attack parameters
	time_attack = 0.6;
	attack_amplitude = 0.8; %volts
	attack_frequency = 60; %hertz
	
	t_0 = 0;
	iL1_0 = 4.5;
	vC1_0 = 48.02;
	xpu1_0 = 0.01275;
	xi1_0 = 0.01915;
	xmc1_0 = 2.401;
	xvo1_0 = 0.0103;
	xpi1_0 = 0.51;
	iL2_0 = 4.5;
	vC2_0 = 48.02;
	xpu2_0 = 0.01275;
	xi2_0 = 0.01915;
	xmc2_0 = 2.401;
	xvo2_0 = 0.0103;
	xpi2_0 = 0.51;
end

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