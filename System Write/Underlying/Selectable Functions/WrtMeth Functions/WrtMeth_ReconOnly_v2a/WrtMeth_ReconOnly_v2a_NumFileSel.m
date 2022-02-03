%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = WrtMeth_ReconOnly_v2a_NumFileSel(SCRPTipt,SCRPTGBL)

Status2('busy','Multiple Sdc Load',1);

err.flag = 0;
err.msg = '';

global MULTIFILELOAD

answer = inputdlg('How Many Files?','Multiple Sdc Load');
if isempty(answer)
    err.flag = 4;
    err.msg = 'Return';
    return
end
MULTIFILELOAD.numfiles = str2double(answer{1});

RWSUI = SCRPTGBL.RWSUI;
PanelScriptUpdate_B9(RWSUI.curpanipt-2,RWSUI.tab,RWSUI.panelnum);                           % becaue 'Dummies' in front

SCRPTipt = LabelGet(RWSUI.tab,RWSUI.panelnum);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.entrystr = num2str(MULTIFILELOAD.numfiles);
SCRPTipt(SCRPTGBL.RWSUI.curpanipt).entrystruct.altval = 1;

callingfuncs = SCRPTGBL.RWSUI.callingfuncs;
if isfield(SCRPTGBL,[callingfuncs{1},'_Data'])
    DataArr = SCRPTGBL.([callingfuncs{1},'_Data']);
    for n = 1:MULTIFILELOAD.numfiles
        if isfield(DataArr,['Sdc',num2str(n),'_File','_Data'])
            Data = DataArr.(['Sdc',num2str(n),'_File','_Data']);
            SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystr = Data.label;
            SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.entrystr = Data.label;
            SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.altval = 1;
            SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.selectedfile = Data.loc;
            SCRPTipt(SCRPTGBL.RWSUI.curpanipt+n).entrystruct.('LoadSDCCur').curloc = Data.path;   
            DataArr2.(['Sdc',num2str(n),'_File','_Data']) = DataArr.(['Sdc',num2str(n),'_File','_Data']);
        end
    end
    SCRPTGBL.([callingfuncs{1},'_Data']) = DataArr2;    
end
    


