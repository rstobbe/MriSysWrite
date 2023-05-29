%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtMeth_PoetTestYarnBall_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtMeth_PoetTestYarnBall_v2a'
    TORD
    WRTGRAD
    WRTPARAM
    TotalTrajNum
    Panel = cell(0)
    PanelOutput
    ExpDisp
    SaveScript = 0
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
    func = str2func('WrtGrad_Siemens_v2a');           
    WRTMETH.WRTGRAD = func(''); 
    func = str2func('WrtParam_SiemensYarnBall_v2a');           
    WRTMETH.WRTPARAM = func('');
    func = str2func('TrajOrder_GoldenStep_v2b');           
    WRTMETH.TORD = func();
    WRTMETH.TORD.InitViaCompass('');
end 

%==================================================================
% Write
%================================================================== 
function err = Write(WRTMETH,IMPMETH)

    %---------------------------------------------
    % Order Trajectories
    %---------------------------------------------
    err = WRTMETH.TORD.OrderTrajectories(IMPMETH);
    if err.flag
        return
    end 
    Grads = IMPMETH.GRAD.Grads(WRTMETH.TORD.ScnrImpProjArr,:,:);

    %---------------------------------------------
    % Use 30 Grads for Poet Test 
    %---------------------------------------------
    Grads = Grads(1:30,:,:);
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






