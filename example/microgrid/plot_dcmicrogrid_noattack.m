
% Author: Omar Ali Beg;
% plots results for DC Microgrid when there is no attack in single row, three columns
%clc
%clear all
%load stateflow data
% load buck_stateflow.mat; %  and zero initial conditions
%load data_dcmicrogrid_noattack_Tmax2; %  experiment initial conditions
% load data_dcmicrogrid_noattack;%for Tmax = 0.4

idx_iL1 = 1;
idx_vC1 = 2; 
idx_iL2 = 4;
idx_vC2 = 5;

% other scope block
idx_xpu1 = 3;
idx_xpu2 = 6;


subplot('Position', [0.123, 0.2, 0.22, 0.74]); % [left bottom width height]
plot(ScopeData.time,ScopeData.signals(idx_iL1).values,'b','LineWidth',2);
axis tight;grid;
xlabel('Time, Sec','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
ylabel('i_{L1}, A','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
% title('i_L : Comaprison');
set(gca,'FontSize',20,'LineWidth',2);%'FontWeight','bold',

subplot('Position', [0.432, 0.2, 0.22, 0.74]);
plot(ScopeData.time,ScopeData.signals(idx_vC1).values,'b','LineWidth',2);axis tight;grid;
xlabel('Time, Sec','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
ylabel('v_{C1}, V','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
set(gca,'FontSize',20,'LineWidth',2);%'FontWeight','bold',

subplot('Position', [0.742, 0.2, 0.22, 0.74]);
plot(ScopeData.time,ScopeData.signals(idx_xpu1).values,'b','LineWidth',2);axis tight;grid;
xlabel('Time, Sec','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
ylabel('x_{pu1}','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
% legend('Stateflow','PLECS', 'Experiment','SpaceEx','Location',[0.63 0.3 0.3 0.3]); % ['x coordinate' 'y coordinate' 'width' 'height']
set(gca,'FontSize',20,'LineWidth',2);%'FontWeight','bold',

% automatically place label (a), (b), (c), etc.

ax1 = axes('Position',[0.12 -0.02 0.4 0.1],'Visible','off');% for text
ax2 = axes('Position',[0.41 -0.02 0.4 0.1],'Visible','off');% [left, bottom, width, height]
ax3 = axes('Position',[0.72 -0.02 0.4 0.1],'Visible','off');

descr1 = {'(a)  Agent1 Current vs. time'};
descr2 = {'(b)  Agent1 Voltage vs. time'};
descr3 = {'(c)  Agent1 x_{pu1} vs. time'};
axes(ax1); % sets ax1 to current axes
text(.025,0.6,descr1, 'FontSize', 16);
axes(ax2); % sets ax2 to current axes
text(.025,0.6,descr2, 'FontSize', 16);
axes(ax3); % sets ax2 to current axes
text(.025,0.6,descr3, 'FontSize', 16);

% end text label placement

%Another script to generate pdf file as per required dimensions
% re-adjust legend to center by manaullay dragging it to the desired position

% plot figure for DC-DC converter # 2
set(gcf, 'PaperUnits', 'inches');
x_width=15.5 ;y_width=5.5;% Figure size
set(gcf,'PaperSize',[14.0 5.5]);
set(gcf, 'PaperPosition', [-1.0 0 x_width y_width]); % set position on paper
saveas(gcf,'dcmicrogrid_noattack_steadystate_agent1.pdf')

%clf % clears current figure and plots the figure for agent 1
figure;

subplot('Position', [0.123, 0.2, 0.22, 0.74]); % [left bottom width height]
plot(ScopeData.time,ScopeData.signals(idx_iL2).values,'b','LineWidth',2);
axis tight;grid;
xlabel('Time, Sec','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
ylabel('i_{L2}, A','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
% title('i_L : Comaprison');
set(gca,'FontSize',20,'LineWidth',2);%'FontWeight','bold',

subplot('Position', [0.432, 0.2, 0.22, 0.74]);
plot(ScopeData.time,ScopeData.signals(idx_vC2).values,'b','LineWidth',2);axis tight;grid;
xlabel('Time, Sec','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
ylabel('v_{C2}, V','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
set(gca,'FontSize',20,'LineWidth',2);%'FontWeight','bold',

subplot('Position', [0.742, 0.2, 0.22, 0.74]);
plot(ScopeData.time,ScopeData.signals(idx_xpu2).values,'b','LineWidth',2);axis tight;grid;hold on;
xlabel('Time, Sec','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
ylabel('x_{pu2}','FontSize',20);%,'LineWidth',2)'FontWeight','bold',
% legend('Stateflow','PLECS', 'Experiment','SpaceEx','Location',[0.63 0.3 0.3 0.3]); % ['x coordinate' 'y coordinate' 'width' 'height']
set(gca,'FontSize',20,'LineWidth',2);%'FontWeight','bold',

% automatically place label (a), (b), (c), etc.

ax1 = axes('Position',[0.12 -0.02 0.4 0.1],'Visible','off');% for text
ax2 = axes('Position',[0.41 -0.02 0.4 0.1],'Visible','off');% [left, bottom, width, height]
ax3 = axes('Position',[0.72 -0.02 0.4 0.1],'Visible','off');

descr1 = {'(a)  Agent2 Current vs. time'};
descr2 = {'(b)  Agent2 Voltage vs. time'};
descr3 = {'(c)  Agent2 x_{pu2} vs. time'};
axes(ax1); % sets ax1 to current axes
text(.025,0.6,descr1, 'FontSize', 16);
axes(ax2); % sets ax2 to current axes
text(.025,0.6,descr2, 'FontSize', 16);
axes(ax3); % sets ax2 to current axes
text(.025,0.6,descr3, 'FontSize', 16);

% end text label placement

%Another script to generate pdf file as per required dimensions
% re-adjust legend to center by manaullay dragging it to the desired position

% plot figure for DC-DC converter # 2
set(gcf, 'PaperUnits', 'inches');
x_width=15.5 ;y_width=5.5;% Figure size
set(gcf,'PaperSize',[14.0 5.5]);
set(gcf, 'PaperPosition', [-1.0 0 x_width y_width]); % set position on paper
saveas(gcf,'dcmicrogrid_noattack_steadystate_agent2.pdf')

