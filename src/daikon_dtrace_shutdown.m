% de-initialize daikon
%
% TODO: had some extra mutex-type pieces added here to create a single
% trace file from numerous blocks, but it turns out this is unnecessary
% (Daikon can parse all the files even if traces are created in different 
% files and figures out the program points)
%
function [out] = daikon_dtrace_shutdown(model_block_name)
    global daikon_dtrace_open daikon_dtrace_blocks_done_all daikon_dtrace_blocks_done daikon_dtrace_blocks;
    
    %daikon_dtrace_blocks_done = [daikon_dtrace_blocks_done; model_block_name];
    
    daikon_dtrace_blocks_done = daikon_dtrace_blocks_done + 1;
    
    if daikon_dtrace_blocks_done == daikon_dtrace_blocks
        daikon_dtrace_blocks_done_all = 1;
    end
    
    % only shut down if all blocks processed
    %if daikon_dtrace_blocks_done_all
        %daikon.Runtime.noMoreOutput(); % don't call this, will kill because it sets no_dtrace to true
        daikon.Runtime.dtrace.close(); % flushes file
        daikon_dtrace_open = 0;
        %pause(0.01);
    %end
end