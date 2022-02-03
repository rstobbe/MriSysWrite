%=========================================================
%
%=========================================================

function [PRMWRT,err] = WrtParam_SiemensTPI_v1b_Func(PRMWRT,INPUT)

Status2('busy','Write Parameters for Siemens TPI',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
G = INPUT.G;
recononly = INPUT.recononly;
clear INPUT
sz = size(G);

%-------------------------------------------------
% Organize
%-------------------------------------------------
if strcmp(IMP.DES.type,'TPI')
    stype = 'TPI';
    ntype = num2str(20,'%2.0f');                        % check
end

%-------------------------------------------------
% Name Waveform
%-------------------------------------------------
id = inputdlg('Enter ID');
if isempty(id)
    err.flag = 4;
    return
end
id = id{1};
sfov = num2str(IMP.impPROJdgn.fov,'%3.0f');

test = 0;
if isfield(IMP,'ORNT')
    if isfield(IMP.ORNT,'dimx')
        ORNT = IMP.ORNT;
        test = 1;
    end
end
if test == 0
    ORNT = IMP.GWFM.ORNT;
end
dimx = round(ORNT.dimx*1000)/1000;
dimy = round(ORNT.dimy*1000)/1000;
dimz = round(ORNT.dimz*1000)/1000;
%svox = num2str(10*(IMP.impPROJdgn.vox^3)/IMP.impPROJdgn.elip,'%3.0f');
svox = num2str(10*dimx*dimy*dimz,'%3.0f');

selip = num2str(100*IMP.impPROJdgn.elip,'%3.0f');
stro = num2str(10*IMP.impPROJdgn.tro,'%3.0f');
snproj = num2str(sz(1),'%4.0f');
sp = num2str(1000*IMP.impPROJdgn.p,'%4.0f');

name = [stype,'_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_P',sp,'_ID',id];

if strcmp(recononly,'Yes')
    PRMWRT.name = name;
    PRMWRT.path = IMP.path;
    return
end

[file,path] = uiputfile('*.rws','Name Acquisition',[IMP.path,name,'.rws']);
if path == 0
    err.flag = 3;
    err.msg = 'User Aborted';
    return
end
fid = fopen([path,file],'w+');

if not(isfield(IMP.KSMP,'rSNR'))
    IMP.KSMP.rSNR = 1;
end

%-------------------------------------------------
% Write Parameter File
%-------------------------------------------------
fprintf(fid,'####################################\n');
fprintf(fid,'# R.W.Stobbe\n');
fprintf(fid,'####################################\n');
fprintf(fid,['type:',ntype,'\n']);                          
fprintf(fid,['fov:',num2str(IMP.impPROJdgn.fov,'%11.6g'),'\n']);
fprintf(fid,['x:',num2str(dimx,'%11.6g'),'\n']);
fprintf(fid,['y:',num2str(dimy,'%11.6g'),'\n']);
fprintf(fid,['z:',num2str(dimz,'%11.6g'),'\n']);
fprintf(fid,['tro:',num2str(IMP.TSMP.tro*1000,'%11.6g'),'\n']);
fprintf(fid,['nproj:',num2str(sz(1),'%11.6g'),'\n']);
fprintf(fid,['rsnr:',num2str(round(IMP.KSMP.rSNR),'%11.6g'),'\n']);
fprintf(fid,['p:',num2str(round(IMP.impPROJdgn.p*1000),'%11.6g'),'\n']);
fprintf(fid,['id:',id,'\n']);
fprintf(fid,['np:',num2str(IMP.TSMP.nproProt,'%11.6g'),'\n']);
fprintf(fid,['os:',num2str(IMP.TSMP.sysoversamp,'%11.6g'),'\n']);
fprintf(fid,['dwell:',num2str(IMP.TSMP.dwellProt*1000000,'%11.6g'),'\n']);
fprintf(fid,['tgwfm:',num2str(IMP.GWFM.tgwfm*1000,'%11.6g'),'\n']);
fprintf(fid,['gmax:',num2str(max(abs(G(:))),'%11.6g'),'\n']);
fprintf(fid,['gpts:',num2str(sz(2),'%11.6g'),'\n']);
fprintf(fid,'####################################\n');
fclose(fid);

PRMWRT.path = path;
PRMWRT.file = file;
PRMWRT.name = name;

Status2('done','',2);
Status2('done','',3);
