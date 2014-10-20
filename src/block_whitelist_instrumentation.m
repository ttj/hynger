% returns true if the block should not be ignored for instrumentation (for
% whitelisting mode)
%
% probably other blocks should be added to allow through
%
% by default, allowing Subsystem and Fcn blocks
function [out] = block_whitelist_instrumentation(blk)
    out = 0;
    
    blk_type = get_param(blk, 'BlockType');
    
    if strcmpi(blk_type, 'Subsystem') || strcmpi(blk_type, 'Fcn')
        out = 1;
        return;
    end
    
end