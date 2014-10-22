% base source: http://ecee.colorado.edu/~ecen5807/course_material/MATLAB/index.html

% Run file prior to executing simulink models

%clc; clear all; 

% concurrent execution idea:
% http://www.mathworks.com/help/simulink/ug/concurrent-execution-example.html


% TOTAL HARMONIC DISTORTION (THD) DEMO command line:
%power_RMS_THD


%sqrt(2)*120 = 169.7
%say 12 panels: 14.14V per panel
% grape solar panel: 17.7V at MPP and 5.70A

clear TswitchArray;

option_plots = 0;
option_parameter_variation = 0;

%Nmin = 5; % number of agents minimum required for system to remain operational
%N = 20; % number of agents (panels); TODO ;from external argument
%F = 2; % number of agents to fail

Fgrid = 60; % 60 Hz
Tgrid = (1 / Fgrid); % (seconds)

Tmax = 3*Tgrid; % max simulation time (seconds)

Vgridrms = 120; %120Vrms (volts)
Vgrid = (sqrt(2)*Vgridrms); %peak voltage (volts)
Vgridpp = Vgrid * 2; % peak-to-peak magnitude (volts)

Tsin = Tgrid / 1000; % TODO: divide by switching frequency?
Tthd = Tsin; % sampling time for THD analysis
Ts = Tthd;
ts = [0: Tsin : Tgrid];

% graphically determine switching times:
if option_plots
    figure; hold on;
    plot(ts,sin(2*pi*ts / Tgrid))
    for idx = 1 : N
        plot(ts,sin(2*pi*ts/Tgrid) >= (idx)/(N+1))
        plot(ts,sin(2*pi*ts/Tgrid) <= -(idx)/(N+1))
    end
end

Tmode = Tgrid / 4; % quarter period (high at T/4, zero at T/2, low at 3T/4, zero at T)
modes = 4; % zero out, positive out, zero out, negative out, repeat
%Tpanel = (Tgrid / N) / modes;
Tpanel = Tmode / N;

% time to pos
% time to zero
% time to neg
% for idx = 1 : N
%     %for m = 1 : modes
%         %Tswitch(idx,m) = (m-1)*Tmode + Tpanel*idx; % absolute switching times => convert to relative wait times in each mode
%     %end
%     Tswitch(idx,1) = Tpanel*idx; % absolute switching times => convert to relative wait times in each mode
%     Tswitch(idx,2) = (2-1)*Tmode;% + Tpanel*idx;
%     Tswitch(idx,3) = (2-1)*Tmode;% + Tpanel*idx;
%     Tswitch(idx,4) = (2-1)*Tmode;% + Tpanel*idx;
%     Tswitch(idx,5) = (2-1)*Tmode;% + Tpanel*idx;
% end

% hlevel = figure; hold on;
% figure; hold on;
% generate switching times for all
% all permutations of system sizes between 1 and N
for idxN = 2 : N
    for idx = 1 : idxN
        % idea: intersect (id number)/(number of panels) with a unit magnitude sinusoid to find switching times
        tpos = sin(2*pi*ts/Tgrid) >= (idx)/(idxN+1);
        tneg = sin(2*pi*ts/Tgrid) <= -(idx)/(idxN+1);
        %plot(hlevel,ts,tpos);
        %plot(hlevel,ts,tneg,'r');
        %tcross(idx,1) = 
        xpos = diff(tpos);
        %plot(ts,[xpos,0],'b');
        Tswitch(idx,1) = ts(find(xpos>0)); % zero
        %Tswitch(idx,2) = ts(find(xpos<0)) - Tswitch(idx,1);
        Tswitch(idx,2) = ts(find(xpos<0)) - ts(find(xpos>0)); % high
        xneg = diff(tneg);
        %plot(ts,[xneg,0],'r');

        %Tswitch(idx,3) = Tswitch(idx,2);


        %Tswitch(idx,3) = ts(find(xneg<0)) - Tswitch(idx,2);
        Tswitch(idx,3) = ts(find(xneg>0)) - ts(find(xpos<0)); % zero

        %Tswitch(idx,4) = Tswitch(idx,2);
        %Tswitch(idx,5) = Tswitch(idx,1);
        %Tswitch(idx,4) = ts(find(x>0)) - Tswitch(idx,3);

        Tswitch(idx,4) = ts(find(xneg<0)) - ts(find(xneg>0)); % low


        %Tswitch(idx,5) = Tswitch(idx,1);
        %Tswitch(idx,5) = Tgrid - Tswitch(idx,4);

        Tswitch(idx,5) = Tswitch(idx,1)*2; % zero period from negative zero, then again for positive zero
        
        
        
