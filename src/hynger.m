% HYbrid iNvariant GEneratoR: instruments Simulink/Stateflow blocks to
% produce traces for Daikon in the correct format
%
% model_filename: name of an example in ../example/
% opt_process_traces: 0 = do not call trace analyzer automatically, 1 = call trace analyzer automatically
% opt_inst_mode: 0 = default whitelist mode, only instrument subsystem blocks and
% function blocks, 1 = default blacklist mode, instrument all blocks except
% certain restricted classes (see blacklist file), 2 = instrument all
% blocks
%
% INSTRUMENTATION NOTES: 
% (1) in all modes, commented out and commented through blocks are NOT instrumented
% (2) in all modes, blocks with no input and no output ports are NOT instrumented (as they have no visible effect in terms of program points or pre/post conditions)
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
function [time_simulate, time_siminst, time_daikon, models_all_count, models_inst_count] = hynger(model_filename, opt_process_traces, opt_inst_mode)
    tic; % start runtime measurements

    javaaddpath(['.', filesep, '..', filesep, 'lib', filesep, 'daikon.jar']);
    import  daikon.Runtime.dtrace.*;
    %import daikon.Daikon;
    %import daikon.*;
    %import daikon.derive.*;
    %import daikon.derive.binary.*;

    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_output iotype_input;

    daikon_dtrace_open = 0;
    
    try
        if isempty(opt_inst_mode)
            opt_inst_mode = 0;
        end
    catch
        opt_inst_mode = 0;
    end
    
    opt_benchmark = 1; % enable benchmarking mode to compare simulation times with and without instrumentation
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
    
    [pathstr,name,ext] = fileparts(model_filename);
    if length(pathstr) > 0
        pathstr = [pathstr, filesep];
    end
    
    model_filename = name; % TODO: use filename grabbed from path, overwriting here to reuse existing code
    
    % add path separator if extra path necessary (e.g., to ..\examples\array\.)
    model_filepath = ['..', filesep, 'example', filesep, pathstr, model_filename];
    %model_filepath = ['..', filesep, 'example', filesep, 'staliro', filesep, model_filename];
    
    [full_path,name,ext] = fileparts(model_filepath);
    full_path
    addpath(full_path);
    
    model_filepath_mdl = [model_filepath, '.mdl'];
    model_filepath_slx = [model_filepath, '.slx'];
    
    model_filepath
    
    % TODO: show in debug mode
    %model_filename
    %model_filepath
    
    % TODO: check existence of model file here and exit if not found
    if ~exist(model_filepath_slx, 'file') && ~exist(model_filepath_mdl, 'file')
        ['ERROR: file path bad: ', model_filepath_slx, model_filepath_mdl, ' and filename: ', model_filename]
        return;
    end
    
    if exist(model_filepath_slx, 'file') && exist(model_filepath_mdl, 'file')
        ['WARNING: both .mdl and .slx files exist. Continuing and trying to prefer .mdl by default, or given extension if provided (e.g., example.slx will use example.slx even if example.mdl exists; example alone will use .mdl). There is no way to load anything other than the .slx by default, if you need to load the .mdl, remove the .slx.']
        if length(ext) > 0
            model_filepath = [model_filepath, ext];
        elseif length(ext) <= 0
            model_filepath = model_filepath_mdl;
        end
    end
    
    
    try
        % stop simulation in case started from previous run or by user (avoids error)
        set_param(bdroot,'SimulationCommand','stop');
        close_system(model_filepath);
    catch
    end
    
    model_filepath
    open_system(model_filepath);
    
    % TODO: evaluate load_system (which does this without pulling up model)
        
    % simulate diagram without instrumentation and record time
    if opt_benchmark
        time_simulate_start = toc;
        while ~strcmp(get_param(bdroot,'SimulationStatus'), 'stopped')
            pause(0.01);
        end

        set_param(bdroot,'SimulationCommand','start');
        
        %while ~strcmp(get_param(bdroot,'SimulationStatus'), 'running')
        %    pause(0.01);
        %end

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
    % TODO: next, should change to interact properly with stateflow sub-charts
    %models_all = find_system(model_filename, 'FollowLinks', 'on', 'LookUnderMasks', 'all'); % includes ALL blocks underneath
   
    % filter out constants, etc., or maybe just blocks that have only output or
    % input, but not both?
    for i_model = 1 : length(models_all)
        model_block = char(models_all(i_model));

        % ignore blacklist blocks or only add whitelisted blocks
        try
            if (opt_inst_mode == 2) || (opt_inst_mode == 1 && ~block_blacklist_instrumentation(model_block)) || (opt_inst_mode == 0 && block_whitelist_instrumentation(model_block))        
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
    
    models_all_count = length(models_all) - 1; % the root diagram is included here, but it has no i/o's, so don't count it here
    models_inst_count = length(models_block);
    ['Block count in diagram: ', num2str(models_all_count)]
    models_all
    ['Blocks instrumented in diagram: ', num2str(models_inst_count)]
    models_block
    ['Percentage blocks instrumented: ', num2str(models_inst_count / models_all_count)]
    
    if models_inst_count <= 0
        ['Warning: quitting Hynger, no blocks set up for instrumentation, this is probably a mistake or error.']
        return;
    end

    daikon_dtrace_blocks = models_inst_count;

    % ensure stopped
    while ~strcmp(get_param(bdroot,'SimulationStatus'), 'stopped')
        set_param(bdroot,'SimulationCommand','stop');
        pause(0.01);
    end
    
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
    set_param(bdroot,'SimulationCommand','stop');
    
    while ~strcmpi(get_param(bdroot,'SimulationStatus'), 'stopped')
        pause(0.01);
    end
    
    set_param(bdroot,'SimulationCommand','start');
    
    while ~strcmpi(get_param(bdroot,'SimulationStatus'), 'running')
        pause(0.01);
    end
    
    set_param(bdroot,'SimulationCommand','pause');

    while ~strcmpi(get_param(bdroot,'SimulationStatus'), 'paused')
        pause(0.01);
    end

    if ~opt_multi
        output_filename = ['output_', model_filename, '.dtrace'];
        who
        daikon_dtrace_startup(output_filename);
    end
    
    if ~strcmpi(get_param(bdroot,'SimulationStatus'), 'paused')
        'ERROR: simulation failed to start up, terminating'
        return;
    end

    %rto = get_param(gcb,'RuntimeObject');

    i_err_pre = 0;
    i_err_post = 0;
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
                ['error: adding pre handler to block: ', blk]
                ex
                getReport(ex)
                i_err_pre = i_err_pre + 1;
            end
            try
                h_post(i_model) = add_exec_event_listener(blk, 'PostOutputs', @daikon_dtrace_callback_postoutputs);
            catch ex
                ['error: adding post handler to block: ', blk]
                ex
                getReport(ex)
                i_err_post = i_err_post + 1;
            end
        end
    end
    ['Total blocks with pre or post errors: pre: ', num2str(i_err_pre), ' and post: ', num2str(i_err_post)]

    % TODO: look at adding callbacks at other times, identify the canonical
    % times (like c's function entry and exit)
    % source: http://www.mathworks.com/help/simulink/slref/add_exec_event_listener.html

    %rto.OutputPort(1).Data
    
    if i_err_pre == i_err_post && i_err_pre == models_inst_count && i_err_post == models_inst_count
        ['ERROR: no blocks instrumented, exiting.']
        return;
    end
    
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