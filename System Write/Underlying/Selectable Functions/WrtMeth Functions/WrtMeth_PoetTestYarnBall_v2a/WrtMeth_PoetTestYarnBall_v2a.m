%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtMeth_PoetTestYarnBall_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtMeth_PoetTestYarnBall_v2a'
    WRTGRAD
    WRTPARAM
    Dummies
    TotalTrajNum
    Panel = cell(0)
    PanelOutput
    ExpDisp
end
properties (SetAccess = public)    
    name
    path
    saveSCRPTcellarray
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [WRTMETH,err] = WrtMeth_PoetTestYarnBall_v2a(WRTMETHipt)    
    err.flag = 0;
    WRTMETH.Dummies = str2double(WRTMETHipt.('Dummies'));
    func = str2func('WrtGrad_Siemens_v2a');           
    WRTMETH.WRTGRAD = func(''); 
    func = str2func('WrtParam_SiemensYarnBall_v2a');           
    WRTMETH.WRTPARAM = func('');   
end 

%==================================================================
% Write
%================================================================== 
function err = Write(WRTMETH,IMPMETH)

    Grads = IMPMETH.GRAD.Grads;

    %---------------------------------------------
    % Add Dummies
    %---------------------------------------------
    if WRTMETH.Dummies > 0
        GradDums = repmat(Grads(1,:,:),[WRTMETH.Dummies,1,1]);
        Grads = cat(1,GradDums,Grads);
    end    
    WRTMETH.TotalTrajNum = length(Grads(:,1,1));

    %---------------------------------------------
    % Name Waveform
    %---------------------------------------------
    err = WRTMETH.WRTPARAM.NameWaveform(WRTMETH,IMPMETH);
    if err.flag
        return
    end    
    
    %---------------------------------------------
    % Write Params
    %---------------------------------------------
    err = WRTMETH.WRTPARAM.WriteParams(WRTMETH,IMPMETH);
    if err.flag
        return
    end    

    %---------------------------------------------
    % Write Params
    %---------------------------------------------
    WRTMETH.WRTGRAD.WriteGrads(WRTMETH,IMPMETH,Grads);
    
    %---------------------------------------------
    % Return
    %---------------------------------------------
    Panel0(1,:) = {'','','Output'};
    Panel0(2,:) = {'Name',WRTMETH.WRTPARAM.name,'Output'};
    Panel0(3,:) = {'','','Output'};
    Panel0(4,:) = {'IMP',IMPMETH.name,'Output'};
    WRTMETH.Panel = [Panel0;WRTMETH.WRTPARAM.Panel;WRTMETH.WRTGRAD.Panel]; 
    WRTMETH.PanelOutput = cell2struct(WRTMETH.Panel,{'label','value','type'},2);
    WRTMETH.ExpDisp = PanelStruct2Text(WRTMETH.PanelOutput);

    Status2('done','',1);
    Status2('done','',2);
    Status2('done','',3);

end

end
end