%         % NEW METHOD (some strange bug in latest try; the first half period is
%         % correct, but the second is not right yet)
%         %
%         Tswitch(idx,1) = (Tgrid / (2*pi)) * asin( idx / (idxN + 1));
%         Tswitch(idx,2) = (Tgrid / 2) - Tswitch(idx,1);
%         %(Tgrid / (2*pi)) * asin( idx / (idxN + 1));
%         %Tswitch(idx,3) = (Tgrid / (2*pi)) * asin( idx / (idxN + 1));
%         Tswitch(idx,3) = (Tgrid / 2) + Tswitch(idx,1);
%         Tswitch(idx,4) = (Tgrid / 2) + Tswitch(idx,1);
%         %(Tgrid / (2*pi)) * asin( idx / (idxN + 1));
%         %Tswitch(idx,4) = (Tgrid / (2*pi)) * asin( idx / (idxN + 1));
%         %Tswitch(idx,5) = (Tgrid / (2*pi)) * asin( idx / (idxN + 1));

        %Tswitch(idx,5) = Tgrid - (Tswitch(idx,1) + Tswitch(idx,2) + Tswitch(idx,3) + Tswitch(idx,4)) + Tswitch(idx,1);
        %Tswitch(idx,5) = Tswitch(idx,1);

        %Tswitch(idx,5) = Tswitch(idx,1);

        tmin(idx) = min(Tswitch(idx,:));
        ttotal(idx) = sum(Tswitch(idx,:));
        if tmin(idx) <= 0
            'Error, period too small'
            idx
        end

        %if ttotal(idx) > Tgrid
        %    'Error, period too large'
        %    idx
        %end

        %Tswitch(idx,5) = Tgrid - (Tswitch(idx,1) + Tswitch(idx,2) + Tswitch(idx,3) + Tswitch(idx,4));
        %Tswitch(idx,5) = Tgrid - Tswitch(idx,4);

        %for m = 1 : modes
            %Tswitch(idx,m) = (m-1)*Tmode + Tpanel*idx; % absolute switching times => convert to relative wait times in each mode
        %end
        %Tswitch(idx,1) = Tpanel*idx; % absolute switching times => convert to relative wait times in each mode
        %Tswitch(idx,2) = (2-1)*Tmode;% + Tpanel*idx;
        %Tswitch(idx,3) = (2-1)*Tmode;% + Tpanel*idx;
        %Tswitch(idx,4) = (2-1)*Tmode;% + Tpanel*idx;
        %Tswitch(idx,5) = (2-1)*Tmode;% + Tpanel*idx;
    end
    sys(idxN).Tswitch = Tswitch;
    % zero pad rows
    while sum(size(Tswitch) == [N,5]) < 2 && size(Tswitch,1) <= N
        Tswitch = [Tswitch; zeros(1,5)];
    end
    TswitchArray(:,:,idxN) = Tswitch;
end



% voltage source
% panel data sheet: http://www.grapesolar.com/files/3313/6673/6840/GS-Star-100W.pdf
Vs = 18.0; % from panel data sheet: voltage at maximum power point (assume MPPT)

Is = 5.56; % from panel data sheet at MPP

Ps = Vs * Is;

% voltage reference
Vref = Vgrid/N;









% from matrices.m
% usage: first, execute this file, matrices.m
% this generates SpaceEx input files and sets up parameters for simulation
% using the Simulink/StateFlow model dc2dc.slx

option_extrema = 0; % component variation; only supports buck converter for now

% converter types
MODE_BUCK = 1;
MODE_BOOST = 2;
MODE_BUCKBOOST = 3;

% selected converter to model
mode = MODE_BUCKBOOST;

% source voltage noise for stateflow simulation
%Vs_noise = Vs/100;
Vs_noise = 0;

