% returns true if the block should not be ignored for instrumentation (for
% whitelisting mode)
%
% probably other blocks should be added to ignore
function [out] = block_whitelist_instrumentation(blk)
    out = 0;
    
    blk_type = get_param(blk, 'BlockType');
    
    if strcmpi(blk_type, 'Subsystem')
        out = 1;
        return;
    end
    
end