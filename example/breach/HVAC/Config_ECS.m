clear all;
load('Optimal_Parameters_2.mat');

M8=x(1);
Mw1=x(2);
Mw2=x(3);
Mw3=x(4);
Mw4=x(5);
Rvalw=x(6);
Rvalgl=x(7);
Rvalin=x(8);
Rvalout=x(9);

tau=0.5;                                % tau=0.5 is the transmittance of glass    
alpha= 0.2;                             % alpha=0.2 is the absoprtivity of wall 2  
Qtrans= (H*L2*beta2) * tau * Qsun;      %WE Assume Qdot only radiates on wall 2
Qabs=(H*L2*(1-beta2)) * alpha * Qsun;     %WE Assume Qdot only radiates on wall 2

Rin1=Rvalin/(H*L1*(1-beta1));     Rin3=Rvalin/(H*L1*(1-beta3));         %R for inside air on wall 1 & 3
Rin2=Rvalin/(H*L2*(1-beta2));     Rin4=Rvalin/(H*L2*(1-beta4));         %R for inside air on wall 2 & 4
Rw1=Rvalw/(H*L1*(1-beta1));       Rw3=Rvalw/(H*L1*(1-beta3));           %R for wall # 1 & 3
Rw2=Rvalw/(H*L2*(1-beta2));       Rw4=Rvalw/(H*L2*(1-beta4));           %R for wall # 2 & 4
Rout1=Rvalout/(H*L1*(1-beta1));   Rout3=Rvalout/(H*L1*(1-beta3));       %R for ouside air on wall 1 & 3
Rout2=Rvalout/(H*L2*(1-beta2));   Rout4=Rvalout/(H*L2*(1-beta4));       %R for outside air on wall 2 & 4
Rwin2tot=(Rvalin+Rvalgl+Rvalout)/(H*L2*beta2);                          %R total for windows section of wall 2
Rwin3tot=(Rvalin+Rvalgl+Rvalout)/(H*L1*beta3);

%% Compute corresponding gains


%% for walls
kextN= 1/(0.5*Rw1+Rout1)*1/(Mw1*cpw)*1/60;
kintN= 1/(0.5*Rw1+Rin1)*1/(Mw1*cpw)*1/60;

kextE= 1/(0.5*Rw2+Rout2)*1/(Mw2*cpw)*1/60;
kintE= 1/(0.5*Rw2+Rin2)*1/(Mw2*cpw)*1/60;

kextS= 1/(0.5*Rw3+Rout3)*1/(Mw3*cpw)*1/60;
kintS= 1/(0.5*Rw3+Rin3)*1/(Mw3*cpw)*1/60;

kextW= 1/(0.5*Rw4+Rout4)*1/(Mw4*cpw)*1/60;
kintW= 1/(0.5*Rw4+Rin4)*1/(Mw4*cpw)*1/60;
 
ku= 1/(M8*cp);

%% for the room

kN = 1/(0.5*Rw1+Rin1)*1/60*1/(M8*cp);
kE = 1/(0.5*Rw2+Rin2)*1/60*1/(M8*cp);
kS = 1/(0.5*Rw3+Rin3)*1/60*1/(M8*cp);
kW = 1/(0.5*Rw4+Rin4)*1/60*1/(M8*cp);

N = 1440;
