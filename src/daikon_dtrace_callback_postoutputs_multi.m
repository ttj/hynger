% create multiple Daikon trace files from a single simulation
%
% based on: http://www.mathworks.com/help/simulink/ug/accessing-block-data-during-simulation.html#f13-92463
function [out] = daikon_dtrace_callback_postoutputs_multi(block, eventData)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks;
    %eventData
    %block
    opt_multi = 1;
    %daikon_dtrace_callback_helper(block, eventData, opt_multi);
    
    %eventData.EventName
    %eventData.Source
    %eventData.EventData
    %eventData
    eventData.type
    
    for i = 1 : block.NumOutputPorts
        block.OutputPort(i).Data
    end
end