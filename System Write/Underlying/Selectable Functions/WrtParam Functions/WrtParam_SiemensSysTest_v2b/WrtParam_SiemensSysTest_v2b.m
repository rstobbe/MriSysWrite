%==================================================================
% (v2b)
%   
%==================================================================

classdef WrtParam_SiemensSysTest_v2b < handle

properties (SetAccess = private)                   
    Method = 'WrtParam_SiemensSysTest_v2b'
    id
    name
    file
    path
    fid
    Panel
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function WRTPARAM = WrtParam_SiemensSysTest_v2b()    
end

%==================================================================
% InitViaCompass
%==================================================================  
function err = InitViaCompass(WRTPARAM,WRTPARAMipt)    
    err.flag = 0;
end

%==================================================================
% NameWaveform
%==================================================================  
function err = NameWaveform(WRTPARAM,WRTMETH,IMPMETH)
    err.flag = 0; 
end

%==================================================================
% WriteParams
%==================================================================  
function err = WriteParams(WRTPARAM,WRTMETH)  

    err.flag = 0;
    WRTPARAM.id = inputdlg('Enter ID','ID',1,{'1'});
    if isempty(WRTPARAM.id)
        err.flag = 4;
        return
    end
    WRTPARAM.id = WRTPARAM.id{1};
    if strcmp(WRTPARAM.id,'0')
        err.flag = 1;
        err.msg = 'ID cannot be zero';
        return
    end
    
    WRTPARAM.name = ['SysTest_',WRTMETH.SysTestType,num2str(WRTPARAM.id),WRTMETH.GradDir];
    
    %-------------------------------------------------
    % Save
    %-------------------------------------------------
    [WRTPARAM.file,WRTPARAM.path] = uiputfile('*.rws','Name Acquisition',[WRTPARAM.path,WRTPARAM.name,'.rws']);
    if WRTPARAM.path == 0
        err.flag = 3;
        err.msg = 'User Aborted';
        return
    end
    WRTPARAM.fid = fopen([WRTPARAM.path,WRTPARAM.file],'w+');

    if strcmp(WRTMETH.GradDir,'X')
        dir = 1;
    elseif strcmp(WRTMETH.GradDir,'Y')
        dir = 2;
    elseif strcmp(WRTMETH.GradDir,'Z')
        dir = 3;
    end    
    
    ntype = num2str(WRTMETH.SysTestTypeNum,'%2.0f');
    
    %-------------------------------------------------
    % Write Parameters
    %-------------------------------------------------
    fprintf(WRTPARAM.fid,'####################################\n');
    fprintf(WRTPARAM.fid,'# R.W.Stobbe\n');
    fprintf(WRTPARAM.fid,'####################################\n');
    fprintf(WRTPARAM.fid,['type:',ntype,'\n']);                           % update
    fprintf(WRTPARAM.fid,['id:',num2str(WRTPARAM.id,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['nproj:',num2str(WRTMETH.TotalTrajNum,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['tro:',num2str(round(WRTMETH.tro*100)*10,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['np:',num2str(WRTMETH.np2scnr,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['os:',num2str(WRTMETH.os,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['dwell:',num2str(WRTMETH.dwell2scnr*1000000,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['tgwfm:',num2str(WRTMETH.tgwfm*1000,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['gmax:',num2str(WRTMETH.gmax,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['dir:',num2str(dir,'%11.6g'),'\n']);   
    fprintf(WRTPARAM.fid,['gpts:',num2str(WRTMETH.gpts,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,'####################################\n');
    fclose(WRTPARAM.fid); 
end

end
end




