function [out] = daikon_dtrace_write_decls(model_block_name_daikon, simTime, simData, ppt_name, opt_dataflow, i_ppt, ppt_count, opt_multi, opt_time)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_input iotype_output;
    persistent done_ppts; % state saved between function calls (like "global", but with scope restricted to this function)
    
    % PERFORMANCE: only write declaration once
    % done_ppts is a cell string array: http://www.mathworks.com/help/matlab/matlab_prog/cell-arrays-of-strings.html
    if sum(ismember(done_ppts, ppt_name)) > 0
        return;
    else
        % change to cell array from normal array
        if length(done_ppts) == 0
            done_ppts = {};
        end
        done_ppts(length(done_ppts) + 1) = cellstr(ppt_name);
    end
    
    Nvars = length(simData);
    
    if daikon.Runtime.dtrace.checkError()
        'Error: file stream problem'
        daikon.Runtime.dtrace.flush();
        %daikon.Runtime.dtrace.clearError() % not accessible
    %else
        %daikon.Runtime.dtrace.println('no stream error');
    end

    daikon.Runtime.dtrace.println(['ppt ..', ppt_name]);
    if opt_dataflow
        switch i_ppt
            case iotype_output
                daikon.Runtime.dtrace.println('  ppt-type subexit');
            case iotype_input
                daikon.Runtime.dtrace.println('  ppt-type enter');
            otherwise
                daikon.Runtime.dtrace.println('  ppt-type point');
        end
    else
        daikon.Runtime.dtrace.println('  ppt-type point');
    end
    if opt_time
        daikon.Runtime.dtrace.println('  variable ::time');
        daikon.Runtime.dtrace.println('    var-kind variable');
        daikon.Runtime.dtrace.println('    rep-type double');
        daikon.Runtime.dtrace.println('    dec-type double');
        daikon.Runtime.dtrace.println('    comparability 1');
    end

    for i = 1 : Nvars
        % only print input/output variables with corresponding program
        % point (if option configured to do this)
        %i
        %simData(i)
        %simData(i).iotype
        %simData(i).iotype == i_ppt
        %if (opt_dataflow == 0) || (opt_dataflow == 1 && simData(i).iotype == i_ppt)

        % TODO: this does not properly handle matrices, but it handles
        % arrays fine (example showed up in pendulum)
        
            % arrays
            if simData(i).length > 1
                daikon.Runtime.dtrace.println(['  variable ::', simData(i).varname, '[..]']);
                daikon.Runtime.dtrace.println(['    var-kind array']);
                daikon.Runtime.dtrace.println(['    enclosing-var ::time']); % TODO
                %daikon.Runtime.dtrace.println(['    enclosing-var ::', simData(i).varname]);
                daikon.Runtime.dtrace.println(['    array 1']);
                daikon.Runtime.dtrace.println(['    rep-type ', matlab_type_to_daikon_type(simData(i).type), '[]']);
                daikon.Runtime.dtrace.println(['    dec-type ', matlab_type_to_daikon_type(simData(i).type), '[]']);
            else
                daikon.Runtime.dtrace.println(['  variable ::', simData(i).varname]);
                daikon.Runtime.dtrace.println('    var-kind variable');
                daikon.Runtime.dtrace.println(['    rep-type ', matlab_type_to_daikon_type(simData(i).type)]);
                daikon.Runtime.dtrace.println(['    dec-type ', matlab_type_to_daikon_type(simData(i).type)]);
            end
            %daikon.Runtime.dtrace.println('    rep-type double');
            %daikon.Runtime.dtrace.println('    dec-type double');
            % TODO NEXT: figure out comparability meaning (was i + opt_time)
            %daikon.Runtime.dtrace.println(['    comparability ', num2str(1 + opt_time)]); % possibly bad style, works for opt_time in [0,1]
            daikon.Runtime.dtrace.println(['    comparability 1']); % same comparability: compare all to all
        %end
    end
end