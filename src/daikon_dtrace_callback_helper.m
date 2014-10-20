% helper function called by both the single Daikon trace file and multiple
% Daikon trace files callbacks
%
%
function [out] = daikon_dtrace_callback_helper(block, eventData, opt_multi)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks iotype_input iotype_output;
    opt_time = 1;
    opt_namereal = 1; % try using real variable names instead of automatically generated ones
    opt_time_major_only = 1; % on = faster, only checks at major time steps, see the simulation loop steps, e.g.: http://www.mathworks.com/help/simulink/sfg/how-s-functions-work.html
    opt_dataflow = 1; % 1 = dataflow on (program points in hierarchy), 0 = dataflow off (just assume all program points are unit traces)
    
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
            if opt_namereal && length( strtrim(outports_names(i)) ) > 0
                %length( get_param(ports.Outport(i),'Name') > 0 )
                %simData(i).varname = block.OutputPort(i).Name; % doesn't work
                %simData(i).varname = get_param(ports.Outport(i),'Name');
                simData(i).varname = strtrim(char( outports_names(i) ));
            else
                simData(i).varname = ['x_out', num2str(i)];
            end
            simData(i).iotype = iotype_output;
            simData(i).type = block.OutputPort(i).Datatype;
            simData(i).length = block.OutputPort(i).Dimensions;
            simData(i).eventType = eventData.type;
            
            Nvars = Nvars + 1;
        end
        
        % iterate over input variables and setup for logging
        for i = 1 : block.NumInputPorts
            simData(Nvars + 1).val = block.InputPort(i).Data;
            inportName = strtrim(char(get_param(ports.Inport(i),'Name')));
            if opt_namereal && length(inportName  > 0 )
                %simData(Nvars + 1).varname = block.InputPort(i).Name;
                simData(Nvars + 1).varname = inportName;
            else
                simData(Nvars + 1).varname = ['x_in', num2str(i)];
            end
            simData(Nvars + 1).iotype = iotype_input;
            simData(Nvars + 1).type = block.InputPort(i).Datatype;
            simData(Nvars + 1).length = block.InputPort(i).Dimensions;
            simData(i).eventType = eventData.type;
            
            Nvars = Nvars + 1;
        end
        
        daikon_dtrace_write_trace(model_block_name_daikon, simTime, simData, opt_dataflow, opt_multi, opt_time);
    end
end