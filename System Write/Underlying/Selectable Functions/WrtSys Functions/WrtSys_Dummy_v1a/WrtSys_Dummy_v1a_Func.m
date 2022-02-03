%=========================================================
%
%=========================================================

function [SYSWRT,err] = WrtSys_Dummy_v1a_Func(SYSWRT,INPUT)

Status2('busy','Write Sys Dummy',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
SYSWRT.name = '';
SYSWRT.dummies = 0;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',SYSWRT.method,'Output'};
SYSWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);