% iterate over all N to changes parameter values
% TODO: refactor and put the buck/boost initialize in its own function
for idx = 1 : N

    switch mode
        case MODE_BUCK
            C = 25e-6; % capacitor value

            L = 50e-6; % inductor

            R = 1; % resistor

            Ac_nom = [0, -(1/L); (1/C), -(1/(R*C))];
            Bc_nom = [(1/L); 0];

            Ao_nom = [0, -(1/L); (1/C), -(1/(R*C))];
            Bo_nom = [0; 0];

            % switching period
            T = 0.00001;

            % input (source) voltage
            Vs = 12;
            % desired output voltage
            Vref = 5;
            % duty cycle
            D = Vref / Vs;

            % max simulation time (spaceex uses shorter time by default)
            %Tmax = T*2500;

            % output filename
            outname = 'buck';
        case MODE_BOOST
            C = 25e-6;
            if option_parameter_variation
                Ctol = 0.05;
                Clow = C * (1 - Ctol);
                Chigh = C * (1 + Ctol);
                % uniform random within tolerances
                C = Clow + (Chigh - Clow) .* rand(1,1);
            end

            L = 50e-6;
            if option_parameter_variation
                Ltol = 0.05;
                Llow = L * (1 - Ltol);
                Lhigh = L * (1 + Ltol);
                % uniform random within tolerances
                L = Llow + (Lhigh - Llow) .* rand(1,1);
            end

            R = 1;
            if option_parameter_variation
                Rtol = 0.05;
                Rlow = R * (1 - Rtol);
                Rhigh = R * (1 + Rtol);
                % uniform random within tolerances
                R = Rlow + (Rhigh - Rlow) .* rand(1,1);
            end

            Ac_nom = [0, 0; 0, -(1/(R*C))];
            Bc_nom = [(1/L); 0];

            Ao_nom = [0, -(1/L); (1/C), -(1/(R*C))];
            Bo_nom = [(1/L); 0];

            % switching period
            T = 0.00001;
            %Tmax = T*500;

            % input (source) voltage
            %Vs = 20; % defined above
            % desired output voltage
            Vref = 30;
            % duty cycle
            % Vs = Vo(1 - D), so Vs / Vo = 1 - D, Vs / Vo - 1 = -D, D = 1 - Vs / Vo, D = (Vo - Vs) / Vo
            D = (Vref - Vs) / Vref;

            outname = 'boost';
        case MODE_BUCKBOOST

             %C = [5,7]e-5;  L = 4e-5; R = 4; with Fsw = 250khz(or T = 4e-6)


            C = 6e-5; % was 5
            Ctol = 0.05;
            Clow = C * (1 - Ctol);
            Chigh = C * (1 + Ctol);
            % uniform random within tolerances
            agent(idx).C = Clow + (Chigh - Clow) .* rand(1,1);

            %L = 1e-5;
            L = 4e-5;
            Ltol = 0.05;
            Llow = L * (1 - Ltol);
            Lhigh = L * (1 + Ltol);
            % uniform random within tolerances
            agent(idx).L = Llow + (Lhigh - Llow) .* rand(1,1);

            %R = 3.24;
            R = 4;
            Rtol = 0.05;
            Rlow = R * (1 - Rtol);
            Rhigh = R * (1 + Rtol);
            % uniform random within tolerances
            agent(idx).R = Rlow + (Rhigh - Rlow) .* rand(1,1);

            agent(idx).Ac_nom = [0, 0; 0, -(1/(agent(idx).R*agent(idx).C))];
            agent(idx).Bc_nom = [(1/agent(idx).L); 0];

            agent(idx).Ao_nom = [0, -(1/agent(idx).L); (1/agent(idx).C), -(1/(agent(idx).R*agent(idx).C))];
            agent(idx).Bo_nom = [0; 0];

            agent(idx).Ad_nom = [0, 0; 0, -(1/(agent(idx).R*agent(idx).C))];
            agent(idx).Bd_nom = [0; 0];

            % switching period
            %T = 10e-6;
            T = 4e-6;
            agent(idx).T = 4e-6;
            %Tmax = T*1000;

            % input (source) voltage
            %Vs = 20; % defined above
            % desired output voltage
            %Vref = 14.2; % DEFINE ABOVE
            % duty cycle (boost if D > .5, buck if D < .5)
            % Vo = Vs D / (1 - D)
            % Vo / Vs = D / (1 - D)
            % (Vo / Vs) * (1 - D) = D
            % Vo/Vs - DVo/Vs = D
            % Vo/Vs = D(1 + Vo/Vs)
            % Vo/Vs / (1 + Vo/Vs) = D
            %D = Vref/Vs / (1 + Vref/Vs);
            agent(idx).D = Vref/(Vref + Vs);

            outname = 'buckboost';
        otherwise
            % error
            'Error'
    end


    if option_extrema
        sys = matrices_extrema(R,L,C);
    else
        agent(idx).sys(1).Ac = agent(idx).Ac_nom;
        agent(idx).sys(1).Bc = agent(idx).Bc_nom;
        agent(idx).sys(1).Ao = agent(idx).Ao_nom;
        agent(idx).sys(1).Bo = agent(idx).Bo_nom;
        agent(idx).sys(1).Ad = agent(idx).Ad_nom;
        agent(idx).sys(1).Bd = agent(idx).Bd_nom;

        % set parameters used in stateflow simulation
        agent(idx).a00c = agent(idx).sys(1).Ac(1,1);
        agent(idx).a01c = agent(idx).sys(1).Ac(1,2);
        agent(idx).a10c = agent(idx).sys(1).Ac(2,1);
        agent(idx).a11c = agent(idx).sys(1).Ac(2,2);

        agent(idx).b0c = agent(idx).sys(1).Bc(1);
        agent(idx).b1c = agent(idx).sys(1).Bc(2);

        agent(idx).a00o = agent(idx).sys(1).Ao(1,1);
        agent(idx).a01o = agent(idx).sys(1).Ao(1,2);
        agent(idx).a10o = agent(idx).sys(1).Ao(2,1);
        agent(idx).a11o = agent(idx).sys(1).Ao(2,2);

        agent(idx).b0o = agent(idx).sys(1).Bd(1);
        agent(idx).b1o = agent(idx).sys(1).Bd(2);
               
        agent(idx).a00d = agent(idx).sys(1).Ad(1,1);
        agent(idx).a01d = agent(idx).sys(1).Ad(1,2);
        agent(idx).a10d = agent(idx).sys(1).Ad(2,1);
        agent(idx).a11d = agent(idx).sys(1).Ad(2,2);

        agent(idx).b0d = agent(idx).sys(1).Bd(1);
        agent(idx).b1d = agent(idx).sys(1).Bd(2);
    end
