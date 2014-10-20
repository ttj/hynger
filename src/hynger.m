% HYbrid iNvariant GEneratoR: instruments Simulink/Stateflow blocks to
% produce traces for Daikon in the correct format
%
% model_filename: name of an example in ../example/
% opt_process_traces: 0 = do not call trace analyzer automatically, 1 = call trace analyzer automatically
%
% example calls:
% 1)
% hynger('buck_hvoltage_discrete', 1)
% Calls hynger on model buck_hvoltage_discrete and processes traces
%
%
%
% %model_filename = 'pendulum';
% %model_filename = 'buck_hvoltage';
% model_filename = 'buck_hvoltage_discrete';
% %model_filename = 'heaterLygeros';
% 
% 
% %model_filename = 'arch2014jin_AbstractFuelControl_M1_Aquino';
% %model_filename = 'arch2014jin_AbstractFuelControl_M2';
% 
% % examples from staliro
% %model_filename = 'staliro/heat25830_staliro_01';
% %model_filename = 'heat25830_staliro_01';
% 
% %model_filename = 'slexAircraftPitchControlExample';
%
function [time_simulate, time_siminst, time_daikon] = hynger(model_filename, opt_process_traces)
    tic; % start runtime measurements

    javaaddpath(['.', filesep, '..', filesep, 'lib', filesep, 'daikon.jar']);
    import  daikon.Runtime.dtrace.*;
    %import daikon.Daikon;
    %import daikon.*;
    %import daikon.derive.*;
    %import daikon.derive.binary.*;

    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_output iotype_input;

    daikon_dtrace_open = 0;
    
    opt_benchmark = 1; % enable benchmarking mode to compare simulation times with and without instrumentation
    opt_blacklist = 0; % blacklist = 1 means ignore only some block types, blacklist = 0 means whitelist mode and add only some block types
    opt_dataflow = 1; % 
    opt_time = 1; % 1 = include time variable, 0 = do not
    opt_multi = 0; % 1 = create multiple Daikon trace files, 0 = create a single large trace file over the entire simulation
    opt_trivial_example = 0; % first trivial example to test Daikon Java library loading (to delete)

    iotype_input = 1;
    iotype_output = 2;

    if opt_trivial_example
        daikon.Runtime.dtrace.println();
        daikon.Runtime.dtrace.println();
        daikon.Runtime.dtrace.println('test');
        return
    end
    
    model_filepath = ['..', filesep, 'example', filesep, model_filename];
    %model_filepath = ['..', filesep, 'example', filesep, 'staliro', filesep, model_filename];
    
    try
        % stop simulation in case started from previous run or by user (avoids error)
        set_param(bdroot,'SimulationCommand','stop');
        close_system(model_filepath);
    catch
    end
    
    open_system(model_filepath);
    
    % simulate diagram without instrumentation and record time
    if opt_benchmark
        time_simulate_start = toc;
        while ~strcmp(get_param(bdroot,'SimulationStatus'), 'stopped')
            pause(0.01);
        end

        set_param(bdroot,'SimulationCommand','start');

        % wait here until simulation done
        % TODO: convert this wait into an appropriate event handelr function that
        % gets called when the simulation stops to shut things down
        % TODO: but this shutdown will need to know extra information, such as
        % daikon tracing is on, etc. (e.g., check the bit like
        % daikon.Runtime.no_dtrace is false, which implies there is a dtrace open)
        while ~strcmp(get_param(bdroot,'SimulationStatus'), 'stopped')
            pause(0.01);
        end
        time_simulate_stop = toc;
        time_simulate = time_simulate_stop - time_simulate_start;
        ['Simulation time without instrumentation: ', num2str(time_simulate)]
    end

    % ways to find all variables defined in a simulink object (so we can
    % instrument the simulink diagram automatically using appropriate event /
    % time advance listeners)

    %all_base_vars = Simulink.WorkspaceVar(who, 'base workspace'); % deprecated
    all_base_vars = Simulink.VariableUsage(who, 'base workspace');

    count = 0;
    
    models_block = {};

    models_all = find_system(model_filename); % note: model must be opened
   
    % filter out constants, etc., or maybe just blocks that have only output or
    % input, but not both?
    for i_model = 1 : length(models_all)
        model_block = char(models_all(i_model));

        % ignore blacklist blocks or only add whitelisted blocks
        try
            if (opt_blacklist && ~block_ignore_instrumentation(model_block)) || (~opt_blacklist && block_whitelist_instrumentation(model_block))        
                    input_names = get_param(model_block, 'InputSignalNames');
                    output_names = get_param(model_block, 'OutputSignalNames');

                    % output
                    if length(output_names) > 0 || length(input_names) > 0
                    % input and output
                    %if length(input_names) > 0 && length(output_names) > 0
                        %models_block = cat(1,models_block,cellstr(model_block));
                        models_block = cat(1,models_block,model_block);
                    end
            end
        catch
        end
        
    end
    
    ['Block count in diagram: ', num2str(length(models_all))]
    models_all
    ['Blocks instrumented in diagram: ', num2str(length(models_block))]
    models_block
    ['Percentage blocks instrumented: ', num2str(length(models_block)) / length(models_all)]

    daikon_dtrace_blocks = length(models_block);

    % get all variables for a given block
    base_vars = Simulink.findVars(model_filename, 'WorkspaceType','base');

    i_model_bad = 0;
    i_model = 1;
    % iterate through every block and get all their variables
    for i_model = 1 : length(models_block)
        model_block = char(models_block(i_model));
        %model_path = [model_filename, '/', model_block];
        model_path = model_block;
        %model_ref = find_system(model_path);

        try
            block_data(i_model - i_model_bad).vars = Simulink.findVars(model_path, 'WorkSpaceType', 'base');
        catch
            'error'
            i_model_bad = i_model_bad + 1;
        end
        i_model = i_model + 1;
    end

    % start simulation and pause (so we can use runtime listeners)

    blk_root = model_filename;

    set_param(bdroot,'SimulationCommand','start');
    set_param(bdroot,'SimulationCommand','pause');

    while ~strcmp(get_param(bdroot,'SimulationStatus'), 'paused')
        pause(0.01);
    end

    if ~opt_multi
        output_filename = ['output_', model_filename, '.dtrace'];
        who
        daikon_dtrace_startup(output_filename);
    end

    %rto = get_param(gcb,'RuntimeObject');

    for i_model = 1 : length(models_block)
        model_block = models_block(i_model);
        %model_block = char(models_block(i_model));
        %blk = [blk_root, '/', char(model_block)];

        blk = model_block;
            % add callback to log data during execution (potentially at every
            % simulation time step)
            % see: http://www.mathworks.com/help/simulink/slref/add_exec_event_listener.html
        if opt_multi
            % NOTE: this must be assigned to unique objects, otherwise the
            % callback will not be set properly (e.g., it may always be the
            % last block set instead of all blocks)
            h_pre(i_model) = add_exec_event_listener(blk, 'PreOutputs', @daikon_dtrace_callback_postoutputs_multi);
            h_post(i_model) = add_exec_event_listener(blk, 'PostOutputs', @daikon_dtrace_callback_postoutputs_multi);
            %h(i_model) = add_exec_event_listener(blk, 'PostOutputs', @daikon_dtrace_callback_postoutputs_multi);
            %h(i_model) = add_exec_event_listener(blk, 'PostUpdate',
            %@daikon_dtrace_callback_postoutputs_multi); % doesn't work, post
            %is very infrequent
        else
            blk = char(blk); % requires char at this point...
            try
                h_pre(i_model) = add_exec_event_listener(blk, 'PreOutputs', @daikon_dtrace_callback_postoutputs);
            catch ex
                'error: adding pre handler'
                ex
            end
            try
                h_post(i_model) = add_exec_event_listener(blk, 'PostOutputs', @daikon_dtrace_callback_postoutputs);
            catch ex
                'error: adding post handler'
                ex
            end
        end
    end

    % TODO: look at adding callbacks at other times, identify the canonical
    % times (like c's function entry and exit)
    % source: http://www.mathworks.com/help/simulink/slref/add_exec_event_listener.html

    %rto.OutputPort(1).Data
    
    time_siminst_start = toc;

    % source: http://www.mathworks.com/help/simulink/ug/using-the-set-param-command.html
    % poll and wait for simulation to start (will have status of initializing
    % until ready)
    while ~strcmp(get_param(bdroot,'SimulationStatus'), 'paused')
        pause(0.01);
    end

    %set_param(bdroot,'SimulationCommand','start');
    get_param(bdroot,'SimulationStatus');
    set_param(bdroot,'SimulationCommand','continue');
    %set_param(bdroot,'SimulationCommand','stop');

    % wait here until simulation done
    % TODO: convert this wait into an appropriate event handelr function that
    % gets called when the simulation stops to shut things down
    % TODO: but this shutdown will need to know extra information, such as
    % daikon tracing is on, etc. (e.g., check the bit like
    % daikon.Runtime.no_dtrace is false, which implies there is a dtrace open)
    while ~strcmp(get_param(bdroot,'SimulationStatus'), 'stopped')
        pause(0.01);
    end

    % WARNING: don't shutdown file handler until stopped
    % if file size is small, this shutdown may be actually getting called
    % prematurely
    if ~opt_multi
        daikon_dtrace_shutdown();
    end
    
    time_siminst_stop = toc;
    time_siminst = time_siminst_stop - time_siminst_start;
    
    ['Simulation time with instrumentation: ', num2str(time_siminst)]
    if opt_benchmark
        ['Simulation time overhead from instrumentation: ', num2str(time_siminst / time_simulate)]
    end
    
    ['Daikon call command: call_daikon_generateInvariants(''',output_filename,''', ''', model_filename, ''')']
    
    % process generated traces
    if opt_process_traces
        time_daikon = call_daikon_generateInvariants(output_filename, model_filename);
    end
end