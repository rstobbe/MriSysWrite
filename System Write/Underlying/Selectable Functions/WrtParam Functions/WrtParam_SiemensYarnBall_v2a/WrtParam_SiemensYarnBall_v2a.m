%==================================================================
% (v2a)
%   
%==================================================================

classdef WrtParam_SiemensYarnBall_v2a < handle

properties (SetAccess = private)                   
    Method = 'WrtParam_SiemensYarnBall_v2a'
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
function [WRTPARAM,err] = WrtParam_SiemensYarnBall_v2a(WRTPARAMipt)    
    err.flag = 0;
end

%==================================================================
% NameWaveform
%==================================================================  
function err = NameWaveform(WRTPARAM,WRTMETH,IMPMETH)
    err.flag = 0;
    KINFO = IMPMETH.KINFO(1);
    for n = 1:2
        SPIN = IMPMETH.DES.GENPRJ(n).SPIN;
        if SPIN.AziSampFact ~= 0
            break
        end
    end
    ind = strfind(IMPMETH.name,'ID');
    if isempty(ind)
        WRTPARAM.id = '';
    else
        WRTPARAM.id = IMPMETH.name(ind+2:end);
    end
    input{1} = WRTPARAM.id;
    WRTPARAM.id = inputdlg('Enter ID','ID',1,input);
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
    sfov = num2str(KINFO.fov,'%3.0f');
    svox = num2str(10*(KINFO.vox^3)/KINFO.Elip,'%3.0f');
    selip = num2str(100*KINFO.Elip,'%3.0f');
    stro = num2str(10*KINFO.tro,'%3.0f');
    snproj = num2str(WRTMETH.TotalTrajNum,'%4.0f');
    sp = num2str(1000*SPIN.p,'%4.0f');
    if strcmp(SPIN.type,'Uniform') || strcmp(SPIN.type,'Worsted')
        sspin = num2str(10,'%2.0f');
    elseif strcmp(SPIN.type,'LinearDecrease')
        sspin = num2str(20,'%2.0f');
    end
    susamp = num2str(str2double(SPIN.number),'%4.0f');
    stype = 'YB';
    WRTPARAM.name = [stype,'_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_P',sp,'_S',sspin,susamp,'_ID',WRTPARAM.id];   
end

%==================================================================
% WriteParams
%==================================================================  
function err = WriteParams(WRTPARAM,WRTMETH,IMPMETH)  

    err.flag = 0;
    KINFO = IMPMETH.KINFO(1);
    for n = 1:2
        SPIN = IMPMETH.DES.GENPRJ(n).SPIN;
        if SPIN.AziSampFact ~= 0
            break
        end
    end
    TSMP = IMPMETH.TSMP;
    SYS = IMPMETH.SYS;
    GRAD = IMPMETH.GRAD;

    %-------------------------------------------------
    % Save
    %-------------------------------------------------
    [WRTPARAM.file,WRTPARAM.path] = uiputfile('*.rws','Name Acquisition',[IMPMETH.path,WRTPARAM.name,'.rws']);
    if WRTPARAM.path == 0
        err.flag = 3;
        err.msg = 'User Aborted';
        return
    end
    WRTPARAM.fid = fopen([WRTPARAM.path,WRTPARAM.file],'w+');

    %-------------------------------------------------
    % Things
    %-------------------------------------------------
    if strcmp(SPIN.type,'Uniform') || strcmp(SPIN.type,'Worsted')
        sspin = num2str(10,'%2.0f');
    elseif strcmp(SPIN.type,'LinearDecrease')
        sspin = num2str(20,'%2.0f');
    end
    ntype = num2str(10,'%2.0f');
    nusamp = num2str(str2double(SPIN.number)/100,'%4.2f');

    %-------------------------------------------------
    % Write Parameters
    %-------------------------------------------------
    fprintf(WRTPARAM.fid,'####################################\n');
    fprintf(WRTPARAM.fid,'# R.W.Stobbe\n');
    fprintf(WRTPARAM.fid,'####################################\n');
    fprintf(WRTPARAM.fid,['type:',ntype,'\n']);                          
    fprintf(WRTPARAM.fid,['fov:',num2str(KINFO.fov,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['x:',num2str(KINFO.dimnorm,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['y:',num2str(KINFO.dimnorm,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['z:',num2str(KINFO.dimelip,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['tro:',num2str(round(KINFO.tro*100)*10,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['nproj:',num2str(WRTMETH.TotalTrajNum,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['rsnr:',num2str(round(1),'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['p:',num2str(round(SPIN.p*1000),'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['spin:',sspin,'\n']);
    fprintf(WRTPARAM.fid,['usamp:',nusamp,'\n']);
    fprintf(WRTPARAM.fid,['id:',WRTPARAM.id,'\n']);
    fprintf(WRTPARAM.fid,['np:',num2str(TSMP.ScnrPtsProt,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['os:',num2str(SYS.SysOverSamp,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['dwell:',num2str(TSMP.DwellProt*1000000,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['tgwfm:',num2str(GRAD.GetGradDuration*1000,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['t2cen:',num2str(round(KINFO.SamplingTimeToCentre*100)*10,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['gmax:',num2str(GRAD.GetMaxAbsGrad,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,['gpts:',num2str(GRAD.GetGradPts,'%11.6g'),'\n']);
    fprintf(WRTPARAM.fid,'####################################\n');
    fclose(WRTPARAM.fid);   
end

end
end




