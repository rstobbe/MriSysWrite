%=========================================================
%
%=========================================================

function [RECONWRT,err] = WrtRecon_StitchBasic_v1c_Func(RECONWRT,INPUT)

Status2('busy','Build Recon File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
TORD = INPUT.TORD;
WRTSYS = INPUT.WRTSYS;
SDCS = INPUT.SDCS;
clear INPUT

%-------------------------------------------------
% Gather Info
%-------------------------------------------------
WRT.name = WRTSYS.name;
WRT.kStep = IMP.PROJdgn.kstep;
WRT.npro = IMP.PROJimp.npro;
WRT.Dummies = WRTSYS.dummies;
WRT.NumTraj = length(TORD.projsampscnr);
WRT.NumCol = IMP.KSMP.nproRecon;
WRT.SampStart = IMP.KSMP.DiscardStart+1;
WRT.SampEnd = WRT.SampStart + WRT.NumCol-1;

Kmat = single(IMP.Kmat(TORD.projsampscnr,:,:,:));
Kmat = permute(Kmat,[2 1 3]);
kRad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
WRT.kMaxRad = max(kRad(:));

sz = size(IMP.Kmat);
if length(sz) == 3
    Arr = 1;
else
    Arr = sz(4);
end
SDC = zeros([IMP.PROJimp.nproj,IMP.PROJimp.npro,Arr]);
for n = 1:Arr
    SDC(:,:,n) = SDCArr2Mat(SDCS.SDC(:,n),IMP.PROJimp.nproj,IMP.PROJimp.npro);
end
SDC = single(SDC(TORD.projsampscnr,:,:));
SDC = permute(SDC,[2 1 3]);

WRT.ReconInfoMat = cat(3,Kmat,SDC);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RECONWRT.method,'Output'};
RECONWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%--------------------------------------------
% Return
%--------------------------------------------
RECONWRT.WRT = WRT;

Status2('done','',2);
Status2('done','',3);

