% create a single large trace file from the entire simulation
%
% based on: http://www.mathworks.com/help/simulink/ug/accessing-block-data-during-simulation.html#f13-92463
function [out] = daikon_dtrace_callback_postoutputs(block, eventData)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks;
    opt_multi = 0;
    daikon_dtrace_callback_helper(block, eventData, opt_multi);
end