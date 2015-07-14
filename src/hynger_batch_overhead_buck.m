% create runtime data for buck converter example

clear all ; bdclose('all') ; clear all;

num_sim = 5;

iters = [1 : num_sim];
time_simulate = zeros(num_sim,1);
time_siminst = zeros(num_sim,1);
time_daikon = zeros(num_sim,1);
i_mdl = 1;
table_all = [''];

%for mdlname = {'buck_hvoltage_discrete', 'arch2014jin_AbstractFuelControl_M1_Aquino', 'arch2014jin_AbstractFuelControl_M2'}
%for mdlname = {'buck_hvoltage_discrete', 'staliro/heat25830_staliro_01', 'arch2014jin_AbstractFuelControl_M1_Aquino', 'arch2014jin_AbstractFuelControl_M2'}
%for mdlname = {'staliro/heat25830_staliro_01', 'arch2014jin_AbstractFuelControl_M1_Aquino', 'arch2014jin_AbstractFuelControl_M2'}
%for mdlname = {'arch2014jin_AbstractFuelControl_M1_Aquino', 'arch2014jin_AbstractFuelControl_M2','staliro/heat25830_staliro_01'}
for mdlname = {'arch2014jin_AbstractFuelControl_M2','staliro/heat25830_staliro_01'}
%for mdlname = {'buck_hvoltage_discrete'}
    mdlname = char(mdlname);
    i_opt = 1;
    for opt_mode = [1]%[1:2]%[0 : 1 : 2]
        for i = 1 : num_sim
            ['Starting iteration: ', num2str(i)]
            [time_simulate(i), time_siminst(i), time_daikon(i), models_all_count(i), models_inst_count(i)] = hynger(mdlname, 1, opt_mode);
        end

        % sum of instrumentation time and invariant inference time
        time_daikon_total = time_daikon + time_siminst;

        mean_time_simulate = mean(time_simulate);
        mean_time_siminst = mean(time_siminst);
        mean_time_daikon = mean(time_daikon);
        mean_time_daikon_total = mean(time_daikon_total);
        
        % this should be equal for a given opt_mode, just a sanity check
        mean_models_all = mean(models_all_count);
        mean_models_inst = mean(models_inst_count);
        pct_models = (mean_models_inst / mean_models_all) * 100;

        std_time_simulate = std(time_simulate);
        std_time_siminst = std(time_siminst);
        std_time_daikon = std(time_daikon);
        std_time_daikon_total = std(time_daikon_total);

        if 0
            figure;
            hold on;
            plot(iters, time_simulate, 'r-*');
            plot(iters, time_daikon_total, 'g-+');
            plot(iters, time_siminst, 'b-.+');
            plot(iters, time_daikon, 'c-.+');

            plot(iters, ones(num_sim)*mean_time_simulate, 'r:*');
            plot(iters, ones(num_sim)*mean_time_daikon_total, 'g:+');
            plot(iters, ones(num_sim)*mean_time_siminst, 'b:+');
            plot(iters, ones(num_sim)*mean_time_daikon, 'c:+');

            xlabel('Trial');
            ylabel('Runtime (s)');

            legend('Sim', 'SimInst + Inv', 'SimInst', 'Inv');
        end
        
        sim_start = eval(get_param(bdroot,'StartTime')); % use eval (could be symbolic)
        sim_stop = eval(get_param(bdroot,'StopTime'));
        sim_time = sim_stop - sim_start;
        pct_overhead = mean_time_daikon_total / mean_time_simulate; % overhead time

        % nearly latex table
        %result(i_mdl, i_opt).table = ['Model & Solver & Tmax ($s$) & Sim ($s$) & SimInst + Inv ($s$) & SimInst ($s$) & Inv ($s$) & Overhead ($\%$) & BDPct ($\%$) & BDInst ($\#$) & BDAll ($\#$)\\', char(10), ...
        result(i_mdl, i_opt).table = ['Model & Solver & Tmax & Sim & SimInst + Inv & SimInst & Inv & Overhead & BDInst & BDAll & BDPct\\', char(10), ...
        mdlname, ' & ', char(get_param(bdroot,'Solver')),' & $', num2str(sim_time), '$ & $', num2str(mean_time_simulate), '$ & $', num2str(mean_time_daikon_total), '$ & $', num2str(mean_time_siminst), '$ & $', num2str(mean_time_daikon), '$ & $', num2str(pct_overhead), '$ & $', num2str(mean_models_all), '$ & $', num2str(mean_models_inst), '$ & $', num2str(pct_models), '$ \\', char(10), ...
        %'Stdev: $', num2str(std_time_simulate), '$ & $', num2str(std_time_daikon_total), '$ & $', num2str(std_time_siminst), '$ & $', num2str(std_time_daikon), char(10)
        ]
    
        table_all = [table_all, result(i_mdl, i_opt).table];
        
        try
            [path,name,ext] = fileparts(mdlname); % needed for subdirectory models
            save([char(name), '_inst_mode=', num2str(opt_mode), '.mat']);
        catch
        end
        

        i_opt = i_opt + 1;
    end
    i_mdl = i_mdl + 1;
end

table_all