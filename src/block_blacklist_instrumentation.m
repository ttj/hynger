% returns true if the block should be ignored for instrumentation
%
% by default, we ignore:
% commented blocks (since they will have no in/out port/variable changes)
% constant blocks (since they will just be constant)
% scope blocks (since they will just be equal to the output ports that are fed into)
% goto blocks
%
% probably other blocks should be added to ignore
function [out] = block_blacklist_instrumentation(blk)
    out = 0;
    if ~strcmpi(get_param(blk, 'Commented'), 'off')
        out = 1;
        return;
    end
    
    blk_type = get_param(blk, 'BlockType');
    
    % TODO: convert all these ORs to a loop, provide a cellstr array of
    % blacklisted blocks, and iterate through doing comparisons
    
    if (strcmpi(blk_type, 'Constant') || strcmpi(blk_type, 'Scope') || strcmpi(blk_type, 'Goto'))
        out = 1;
        return;
    end
    
    % TODO: add options to have more or less types of blocks ignored
    %opt_ignore_more = 1;
    if strcmpi(blk_type, 'UnitDelay') || strcmpi(blk_type, 'Gain') || strcmpi(blk_type, 'Inport') || ...
            strcmpi(blk_type, 'Outport') || strcmpi(blk_type, 'Product') || strcmpi(blk_type, 'Sum') || ...
            strcmpi(blk_type, 'Lookup Table') || strcmpi(blk_type, 'LookupTable') || strcmpi(blk_type, 'Integrator') || ...
            strcmpi(blk_type, 'Scope') 
        out = 1;
        return;
    end
    
    if strcmpi(blk_type, 'Quantizer')
        out = 1;
        return;
    end
end