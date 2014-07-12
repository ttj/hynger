% write spaceex model and configuration file
% loads a header and footer for the model file specifying the basic system
% structure, then instantiates parameters based on the particular component
% values (resistor values, duty cycles, voltage sources, etc.)
%
% call after matrices.m so parameters are initialized (by default
%   matrices.m calls this file)
function [out] = write_spaceex(outname, name, sys, idx, Tmax, T, D, Vs, i0, v0)
    % normally only one system, except when option_extrema is set and
    % all combinations of component variation extremes are considered (only
    % for buck converter for now)
    for i = 1 : idx
        % open header
        ostr = fileread([name, '_head.xml']);
        
        % open spaceex model file
        fout = fopen( [outname, '_v', num2str(i), '.xml'], 'w+');

        % write values
        ostr = [ostr, '<bind component="', name, '_template" as="', name, '_template_1" x="496.0" y="118.0">\n'];
        ostr = [ostr, '  <map key="il">il</map>\n'];
        % next must be numeric (else nonlinear errors from SpaceEx)
        ostr = [ostr, '  <map key="a00o">', num2str(sys(i).Ao(1,1)),'</map>\n'];
        ostr = [ostr, '  <map key="a01o">', num2str(sys(i).Ao(1,2)),'</map>\n'];
        ostr = [ostr, '  <map key="a10o">', num2str(sys(i).Ao(2,1)),'</map>\n'];
        ostr = [ostr, '  <map key="a11o">', num2str(sys(i).Ao(2,2)),'</map>\n'];
        ostr = [ostr, '  <map key="a00c">', num2str(sys(i).Ac(1,1)),'</map>\n'];
        ostr = [ostr, '  <map key="a01c">', num2str(sys(i).Ac(1,2)),'</map>\n']; 
        ostr = [ostr, '  <map key="a10c">', num2str(sys(i).Ac(2,1)),'</map>\n']; 
        ostr = [ostr, '  <map key="a11c">', num2str(sys(i).Ac(2,2)),'</map>\n'];
        ostr = [ostr, '  <map key="a00d">', num2str(sys(i).Ad(1,1)),'</map>\n'];
        ostr = [ostr, '  <map key="a01d">', num2str(sys(i).Ad(1,2)),'</map>\n'];
        ostr = [ostr, '  <map key="a10d">', num2str(sys(i).Ad(2,1)),'</map>\n'];
        ostr = [ostr, '  <map key="a11d">', num2str(sys(i).Ad(2,2)),'</map>\n'];
        ostr = [ostr, '  <map key="bounds">1000</map>\n'];
        ostr = [ostr, '  <map key="t">t</map>\n'];
        ostr = [ostr, '  <map key="gt">gt</map>\n'];
        ostr = [ostr, '  <map key="T">', num2str(T), '</map>\n'];   % must be numeric (else nonlinear)
        ostr = [ostr, '  <map key="D">D</map>\n'];
        % must be numeric (else nonlinear)
        ostr = [ostr, '  <map key="b0o">', num2str(sys(i).Bo(1)),'</map>\n'];
        ostr = [ostr, '  <map key="b1o">', num2str(sys(i).Bo(2)),'</map>\n'];
        ostr = [ostr, '  <map key="b0c">', num2str(sys(i).Bc(1)),'</map>\n'];
        ostr = [ostr, '  <map key="b1c">', num2str(sys(i).Bc(2)),'</map>\n'];
        ostr = [ostr, '  <map key="b0d">', num2str(sys(i).Bd(1)),'</map>\n'];
        ostr = [ostr, '  <map key="b1d">', num2str(sys(i).Bd(2)),'</map>\n'];
        ostr = [ostr, '  <map key="Vs">Vs</map>\n'];
        ostr = [ostr, '  <map key="tmax">tmax</map>\n'];
        ostr = [ostr, '  <map key="vc">vc</map>\n'];
        ostr = [ostr, '</bind>\n'];

        ostr = sprintf(ostr); % convert newlines

        % open footer
        ostr = [ostr, fileread([name, '_footer.xml'])];

        % write all, close file
        fwrite(fout, ostr);
        fclose(fout);
        
        ostr = fileread([name, '_config_header.cfg']);

        fout = fopen( [outname, '_v', num2str(i), '.cfg'], 'w+');

        % write initial condition values
        ostr = [ostr, 'initially = "loc(buckboost_template_1)==charging & il==', num2str(i0),' & vc==', num2str(v0),' & t==0 & gt==0 & D==', num2str(D), ' & Vs==', num2str(Vs), ' & tmax==', num2str(Tmax/4),'"\n'];
        
        ostr = sprintf(ostr); % convert newlines

        % write all, close file
        fwrite(fout, ostr);
        fclose(fout);
    end
    fclose('all');
end