%=========================================================
% (v1d)
%      - Add dummy trajectories to ReconInfoMat
%=========================================================

function [SCRPTipt,RECONWRT,err] = WrtRecon_StitchBasic_v1d(SCRPTipt,RECONWRTipt)

Status2('busy','Build Recon File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RECONWRT.method = RECONWRTipt.Func; 

Status2('done','',2);
Status2('done','',3);
