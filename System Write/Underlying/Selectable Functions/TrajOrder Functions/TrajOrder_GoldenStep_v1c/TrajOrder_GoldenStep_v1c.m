%=====================================================
% (v1c)
%       - stepping update for continuation
%=====================================================

function [SCRPTipt,TORD,err] = TrajOrder_GoldenStep_v1c(SCRPTipt,TORDipt)

Status2('busy','Write Trajectory Order',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TORD.method = TORDipt.Func;

Status2('done','',2);
Status2('done','',3);









