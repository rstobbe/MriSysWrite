%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtMeth_ConvOldCompass_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtMeth_ConvOldCompass_v2a'
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
function [WRTMETH,err] = WrtMeth_ConvOldCompass_v2a(WRTMETHipt)    
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
    WRTMETH.STCH{1}.SetkStep(PREV.PROJdgn.kstep);
    WRTMETH.STCH{1}.SetDummies(PREV.dummies);
    WRTMETH.STCH{1}.SetNumTraj(length(PREV.TORD.projsampscnr));
    WRTMETH.STCH{1}.SetNumCol(PREV.KSMP.nproRecon);
    WRTMETH.STCH{1}.SetSampStart(PREV.KSMP.DiscardStart+1);
    WRTMETH.STCH{1}.SetSampEnd(WRTMETH.STCH{1}.SampStart + WRTMETH.STCH{1}.NumCol - 1);
    WRTMETH.STCH{1}.SetFov(PREV.PROJdgn.fov);
    WRTMETH.STCH{1}.SetVox(PREV.PROJdgn.vox);  

    sz = size(PREV.Kmat);
    if length(sz) > 3
        error;          % Update to go into STCH array
    end    

    kRad = sqrt(PREV.Kmat(:,:,1).^2 + PREV.Kmat(:,:,2).^2 + PREV.Kmat(:,:,3).^2);
    WRTMETH.STCH{1}.SetkMaxRad(max(kRad(:)));    
    
    Kmat = zeros(size(PREV.Kmat));
    Kmat(:,:,1) = PREV.Kmat(:,:,2);
    Kmat(:,:,2) = -PREV.Kmat(:,:,1);
    Kmat(:,:,3) = PREV.Kmat(:,:,3);
    
    ReconInfoMat0 = single(cat(3,Kmat,PREV.SDC));
    ReconInfoMat0 = permute(ReconInfoMat0,[2 1 3]);
    FirstTraj = ReconInfoMat0(:,1,:);
    DumTraj = repmat(FirstTraj,1,PREV.dummies,1);
    ReconInfoMat = cat(2,DumTraj,ReconInfoMat0);
    WRTMETH.STCH{1}.SetReconInfoMat(ReconInfoMat);   

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