end

% write spaceex file
%write_spaceex(outname, 'buckboost', sys, length(sys), T, D, Vs);



fswitch = 1/T;











% controller gains
p1 = 1/(2*pi*1e6);
p2 = 1/(2*pi*33e3);
p3 = 1/(2*pi*300e3);
p4 = 1/(2*pi*8e3);
p5 = 1/(2*pi*8e3);
g = 5.45;

% initial condition
x0 = [0;1.8;0;0;0]; % near steady-state
%x0 = [0;0;0;0;0];  % start up

% controller linear system model A matrix
Ac = [-1/p1, 0, 0;
      (-p2/(p1*p3) + (1/p3)), -1/p3, 0;
      ((-p2*p4/(p1*p3*p5))+(p4/(p3*p5))), ((-p4/(p3*p5))+(1/p5)), 0];

%Ac = [0 0 0;
%      0 0 0; 
%      ((-p2*p4/(p1*p3*p5))+(p4/(p3*p5))) ((-p4/(p3*p5))+(1/p5)) 0];

% controller linear system model B vector
Bc = [1/p1; p2/(p1*p3); (p4*p2)/(p1*p3*p5)];
%Bc = [0; 0; (p4*p2)/(p1*p3*p5)];

% controller output
Cc = [0 0 1]*g;

% no feedforward
Dc = 0;

% capacitor value
C = 200e-6;

% inductor value
L = 1e-6;

RL = 10e-3; % inductor resistance
Resr = 0.8e-3; % capacitor effective series resistance (esr)
RC = Resr;

R = 1;

% buck-converter model (mode 1, switch closed)
A1_nom = [0, -(1/L); (1/C), -(1/(R*C))];
B1_nom = [(1/L); 0];

% buck-converter model (mode 2, switch open)
A2_nom = [0, -(1/L); (1/C), -(1/(R*C))];
B2_nom = [0; 0];

i0 = 0; % initial inductor current
v0 = 1.8; % initial capacitor voltage

% TODO: define below too
%fswitch = 1e6; % switching frequency

% fewer switches (too slow)
%fs = 1e4;

%Ts = 1/fs; % switching period (cannot be named Ts due to THD block bug)
%Tsw = 1/fswitch;

Ron1 = 20e-3; % transistor on switch
Ron2 = 20e-3; % sync rectifier switch


R0 = 1;

a1 = 0;
a2 = (1/C);
a3 = -(1/L);
a4 = -(1/(R*C));

% with non-ideal
%a1 = -(1/L) * (RL * RC + RL * R0 + RC * R0) / (RC + R0);
%a3 = -(1/L);

%a2 = (1/C) * ( R0 ) / (R0 + RC);
%a4 = -(1/C) * (1) / (R0 + RC);

b1 = 1/p1;
b2 = p2/(p1*p3);
b3 = p4*p2/(p1*p3*p5);

