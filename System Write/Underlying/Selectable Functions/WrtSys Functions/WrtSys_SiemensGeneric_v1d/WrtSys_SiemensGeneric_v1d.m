%=========================================================
% (v1d)
%       - WrtGrad_Siemens_v1a => default
%=========================================================

function [SCRPTipt,SYSWRT,err] = WrtSys_SiemensGeneric_v1d(SCRPTipt,SYSWRTipt)

Status2('busy','Write Trajectories for Siemens',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SYSWRT.method = SYSWRTipt.Func; 
SYSWRT.dummies = str2double(SYSWRTipt.('Dummies')); 
SYSWRT.wrtparamfunc = SYSWRTipt.('WrtParamfunc').Func;  

CallingLabel = SYSWRTipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PRMWRTipt = SYSWRTipt.('WrtParamfunc');
if isfield(SYSWRTipt,([CallingLabel,'_Data']))
    if isfield(SYSWRTipt.([CallingLabel,'_Data']),'WrtParamfunc_Data')
        PRMWRTipt.('WrtParamfunc_Data') = SYSWRTipt.([CallingLabel,'_Data']).('WrtParamfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(SYSWRT.wrtparamfunc);           
[SCRPTipt,PRMWRT,err] = func(SCRPTipt,PRMWRTipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
SYSWRT.GRDWRT.method = 'WrtGrad_Siemens_v1a';
SYSWRT.PRMWRT = PRMWRT;

Status2('done','',2);
Status2('done','',3);
