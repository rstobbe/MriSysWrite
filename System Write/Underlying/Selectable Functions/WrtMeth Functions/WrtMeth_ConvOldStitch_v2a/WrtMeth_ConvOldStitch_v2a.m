%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtMeth_ConvOldStitch_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtMeth_ConvOldStitch_v2a'
    STCH
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
function [WRTMETH,err] = WrtMeth_ConvOldStitch_v2a(WRTMETHipt)    
    err.flag = 0;
end 

%==================================================================
% Write
%================================================================== 
function err = Write(WRTMETH,PREV)
  
    err.flag = 0;
    func = str2func('StitchReconInfoHolder');
    WRTMETH.STCH{1} = func(); 
    WRTMETH.STCH{1}.SetName(PREV.name);
    WRTMETH.STCH{1}.SetkStep(PREV.kStep);
    WRTMETH.STCH{1}.SetDummies(PREV.Dummies);
    WRTMETH.STCH{1}.SetNumTraj(PREV.NumTraj);
    WRTMETH.STCH{1}.SetNumCol(PREV.NumCol);
    WRTMETH.STCH{1}.SetSampStart(PREV.SampStart);
    WRTMETH.STCH{1}.SetSampEnd(PREV.SampEnd);
    WRTMETH.STCH{1}.SetFov(PREV.Fov);
    WRTMETH.STCH{1}.SetVox(PREV.Vox);  
    
    ReconInfoMat = zeros(size(PREV.ReconInfoMat),'single');
    ReconInfoMat(:,:,1) = PREV.ReconInfoMat(:,:,2);
    ReconInfoMat(:,:,2) = -PREV.ReconInfoMat(:,:,1);
    ReconInfoMat(:,:,3) = PREV.ReconInfoMat(:,:,3);
    ReconInfoMat(:,:,4) = PREV.ReconInfoMat(:,:,4);
    
    WRTMETH.STCH{1}.SetReconInfoMat(ReconInfoMat);
    WRTMETH.STCH{1}.SetkMaxRad(PREV.kMaxRad);    
    
    %---------------------------------------------
    % Return
    %---------------------------------------------
    Panel0(1,:) = {'','','Output'};
    Panel0(2,:) = {'Name',WRTMETH.Method,'Output'};
    WRTMETH.Panel = Panel0; 
    WRTMETH.PanelOutput = cat(1,cell2struct(WRTMETH.Panel,{'label','value','type'},2),PREV.PanelOutput);
    WRTMETH.ExpDisp = PanelStruct2Text(WRTMETH.PanelOutput);

    WRTMETH.name = PREV.name;
    if strcmp(WRTMETH.name(end),'X')
        WRTMETH.name = [WRTMETH.name,'2'];
    else
        WRTMETH.name = [WRTMETH.name,'_X2'];
    end
end

end
end






