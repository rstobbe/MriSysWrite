%=========================================================
% 
%=========================================================

function [default] = WrtMeth_SiemensYarnball_v2a_Default2(SCRPTPATHS)

wrparampath = [SCRPTPATHS.pioneerloc,'System Write',filesep,'Underlying',filesep,'zz Underlying',filesep,'WrtParam Functions',filesep];
wrttrajorderpath = [SCRPTPATHS.pioneerloc,'System Write',filesep,'Underlying',filesep,'zz Underlying',filesep,'TrajOrder Functions',filesep];

wrttrajorderfunc = 'TrajOrder_GoldenStep_v2a';
wrparamfunc = 'WrtParam_SiemensYarnBall_v2a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Dummies';
default{m,1}.entrystr = 0;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajOrderfunc';
default{m,1}.entrystr = wrttrajorderfunc;
default{m,1}.searchpath = wrttrajorderpath;
default{m,1}.path = [wrttrajorderpath,wrttrajorderfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparamfunc;
default{m,1}.searchpath = wrparampath;
default{m,1}.path = [wrparampath,wrparamfunc];

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'NumAcqs';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'WrtMeth_SiemensYarnball_v2a_NumFileSel';

global MULTIFILELOAD
if isempty(MULTIFILELOAD)
    return
end
for n = 1:MULTIFILELOAD.numfiles
    m = m+1;
    default{m,1}.entrytype = 'RunExtFunc';
    default{m,1}.labelstr = ['Sdc',num2str(n),'_File'];
    default{m,1}.entrystr = '';
    default{m,1}.buttonname = 'Select';
    default{m,1}.runfunc1 = 'LoadSDCCur';
    default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.experimentsloc;
    default{m,1}.runfunc2 = 'LoadSDCDef';
    default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.experimentsloc;
end


