%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,SYSWRT,err] = WrtSys_Dummy_v1a(SCRPTipt,SYSWRTipt)

Status2('busy','Write Sys Dummy',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT.method = SYSWRTipt.Func; 

Status2('done','',2);
Status2('done','',3);
