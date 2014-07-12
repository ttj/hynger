% helper function called by both the single Daikon trace file and multiple
% Daikon trace files callbacks
%
%
function [out] = daikon_dtrace_callback_helper(block, eventData, opt_multi)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks;
    opt_time = 1;
    opt_namereal = 1;
    opt_time_major_only = 1; % on = faster, only checks at major time steps, see the simulation loop steps, e.g.: http://www.mathworks.com/help/simulink/sfg/how-s-functions-work.html
    
    if ~opt_time_major_only || block.IsMajorTimeStep
        
        %block.BlockHandle
        %block.BlockHandle.Name
        %block.NumDworks % nope...
        
        %get_param(block.BlockHandle,'DialogParameters')
        %get_param(block.BlockHandle,'DialogParameters')
        model_block_name = get_param(block.BlockHandle, 'Name');
        model_block_name_daikon = strrep(model_block_name, ' ', '_'); % remove spaces
        
        %if opt_debug
            %model_block_name
        %end

        simTime = block.CurrentTime;
        %block.NumContStates
        %block.Name
        
        Nvars = 0;
        % TODO: these next two parts (except for the actual data value) can be done a prior once for each
        % block, move outside as some form of global
        
%         model_input_names = get_param(block.BlockHandle, 'InputSignalNames');
%         length(model_input_names)
%         for i = 1 : length(model_input_names)
%             char(model_input_names(i))
%         end
%         
%         model_input_names = get_param(block.BlockHandle, 'OutputSignalNames');
%         length(model_input_names)
%         for i = 1 : length(model_input_names)
%             char(model_input_names(i))
%         end
        outports_names = get_param(block.BlockHandle, 'OutputSignalNames');
%         
% %         ports = get_param(block.BlockHandle, 'Ports');
% %         ports.Input
% %         ports.Output
%         
        ports = get_param(block.BlockHandle, 'PortHandles');
%        ports
%        get_param(ports.Inport(1),'Name')
%         ports.Inport
%         ports.Outport
        
%         model_input_names = get_param(block.BlockHandle, 'InputPorts');
%         for i = 1 : length(model_input_names)
%             model_input_names(i)
%         end
        
        % iterate over output variables and setup for logging
        for i = 1 : block.NumOutputPorts
            simData(i).val = block.OutputPort(i).Data;
            %block.OutputPort(i).Name
            %block.OutputPort(i)
            %get_param(block.OutputPort(i),'DialogParameters')
            if opt_namereal && length( outports_names(i) ) > 0
                %length( get_param(ports.Outport(i),'Name') > 0 )
                %simData(i).varname = block.OutputPort(i).Name; % doesn't work
                %simData(i).varname = get_param(ports.Outport(i),'Name');
                simData(i).varname = char( outports_names(i) );
            else
                simData(i).varname = ['x_out', num2str(i)];
            end
            simData(i).type = block.OutputPort(i).Datatype;
            simData(i).length = block.OutputPort(i).Dimensions;
            
            Nvars = Nvars + 1;
        end
        
        % iterate over input variables and setup for logging
        for i = 1 : block.NumInputPorts
            simData(Nvars + 1).val = block.InputPort(i).Data;
            if opt_namereal && length( get_param(ports.Inport(i),'Name') > 0 )
                %simData(Nvars + 1).varname = block.InputPort(i).Name;
                simData(Nvars + 1).varname = get_param(ports.Inport(i),'Name');
            else
                simData(Nvars + 1).varname = ['x_in', num2str(i)];
            end
            simData(Nvars + 1).type = block.InputPort(i).Datatype;
            simData(Nvars + 1).length = block.InputPort(i).Dimensions;
            
            Nvars = Nvars + 1;
        end

        simTimeRep = strrep(sprintf('%.10f', simTime), '.', '_');
        
        if opt_multi
            ppt_name = [model_block_name_daikon, ':::POINT_t'];
        else
            ppt_name = [model_block_name_daikon, ':::POINT_t', simTimeRep];
        end

        if opt_multi
            output_filename = ['output_', simTimeRep, '_', model_block_name_daikon, '.dtrace'];
            daikon_dtrace_startup(output_filename);
        end

        daikon.Runtime.dtrace.println(['ppt ..', ppt_name]);
        daikon.Runtime.dtrace.println('  ppt-type point');
        if opt_time
            daikon.Runtime.dtrace.println('  variable ::time');
            daikon.Runtime.dtrace.println('    var-kind variable');
            daikon.Runtime.dtrace.println('    rep-type double');
            daikon.Runtime.dtrace.println('    dec-type double');
            daikon.Runtime.dtrace.println('    comparability 1');
        end

        for i = 1 : Nvars
            % arrays
            if simData(i).length > 1
%    var-kind array
%    enclosing-var b
%    array 1
%    rep-type int[]
%    dec-type int[]      
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
            daikon.Runtime.dtrace.println(['    comparability 1']);
        end


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
        end
        daikon.Runtime.dtrace.println();
        
        if opt_multi
            daikon_dtrace_shutdown(model_block_name);
        end
    end
    
    
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
%     
    % see: http://www.mathworks.com/help/simulink/slref/add_exec_event_listener.html
    end