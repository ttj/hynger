function [out] = matlab_type_to_daikon_type(type_str)
    switch type_str
        case 'int32'
            out = 'int';
        case 'int16'
            out = 'int';
        case 'float'
            out = 'double';
        case 'double'
            out = 'double';
        otherwise
            out = 'double';
    end
end