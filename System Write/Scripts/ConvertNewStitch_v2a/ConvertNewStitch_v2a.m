%=========================================================
% (v2a) 
%       - new object matching
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ConvertNewStitch_v2a(SCRPTipt,SCRPTGBL)

Status('busy','Write ');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('SysWrt_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Wrt_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Wrt_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Wrt_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Wrt_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Trajectory Implementation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Wrt_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Wrt_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
WRT.method = SCRPTGBL.CurrentTree.Func;
WRT.wrtmethfunc = SCRPTGBL.CurrentTree.WrtMethfunc.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Wrt_File_Data.IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTMETHipt = SCRPTGBL.CurrentTree.('WrtMethfunc');
if isfield(SCRPTGBL,('WrtMethfunc_Data'))
    WRTMETHipt.WrtMethfunc_Data = SCRPTGBL.WrtMethfunc_Data;
end

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func(WRT.wrtmethfunc);           
[WRTMETH,err] = func(WRTMETHipt);
if err.flag
    return
end
err = WRTMETH.Write(IMP);
if err.flag
    return
end

%--------------------------------------------
% Save
%--------------------------------------------
WRT.STCH = WRTMETH.STCH;
WRT.Panel = WRTMETH.Panel;
WRT.PanelOutput = WRTMETH.PanelOutput;
WRT.ExpDisp = WRTMETH.ExpDisp;
WRT.SaveScript = WRTMETH.SaveScript;
WRT.name = WRTMETH.name;
WRT.path = WRTMETH.path;
WRT.saveSCRPTcellarray = WRTMETH.saveSCRPTcellarray;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = WRT.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
if ~WRT.SaveScript 
    SCRPTGBL.RWSUI.KeepEdit = 'no';
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
else
    name = inputdlg('Name System Writing:','System Writing',[1 70],{WRT.name});
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        SCRPTGBL.RWSUI.SaveGlobal = 'no';
        return
    end
    WRT.name = name{1};

    SCRPTipt(indnum).entrystr = WRT.name;
    SCRPTGBL.RWSUI.SaveVariables = WRT;
    SCRPTGBL.RWSUI.SaveVariableNames = 'WRT';            
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    SCRPTGBL.RWSUI.SaveGlobalNames = WRT.name;
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
    SCRPTGBL.RWSUI.SaveScriptName = WRT.name;
end

Status('done','');
Status2('done','',2);
Status2('done','',3);
