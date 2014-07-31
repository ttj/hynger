% initialize Daikon and the output trace files
%
% TODO: add a program mode that doesn't pipe these to actual files, 
% but forwards them to Daikon directly
%
function [out] = daikon_dtrace_startup(output_trace_filename)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks;
    
    % mutex-type object to see if a trace file is already created or not
    % (multiple blocks, each with their own callback)
    if ~daikon_dtrace_open && ~daikon.Runtime.no_dtrace
        output_dir = ['..', filesep, 'daikon-output', filesep];
        output_filepath = [output_dir, output_trace_filename];

        %daikon.Runtime.no_dtrace = true;
        %daikon.Runtime.setDtraceMaybe(output_filepath);
        daikon.Runtime.setDtrace(output_filepath, false); % todo: figure out which of these actually opens the file...
        daikon_dtrace_open = 1;
        daikon_dtrace_blocks_done_all = 0;
        daikon_dtrace_blocks_done = 0;

        daikon.Runtime.dtrace.println('input-language Simulink/Stateflow');
        daikon.Runtime.dtrace.println('decl-version 2.0');
        daikon.Runtime.dtrace.println('var-comparability implicit'); % TODO: explicit?
        daikon.Runtime.dtrace.println();
    end
    
    'started up Daikon tracing'
    
end