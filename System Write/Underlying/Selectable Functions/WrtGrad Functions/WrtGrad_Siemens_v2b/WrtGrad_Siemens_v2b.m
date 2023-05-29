%==================================================================
% (v2a)
%       - IMPMETH dropped.  Do gmax check elsewhere.
%       - WRTPARAM as input. 
%==================================================================

classdef WrtGrad_Siemens_v2b < handle

properties (SetAccess = private)                   
    Method = 'WrtGrad_Siemens_v2b'
    WRTGRADipt
    Panel
    gmax
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function WRTGRAD = WrtGrad_Siemens_v2b()     
end

%==================================================================
% InitViaCompass
%==================================================================  
function [WRTGRAD,err] = InitViaCompass(WRTGRAD,WRTGRADipt)    
    err.flag = 0;
    WRTGRAD.WRTGRADipt = WRTGRADipt;     
end

%==================================================================
% WriteGrads
%==================================================================  
function err = WriteGrads(WRTGRAD,WRTPARAM,Grads)    
    err.flag = 0;
    file = [WRTPARAM.path,WRTPARAM.file];

    %-------------------------------------------------
    % Normalize
    %-------------------------------------------------
    Grads = Grads/max(abs(Grads(:)));
    WRTGRAD.gmax = max(abs(Grads(:)));
    
    %-------------------------------------------------
    % Write Gradients to File
    %-------------------------------------------------
    Status2('busy','Write Gradient File for Siemens',2);    
    for n = 1:length(Grads(:,1,1))
        dlmwrite(file,squeeze(Grads(n,:,1)),'-append','newline','pc');
        dlmwrite(file,squeeze(Grads(n,:,2)),'-append','newline','pc');
        dlmwrite(file,squeeze(Grads(n,:,3)),'-append','newline','pc');
        Status2('busy',['Projection Number ',num2str(n)],3);
    end
    Status2('done','',2);
    Status2('done','',3);  
end


end
end





