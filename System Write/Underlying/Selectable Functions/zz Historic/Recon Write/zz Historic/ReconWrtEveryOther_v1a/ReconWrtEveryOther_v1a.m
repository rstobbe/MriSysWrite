%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,RCNWRT,err] = ReconWrtEveryOther_v1a(SCRPTipt,RCNWRTipt)

Status2('busy','Write Reconstruction Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
RCNWRT.method = RCNWRTipt.Func;

Status2('done','',2);
Status2('done','',3);









