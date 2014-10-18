% call Daikon on output trace file
%
% TODO: add trace and config file paths as input
function call_daikon_generateInvariants()
    javaaddpath(['.', filesep, '..', filesep, 'lib', filesep, 'daikon.jar']);
    import  daikon.Runtime.dtrace.*;
    import daikon.*;
    %import daikon.Daikon;
    %import daikon.inv.*;
    %import daikon.inv.filter.*;
    import daikon.derive.*;
    import daikon.derive.binary.*;
    
    opt_redirect_output = 1;
    
    %'--config_option daikon.PrintInvariants.print_all=true'
    % --config_option daikon.derive.binary.SequenceFloatIntersection.enabled=true --config_option daikon.derive.binary.SequenceFloatSubscript.enabled=true --config_option daikon.derive.binary.SequenceFloatSubsequence.enabled=true --config_option daikon.derive.binary.SequenceFloatUnion.enabled=true --config_option daikon.PptTopLevel.pairwise_implications=true --config_option daikon.derive.binary.SequenceScalarIntersection.enabled=true --config_option daikon.derive.binary.SequencesConcat.enabled=true --config_option daikon.derive.binary.SequencesJoin.enabled=true --config_option daikon.derive.binary.SequencesJoinFloat.enabled=true --config_option daikon.derive.binary.SequencesPredicate.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceStringArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitial.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true --config_option daikon.derive.unary.SequenceSum.enabled=true --config_option daikon.inv.unary.sequence.CommonFloatSequence.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true ../daikon-output/output.dtrace
    
    if opt_redirect_output
        % instantiate java stream objects to redirect default java stdout (to a file stream)
        % see: http://www.mathworks.com/help/matlab/ref/javaobject.html
        %
        % based on idea: http://stackoverflow.com/questions/18669245/how-can-i-pipe-the-java-console-output-to-file-without-java-web-start
        fileOutStream = javaObject('java.io.FileOutputStream', '../daikon-output/output_test.inv'); % TODO: clean up file names
        printStream = javaObject('java.io.PrintStream', fileOutStream);
        java.lang.System.setOut(printStream);
    end
    
    dtrace_filepath = ['..', filesep, 'daikon-output', filesep 'output.dtrace'];
    %config_filepath = ['..', filesep, 'src', filesep, 'daikon_settings.txt'];
    config_filepath = ['..', filesep, 'example', filesep, 'buck_hvoltage_discrete_daikon_config.cfg'];
    
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
        
        args = {dtrace_filepath, '--config', config_filepath}; % works
        javaMethod('main', 'daikon.Daikon', args);
        
        % NOTE: be careful calling daikon with bad arguments: it seems that
        % if it has a certain return code (maybe an exit/error return
        % code), it will actually kill Matlab's java process
        %
        % TODO: to help avoid killing this, we should make sure the dtrace
        % and config files exist before trying to call Daikon
    catch ex
        'error calling Daikon'
        ex
    end
    
    %daikon.Daikon.main --config_option daikon.PrintInvariants.print_all=true --config_option daikon.derive.binary.SequenceFloatIntersection.enabled=true --config_option daikon.derive.binary.SequenceFloatSubscript.enabled=true --config_option daikon.derive.binary.SequenceFloatSubsequence.enabled=true --config_option daikon.derive.binary.SequenceFloatUnion.enabled=true --config_option daikon.PptTopLevel.pairwise_implications=true --config_option daikon.derive.binary.SequenceScalarIntersection.enabled=true --config_option daikon.derive.binary.SequencesConcat.enabled=true --config_option daikon.derive.binary.SequencesJoin.enabled=true --config_option daikon.derive.binary.SequencesJoinFloat.enabled=true --config_option daikon.derive.binary.SequencesPredicate.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceStringArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitial.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true --config_option daikon.derive.unary.SequenceSum.enabled=true --config_option daikon.inv.unary.sequence.CommonFloatSequence.enabled=true --config_option daikon.derive.binary.SequencesPredicateFloat.enabled=true --config_option daikon.derive.ternary.SequenceFloatArbitrarySubsequence.enabled=true --config_option daikon.derive.ternary.SequenceScalarArbitrarySubsequence.enabled=true --config_option daikon.derive.unary.SequenceInitialFloat.enabled=true --config_option daikon.derive.unary.SequenceMax.enabled=true --config_option daikon.derive.unary.SequenceMin.enabled=true ../daikon-output/output.dtrace
end