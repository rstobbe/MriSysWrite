%=========================================================
% 
%=========================================================

function [default] = ConvertNewStitch_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrtmethpath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\Selectable Functions\WrtSys Functions\'];
elseif strcmp(filesep,'/')
end
wrtmethfunc = 'WrtMeth_ConvOldStitch_v2a';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'SysWrt_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Wrt_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadTrajImpDef';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtMethfunc';
default{m,1}.entrystr = wrtmethfunc;
default{m,1}.searchpath = wrtmethpath;
default{m,1}.path = [wrtmethpath,wrtmethfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'SystemWrite';
default{m,1}.labelstr = 'SystemWrite';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Write';

