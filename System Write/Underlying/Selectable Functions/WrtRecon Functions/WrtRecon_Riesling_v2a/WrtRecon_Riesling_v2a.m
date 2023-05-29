%==================================================================
% (v2a)
%   - 
%==================================================================

classdef WrtRecon_Riesling_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtRecon_Riesling_v2a'
    Panel = cell(0)
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [RECON,err] = WrtRecon_Riesling_v2a(RECONipt)     
    err.flag = 0;          
end

%==================================================================
% WriteRecon
%==================================================================  
function err = WriteRecon(RECON,WRTMETH,IMP)     
    err.flag = 0;

    TORD = WRTMETH.TORD;
    for n = 1:length(WRTMETH.KINFO)
        KINFO = WRTMETH.KINFO{n};
        WRTMETH.BuildStchArr(n);
        STCH = WRTMETH.STCH{n};
        
        STCH.SetName(WRTMETH.WRTPARAM.name);
        STCH.SetkStep(KINFO.kstep);
        STCH.SetDummies(WRTMETH.Dummies);
        STCH.SetNumTraj(length(TORD.ScnrImpProjArr));
        STCH.SetNumCol(KINFO.SamplingPts);
        STCH.SetSampStart(KINFO.SamplingPtStart);
        STCH.SetSampStartTime(KINFO.SamplingStartTimeOnTrajectory);
        STCH.SetSamplingTimeOnTrajectory(KINFO.SamplingTimeOnTrajectory);
        STCH.SetSampEnd(STCH.SampStart+STCH.NumCol-1);
        STCH.SetFov(KINFO.fov);
        STCH.SetVox(KINFO.vox);
        STCH.SetSamplingPtAtCentre(KINFO.SamplingPtAtCentre);

        %---
        kSpaceRot = zeros(size(KINFO.kSpace));                          
        kSpaceRot(:,:,1) = KINFO.kSpace(:,:,2);
        kSpaceRot(:,:,2) = KINFO.kSpace(:,:,1);
        kSpaceRot(:,:,3) = KINFO.kSpace(:,:,3);
        %---
        kSpaceRot = cat(3,kSpaceRot,KINFO.SampDensComp);                   
        ReconInfoMat = single(kSpaceRot(TORD.ReconProjArr,:,:));
        ReconInfoMat = permute(ReconInfoMat,[3 2 1]);   
        ReconInfoMat = ReconInfoMat/KINFO.kstep;                                % Bart units
%         FirstTraj = ReconInfoMat(:,1,:);
%         DumTraj = repmat(FirstTraj,1,WRTMETH.Dummies,1);
%         ReconInfoMat = cat(2,DumTraj,ReconInfoMat); 
        STCH.SetReconInfoMat(ReconInfoMat);

        kRad = sqrt(ReconInfoMat(1,:,:).^2 + ReconInfoMat(2,:,:).^2 + ReconInfoMat(3,:,:).^2);
        STCH.SetkMaxRad(max(kRad(:)));
   end

    RECON.Panel(1,:) = {'','','Output'};
    RECON.Panel(2,:) = {'',RECON.Method,'Output'};
end


end
end