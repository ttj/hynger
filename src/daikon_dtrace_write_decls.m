function [out] = daikon_dtrace_write_decls(model_block_name_daikon, simTime, simData, ppt_name, opt_dataflow, i_ppt, ppt_count, opt_multi, opt_time)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_input iotype_output;

    
    Nvars = length(simData);
        




        daikon.Runtime.dtrace.println(['ppt ..', ppt_name]);
        if opt_dataflow
            switch i_ppt
                case iotype_output
                    daikon.Runtime.dtrace.println('  ppt-type exit');
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
            
                % arrays
                if simData(i).length > 1  
                    daikon.Runtime.dtrace.println(['  variable ::', simData(i).varname, '[..]']);
                    daikon.Runtime.dtrace.println(['    var-kind array']);
                    daikon.Runtime.dtrace.println(['    enclosing-var ::time']); % TODO
                    %daikon.Runtime.dtrace.println(['    enclosing-var ::', simData(i).varname]);
                    daikon.Runtime.dtrace.println(['    array 1']);
                    daikon.Runtime.dtrace.println(['    rep-type ', simData(i).type, '[]']);
                    daikon.Runtime.dtrace.println(['    dec-type ', simData(i).type, '[]']);
                else
                    daikon.Runtime.dtrace.println(['  variable ::', simData(i).varname]);
                    daikon.Runtime.dtrace.println('    var-kind variable');
                    daikon.Runtime.dtrace.println(['    rep-type ', simData(i).type]);
                    daikon.Runtime.dtrace.println(['    dec-type ', simData(i).type]);
                end
                %daikon.Runtime.dtrace.println('    rep-type double');
                %daikon.Runtime.dtrace.println('    dec-type double');
                % TODO NEXT: figure out comparability meaning (was i + opt_time)
                %daikon.Runtime.dtrace.println(['    comparability ', num2str(1 + opt_time)]); % possibly bad style, works for opt_time in [0,1]
                daikon.Runtime.dtrace.println(['    comparability 1']); % same comparability: compare all to all
            %end
        end
end