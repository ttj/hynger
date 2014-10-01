% HYbrid iNvariant GEneratoR: instruments Simulink/Stateflow blocks to
% produce traces for Daikon in the correct format
%
%
%
javaaddpath(['.', filesep, '..', filesep, 'lib', filesep, 'daikon.jar']);
import  daikon.Runtime.dtrace.*;
%import daikon.Daikon;
%import daikon.*;
%import daikon.derive.*;
%import daikon.derive.binary.*;

global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_output iotype_input;

daikon_dtrace_open = 0;

opt_dataflow = 1;
opt_time = 1;
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

% ways to find all variables defined in a simulink object (so we can
% instrument the simulink diagram automatically using appropriate event /
% time advance listeners)

all_base_vars = Simulink.WorkspaceVar(who, 'base workspace');

count = 0;

%model_filename = 'pendulum';
%model_filename = 'buck_hvoltage';
%model_filename = 'buck_hvoltage_discrete';
%model_filename = 'heaterLygeros';

model_filename = 'slexAircraftPitchControlExample';

% TODO: find all blocks in parent chart
%models_block = {'DC-to-DC Converter', 'Sensor', 'Controller'};
models_block = {};

% TODO: open the model file
models_all = find_system(model_filename); % note: model must be opened
% filter out constants, etc., or maybe just blocks that have only output or
% input, but not both?
for i_model = 1 : length(models_all)
    model_block = char(models_all(i_model));
    
    try
        input_names = get_param(model_block, 'InputSignalNames');
        output_names = get_param(model_block, 'OutputSignalNames');

        % output
        if length(output_names) > 0
        % input and output
        %if length(input_names) > 0 && length(output_names) > 0
            models_block = cat(1,models_block,cellstr(model_block));
        end
    catch
    end
end

daikon_dtrace_blocks = length(models_block);

open_system(['..', filesep, 'example', filesep, model_filename]);

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
    output_filename = 'output.dtrace';
    daikon_dtrace_startup(output_filename);
end

%rto = get_param(gcb,'RuntimeObject');

for i_model = 1 : length(models_block)
    model_block = char(models_block(i_model));
    %blk = [blk_root, '/', char(model_block)];
    
    %blk
    blk = model_block;
    % ignore commented blocks
    if strcmp(get_param(blk, 'Commented'), 'off')
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
            try
            h_pre(i_model) = add_exec_event_listener(blk, 'PreOutputs', @daikon_dtrace_callback_postoutputs);
            catch
            end
            try
            h_post(i_model) = add_exec_event_listener(blk, 'PostOutputs', @daikon_dtrace_callback_postoutputs);
            catch
            end
        end
    end
end

% TODO: look at adding callbacks at other times, identify the canonical
% times (like c's function entry and exit)
% source: http://www.mathworks.com/help/simulink/slref/add_exec_event_listener.html

%rto.OutputPort(1).Data

% source: http://www.mathworks.com/help/simulink/ug/using-the-set-param-command.html
% poll and wait for simulation to start (will have status of initializing
% until ready)
while ~strcmp(get_param(bdroot,'SimulationStatus'), 'paused')
    pause(0.01);
end

%set_param(bdroot,'SimulationCommand','start');
get_param(bdroot,'SimulationStatus')
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


%java daikon.Daikon --config_option daikon.PrintInvariants.print_all=true --config_option daikon.derive.binary.SequenceFloatIntersection.enabled=true --config_option daikon.derive.binary.SequenceFloatSubscript.enabled=true --config_option daikon.derive.binary.SequenceFloatSubsequence.enabled=true --config_option daikon.derive.binary.SequenceFloatUnion.enabled=true --config_option daikon.PptTopLevel.pairwise_implications=true --config_option daikon.derive.binary.SequenceScalarIntersection.enabled=true --config_option daikon.derive.binary.SequencesConcat.enabled=true --config_option daikon.derive.binary.SequencesJoin.enabled=true --config_option daikon.derive.binary.SequencesJoinFloat.enabled=true --config_option daikon.derive.binary.SequencesPredicate.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceStringArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitial.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true --config_option daikon.derive.unary.SequenceSum.enabled=true --config_option daikon.inv.unary.sequence.CommonFloatSequence.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true output_*_*_*.dtrace