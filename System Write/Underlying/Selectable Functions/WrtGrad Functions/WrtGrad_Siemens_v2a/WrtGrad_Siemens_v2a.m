%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtGrad_Siemens_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtGrad_Siemens_v2a'
    WRTGRADipt
    Panel
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [WRTGRAD,err] = WrtGrad_Siemens_v2a(WRTGRADipt)    
    err.flag = 0;
    WRTGRAD.WRTGRADipt = WRTGRADipt;     
end

%==================================================================
% WriteGrads
%==================================================================  
function err = WriteGrads(WRTGRAD,WRTMETH,IMPMETH,Grads)    
    err.flag = 0;
    WRTPARAM = WRTMETH.WRTPARAM;
    GRAD = IMPMETH.GRAD;
    file = [WRTPARAM.path,WRTPARAM.file];

    %-------------------------------------------------
    % Normalize
    %-------------------------------------------------
    if GRAD.GetMaxAbsGrad ~= max(abs(Grads(:)))
        error('fix');
    end
    Grads = Grads/max(abs(Grads(:)));

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





