%=========================================================
% 
%=========================================================

function [default] = WrtSys_SiemensGeneric_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    wrparampath = [SCRPTPATHS.pioneerloc,'System Write\Underlying\zz Underlying\WrtParam Functions\'];
elseif strcmp(filesep,'/')
end
wrparamfunc = 'WrtParam_SiemensYarnBall_v1d';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Dummies';
default{m,1}.entrystr = 0;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'WrtParamfunc';
default{m,1}.entrystr = wrparamfunc;
default{m,1}.searchpath = wrparampath;
default{m,1}.path = [wrparampath,wrparamfunc];

