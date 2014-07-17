function [out] = daikon_dtrace_write_trace(model_block_name_daikon, simTime, simData, opt_dataflow, opt_multi, opt_time)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_input iotype_output;
    
    simTimeRep = strrep(sprintf('%.10f', simTime), '.', '_');
    
    if opt_dataflow
    	ppt_count = 2;
    else
        ppt_count = 1;
    end
    
    if opt_multi
        %if opt_dataflow
        %    switch i_ppt
        %        case iotype_output
        %            output_filename = ['output_', simTimeRep, '_', model_block_name_daikon, '_exit.dtrace'];
        %        case iotype_input
        %            output_filename = ['output_', simTimeRep, '_', model_block_name_daikon, '_enter.dtrace'];
        %    end
        %else
            output_filename = ['output_', simTimeRep, '_', model_block_name_daikon, '.dtrace'];
        %end
        daikon_dtrace_startup(output_filename);
    end
    
    % NOTE: i_ppt should equal iotype_input and iotype_output
    for i_ppt = 1 : ppt_count
        if opt_multi
            if opt_dataflow
                if i_ppt == iotype_input && strcmp(simData(1).eventType, 'PreOutputs')
                        ppt_name = [model_block_name_daikon, ':::ENTER'];
                elseif i_ppt == iotype_output && strcmp(simData(1).eventType, 'PostOutputs')
                        ppt_name = [model_block_name_daikon, ':::EXIT0'];
                end
%                 switch i_ppt
%                     case iotype_input
%                         ppt_name = [model_block_name_daikon, ':::ENTER'];
%                     case iotype_output
%                         ppt_name = [model_block_name_daikon, ':::EXIT0'];
%                 end
            else
                ppt_name = [model_block_name_daikon, ':::POINT'];
            end
        else
            if opt_dataflow
                switch i_ppt
                    case iotype_input
                        ppt_name = [model_block_name_daikon, '_', simTimeRep, ':::ENTER'];
                    case iotype_output
                        ppt_name = [model_block_name_daikon, '_', simTimeRep, ':::EXIT0'];
                end
            else
                ppt_name = [model_block_name_daikon, '_', simTimeRep, ':::POINT'];
            end
        end
        
        % write decls
        daikon_dtrace_write_decls(model_block_name_daikon, simTime, simData, ppt_name, opt_dataflow, i_ppt, ppt_count, opt_multi, opt_time);
        % write trace data
        daikon_dtrace_write_data(simTime, simData, ppt_name, opt_dataflow, i_ppt, ppt_count, opt_multi, opt_time);
        

    end
    
    if opt_multi
        daikon_dtrace_shutdown(model_block_name_daikon);
    end
end
