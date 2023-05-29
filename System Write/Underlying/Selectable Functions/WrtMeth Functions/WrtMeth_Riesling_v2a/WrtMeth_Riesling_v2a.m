%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtMeth_Riesling_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtMeth_Riesling_v2a'
    TrajOrderfunc
    TORD
    WRTPARAM
    WRTRECON
    STCH
    Dummies
    TotalTrajNum
    KINFO
    Panel = cell(0)
    PanelOutput
    ExpDisp
    SaveScript = 1
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
function [WRTMETH,err] = WrtMeth_Riesling_v2a(WRTMETHipt)    
    err.flag = 0;
    numfiles = str2double(WRTMETHipt.('NumAcqs').EntryStr);
    for n = 1:numfiles
        PanelLabel{n} = ['Sdc',num2str(n),'_File'];
    end
    CallingLabel = WRTMETHipt.Struct.labelstr;
    ReLoad = 0;
    if not(isfield(WRTMETHipt,[CallingLabel,'_Data']))
        ReLoad = 1;
    else
        if not(isfield(WRTMETHipt.([CallingLabel,'_Data']),[PanelLabel{n},'_Data']))
            ReLoad = 1;
        end
    end
    for n = 1:numfiles    
        if ReLoad == 1
            if isfield(WRTMETHipt.(PanelLabel{n}).Struct,'selectedfile')
                file = WRTMETHipt.(PanelLabel{n}).Struct.selectedfile;
                if not(exist(file,'file'))
                    err.flag = 1;
                    err.msg = ['(Re) Load ',PanelLabel{n}];
                    ErrDisp(err);
                    return
                else
                    load(file);
                    WRTMETHipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']) = saveData;
                end
            else
                err.flag = 1;
                err.msg = ['(Re) Load ',PanelLabel{n}];
                ErrDisp(err);
                return
            end
        end
        Data = WRTMETHipt.([CallingLabel,'_Data']).([PanelLabel{n},'_Data']);   
        WRTMETH.KINFO{n} = Data.SDC.KINFO;    
    end
    WRTMETH.Dummies = str2double(WRTMETHipt.('Dummies'));
    func = str2func('WrtParam_SiemensYarnBall_v2a');           
    WRTMETH.WRTPARAM = func('');   
    func = str2func('WrtMeth_Riesling_v2a');           
    WRTMETH.WRTRECON = func('');
    WRTMETH.TrajOrderfunc = WRTMETHipt.('TrajOrderfunc').Func; 
    TORDipt = WRTMETHipt.('TrajOrderfunc');
    CallingFunction = WRTMETHipt.Struct.labelstr;
    if isfield(WRTMETHipt,([CallingFunction,'_Data']))
        if isfield(WRTMETHipt.([CallingFunction,'_Data']),('TrajOrderfunc_Data'))
            TORDipt.TrajOrderfunc_Data = WRTMETHipt.([CallingFunction,'_Data']).TrajOrderfunc_Data;
        end
    end
    func = str2func(WRTMETH.TrajOrderfunc);                   
    WRTMETH.TORD = func(TORDipt);
end 

%==================================================================
% Write
%================================================================== 
function err = Write(WRTMETH,IMPMETH)
  
    %---------------------------------------------
    % Order Trajectories
    %---------------------------------------------
    err = WRTMETH.TORD.OrderTrajectories(WRTMETH,IMPMETH);
    if err.flag
        return
    end    
    WRTMETH.TotalTrajNum = length(IMPMETH.GRAD.Grads(:,1,1)) + WRTMETH.Dummies;

    %---------------------------------------------
    % Name Waveform
    %---------------------------------------------
    err = WRTMETH.WRTPARAM.NameWaveform(WRTMETH,IMPMETH);
    if err.flag
        return
    end
    WRTMETH.name = WRTMETH.WRTPARAM.name;

    %---------------------------------------------
    % Write Recon
    %---------------------------------------------
    err = WRTMETH.WRTRECON.WriteRecon(WRTMETH,IMPMETH);
    if err.flag
        return
    end      
    WRTMETH.KINFO = [];
    
    %---------------------------------------------
    % Return
    %---------------------------------------------
    Panel0(1,:) = {'','','Output'};
    Panel0(2,:) = {'Name',WRTMETH.WRTPARAM.name,'Output'};
    Panel0(3,:) = {'','','Output'};
    Panel0(4,:) = {'IMP',IMPMETH.name,'Output'};
    WRTMETH.Panel = [Panel0;WRTMETH.WRTRECON.Panel]; 
    WRTMETH.PanelOutput = cell2struct(WRTMETH.Panel,{'label','value','type'},2);
    WRTMETH.ExpDisp = PanelStruct2Text(WRTMETH.PanelOutput);

    Status2('done','',1);
    Status2('done','',2);
    Status2('done','',3);

end

%==================================================================
% BuildStchArr
%================================================================== 
function BuildStchArr(WRTMETH,ArrNum)
    func = str2func('StitchReconInfoHolder');
    WRTMETH.STCH{ArrNum} = func();    
end

end
end






