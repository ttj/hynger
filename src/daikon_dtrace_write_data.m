function [out] = daikon_dtrace_write_data(simTime, simData, ppt_name, opt_dataflow, i_ppt, ppt_count, opt_multi, opt_time)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_input iotype_output;

    Nvars = length(simData);

%     daikon.Runtime.dtrace.println('time:');
%     daikon.Runtime.dtrace.println(num2str(simTime));
%     daikon.Runtime.dtrace.println('variable:');
%     daikon.Runtime.dtrace.println(num2str(simData));
        daikon.Runtime.dtrace.println();
        daikon.Runtime.dtrace.println(['..', ppt_name]);
        if opt_time
            daikon.Runtime.dtrace.println('::time');
            daikon.Runtime.dtrace.println(num2str(simTime));
            daikon.Runtime.dtrace.println('1'); % always set as modified
        end
        for i = 1 : Nvars
            % only print input/output variables with corresponding program
            % point (if option configured to do this)
            %simData(i)
            %simData(i).iotype
            %simData(i).iotype == i_ppt
            %if (opt_dataflow == 0) || (opt_dataflow == 1 && simData(i).iotype == i_ppt)
                if simData(i).length > 1
                    daikon.Runtime.dtrace.println(['::', simData(i).varname, '[..]']);
                    daikon.Runtime.dtrace.print('[ ');

                    % val will be a pointer to the data
                    for j = 1 : simData(i).length
                        daikon.Runtime.dtrace.print(num2str(simData(i).val(j)));
                        daikon.Runtime.dtrace.print(' ');
                    end
                    daikon.Runtime.dtrace.println(' ]'); % newline
                else
                    daikon.Runtime.dtrace.println(['::', simData(i).varname]);
                    daikon.Runtime.dtrace.println(num2str(simData(i).val));
                end
                daikon.Runtime.dtrace.println('1'); % always set as modified
            %end
        end
        daikon.Runtime.dtrace.println();
    
    
%     daikon.Runtime.dtrace.println();
%     daikon.Runtime.dtrace.println('heaterLygeros:::EXIT');
%     daikon.Runtime.dtrace.println('time');
%     daikon.Runtime.dtrace.println(num2str(simTime));
%     daikon.Runtime.dtrace.println('1'); % always set as modified
%     daikon.Runtime.dtrace.println('x');
%     daikon.Runtime.dtrace.println(num2str(simData));
%     daikon.Runtime.dtrace.println('1'); % always set as modified
%     %daikon.Runtime.dtrace.println('return');
%     %daikon.Runtime.dtrace.println(simData);
end