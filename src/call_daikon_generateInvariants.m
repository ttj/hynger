% call Daikon on output trace file
%
% TODO: add trace and config file paths as input
function [time_daikon] = call_daikon_generateInvariants(output_filepath, model_filename)
    tic;
    time_daikon_start = toc; % check if tic necessary (should be called already)
    

    javaaddpath(['.', filesep, '..', filesep, 'lib', filesep, 'daikon.jar']);
    import  daikon.Runtime.dtrace.*;
    import daikon.*;
    %import daikon.Daikon;
    %import daikon.inv.*;
    %import daikon.inv.filter.*;
    import daikon.derive.*;
    import daikon.derive.binary.*;

    opt_display_invariants = 0;
    
    opt_redirect_output = 1;
    
    %'--config_option daikon.PrintInvariants.print_all=true'
    % --config_option daikon.derive.binary.SequenceFloatIntersection.enabled=true --config_option daikon.derive.binary.SequenceFloatSubscript.enabled=true --config_option daikon.derive.binary.SequenceFloatSubsequence.enabled=true --config_option daikon.derive.binary.SequenceFloatUnion.enabled=true --config_option daikon.PptTopLevel.pairwise_implications=true --config_option daikon.derive.binary.SequenceScalarIntersection.enabled=true --config_option daikon.derive.binary.SequencesConcat.enabled=true --config_option daikon.derive.binary.SequencesJoin.enabled=true --config_option daikon.derive.binary.SequencesJoinFloat.enabled=true --config_option daikon.derive.binary.SequencesPredicate.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceStringArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitial.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true --config_option daikon.derive.unary.SequenceSum.enabled=true --config_option daikon.inv.unary.sequence.CommonFloatSequence.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true ../daikon-output/output.dtrace
    
    if opt_redirect_output
        % instantiate java stream objects to redirect default java stdout (to a file stream)
        % see: http://www.mathworks.com/help/matlab/ref/javaobject.html
        %
        % based on idea: http://stackoverflow.com/questions/18669245/how-can-i-pipe-the-java-console-output-to-file-without-java-web-start
        % output file path for Daikon formatted invariants
        inv_filepath_daikon_format = ['../daikon-output/', model_filename, '.inv']; % TODO: clean up file names
        
        fileOutStream = javaObject('java.io.FileOutputStream', inv_filepath_daikon_format);
        printStream = javaObject('java.io.PrintStream', fileOutStream);
        java.lang.System.setOut(printStream);
    end
    
    %dtrace_filepath = output_filepath;
    dtrace_filepath = ['..', filesep, 'daikon-output', filesep 'output_', model_filename, '.dtrace'];
    
    % path to daikon configuration options
    %config_filepath = ['..', filesep, 'src', filesep, 'daikon_settings.txt'];
    %config_filepath = ['..', filesep, 'example', filesep, 'buck_hvoltage_discrete_daikon_config.cfg'];
    config_filepath = ['..', filesep, 'example', filesep, model_filename, '_daikon_config.cfg'];
    
    % error handling: calling Daikon without valid files can crash Matlab
    if ~exist(dtrace_filepath, 'file')
        ['Error calling Daikon: dtrace file not found: ', dtrace_filepath]
        return;
    else
        args = {dtrace_filepath, '--config', config_filepath};
    end
    
    % non-fatal error if config file doesn't exist
    if ~exist(config_filepath, 'file')
        ['Error calling Daikon: config file not found: ', config_filepath]
        ['Warning: proceeding and calling Daikon with default invariant settings since configuration file not found: ', config_filepath]
        args = {dtrace_filepath};
        %%return; % non-fatal, don't quit
    end
    
    
    %daikon.Daikon.main(dtrace_filepath); % TODO: clean up input dtrace file name
    % equivalent call:
    % javaMethod('main', 'daikon.Daikon', {dtrace_filepath});
    
    %daikon_args = javaObject('java.util.ArrayList');
    %daikon_args.add(dtrace_filepath)
    %daikon_args.add([' --config ', config_filepath]);
    
    % * Note: to call Daikon with multiple input arguments, we have to pass
    % them in as a java String[] (not as a space separated string).
    % * The closest approximation is a cell array
    % * Details here:
    % http://www.mathworks.com/help/matlab/matlab_external/passing-data-to-a-java-method.html#f60475
    try
        %daikon.Daikon.main([dtrace_filepath, ' --config ', config_filepath]);
        %javaMethod('main', 'daikon.Daikon', [dtrace_filepath, ' --config ', config_filepath]);
        %javaMethod('main', 'daikon.Daikon', daikon_args.toArray());
        % args = {dtrace_filepath, ['--config ', config_filepath]}; % doesn't work: doesn't let the --config and config path be split...
        
        javaMethod('main', 'daikon.Daikon', args);
        
        % NOTE: be careful calling daikon with bad arguments: it seems that
        % if it has a certain return code (maybe an exit/error return
        % code), it will actually kill Matlab's java process
        %
        % TODO: to help avoid killing this, we should make sure the dtrace
        % and config files exist before trying to call Daikon
        %
        % NOTE: the try/catch will not prevent Matlab from crashing when
        % calling Daikon externally if it has an error
    catch ex
        'error calling Daikon'
        ex
    end
    
    time_daikon_done = toc;
    time_daikon = time_daikon_done - time_daikon_start;
    ['Daikon finished processing in: ', num2str(time_daikon)]
    ['Daikon invariant output available at: ', inv_filepath_daikon_format]
    % display invariants
    if opt_display_invariants
        type(inv_filepath_daikon_format)
    end
end