A1simple = [a1,                               a3,       0,                  0,                              0                  ;
            a2,                               a4,       0,                  0,                              0                  ;
            0,                                -b1,               -1/p1,                          0,        0          ;
            0,                                -b2,       -p2/(p1*p3) + (1/p3),           -1/p3,           0   ;
            0,                                -b3,   -p2*p4/(p1*p3*p5) + p4/(p3*p5), -p4/(p3*p5) + 1/p5, 0];
        
A1simpleTime = [a1,                               a3,       0,                  0,                              0, 0, 0                  ;
            a2,                               a4,       0,                  0,                              0, 0, 0                  ;
            0,                                -b1,               -1/p1,                          0,        0, 0, 0          ;
            0,                                -b2,       -p2/(p1*p3) + (1/p3),           -1/p3,           0, 0, 0   ;
            0,                                -b3,   -p2*p4/(p1*p3*p5) + p4/(p3*p5), -p4/(p3*p5) + 1/p5, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0];

B1top = [1/L; 0];
B1bot = [Vref*b1; Vref*b2; Vref*b3]; % without voltage source or voltage reference (multiplied in inside model)
B1 = [B1top; B1bot];
%B1 = [Vs/L; 0; Vref*b1; Vref*b2; Vref*b3];
        
B1Time = [Vs/L; 0; Vref*b1; Vref*b2; Vref*b3; 1; fswitch];

% % composed linear system model (buck converter and linear system feedback controller)
% % TODO: there's a bug here, I don't think I created an appropriate error term when making the full model; we can discuss
% a1 = ((-1/L)*(R*RL + R*RC + RC*RL)/(R + RC));
% a2 = (1/C)*(R/(R+RC));
% a3 = (-1/L)*(R/(R + RC));
% a4 = (-1/C)*(1/(R+RC));
%         
% A1 = [a1,                               a3,                             0,                  0,                              0,                  0;
%       a2,                               a4,                             0,                  0,                              0,                  0;
%       -(a1*(R*RC)/(R+RC) + a2*R/(R+RC)),   -(a3*(R*RC)/(R+RC) + a4*(R/R+RC)), 0,                  0,                              0,                  0; % added - sign from e = vref - vout, and note derivative of vref = 0
%       0,                                0,                              1/p1,               -1/p1,                          0,                  0;
%       0,                                0,                              p2/(p1*p3),         -p2/(p1*p3) + (1/p3),           -1/p3,              0;
%       0,                                0,                              p4*p2/(p1*p3*p5),   -p2*p4/(p1*p3*p5) + p4/(p3*p5), -p4/(p3*p5) + 1/p5, 0];
% A2 = A1;
% B1 = [Vs/L; 0; a1*(R*RC)/(R+RC)*(Vs/L); 0; 0; 0];
B2 = [0; 0; Vref*b1; Vref*b2; Vref*b3];
B2Time = [0; 0; Vref*b1; Vref*b2; Vref*b3; 1; fswitch];


syms il vc x3 x4 x5 x6 gt t ;
x = [il; vc; x3; x4; x5];
xTime = [il; vc; x3; x4; x5; gt; t];

digits(10);
vpa(A1simple * x + B1);


vpa(A1simple * x + B2);

vpa(A1simpleTime * xTime + B1Time);


vpa(A1simpleTime * xTime + B2Time);

% it may help to simulate the system, this is a first-pass but needs to be completed (particularly with regard to switching, i.e., this is a linear system simulator, not a switched-system simulator, have to do something extra)
%m1 = ss(A1,B1,[0;1;0;0;0;0]',[])
%x0 = initial(m1,[i0;v0;0;0;0;0]);

%t = 0:0.01:5;

%lsim(m1,[],t)

























Tstartup = 3e-3; % seconds: time delay for buck/boost converters to settle to around desired output voltage



Tmax = Tmax + Tstartup; % add on startup time








for idx = 1 : N
    %agent(idx).Tswitch = Tswitch(idx); % copy twswitch
    Carray(idx) = agent(idx).C;
    Larray(idx) = agent(idx).L;
    Rarray(idx) = agent(idx).R;
    Darray(idx) = agent(idx).D; % start all the same
    Acarray(:,:,idx) = agent(idx).Ac_nom;
    Bcarray(:,idx) = agent(idx).Bc_nom;
    Aoarray(:,:,idx) = agent(idx).Ao_nom;
    Boarray(:,idx) = agent(idx).Bo_nom;
    Adarray(:,:,idx) = agent(idx).Ad_nom;
    Bdarray(:,idx) = agent(idx).Bd_nom;
    agent(idx).failed = 0; % is agent failed or not?
end


clear Tswitch; % should not be used, only TswitchArray should be used


