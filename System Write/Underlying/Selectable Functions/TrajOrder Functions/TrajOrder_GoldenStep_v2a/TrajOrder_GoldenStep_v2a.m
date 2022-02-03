%==================================================================
% (v2a)
%   
%==================================================================

classdef TrajOrder_GoldenStep_v2a < handle

properties (SetAccess = private)                   
    Method = 'TrajOrder_GoldenStep_v2a'
    ScnrImpProjArr
    ReconProjArr
    Panel = cell(0);
end

methods 
   
%==================================================================
% Constructor
%==================================================================  
function [TORD,err] = TrajOrder_GoldenStep_v2a(TORDipt)    
    err.flag = 0;
end

%==================================================================
% Order Trajectories
%==================================================================  
function err = OrderTrajectories(TORD,WRTMETH,IMP)
    err.flag = 0;

    %-----------------------------------------------
    % Calculate Step Through
    %-----------------------------------------------
    nproj = IMP.PSMP.ScnrNumProj;
    goldenrat = (1+sqrt(5))/2;
    step0 = (nproj)/goldenrat;
    traj(1) = 1;
    for n = 1:(nproj-1)
        traj(n+1) = rem((traj(n)+step0),nproj);
%         figure(12341); hold on;
%         plot(traj(n+1)+1,1,'*');
%         xlim([1 nproj]);
%         drawnow;
    end
    %--
%     [sorttraj,ind] = sort(traj);
%     ScnrImpProjArr0(ind) = IMP.PSMP.ScnrImpProjArr;   
%     figure(12342); hold on;
%     plot(sorttraj);     
    %--
    
    %-----------------------------------------------
    % Modify for equal step continuance
    %-----------------------------------------------
    LastStep = (nproj+1) - traj(end);
    Mod = (step0*nproj)/(step0*(nproj-1)+LastStep);
    step = step0 / Mod;
    traj(1) = 1;
    for n = 1:(nproj-1)
        traj(n+1) = rem((traj(n)+step),nproj);
%         figure(12341); hold on;
%         plot(traj(n+1)+1,1,'*');
%         xlim([1 nproj]);
%         drawnow;
    end
    [sorttraj,ind] = sort(traj);
    TestScnrImpProjArr(ind) = 1:nproj;      
    %--
%     figure(12342); hold on;
%     plot(sorttraj); 
    %--
    figure(12344); hold on;
    plot([traj traj]); 
    plot([TestScnrImpProjArr TestScnrImpProjArr]);
    ax = gca;
    ax.XTick = 1:nproj*2;
    ax.XTickLabel = [(1:nproj) (1:nproj)];
    xlim([nproj-20 nproj+20]);
    xlabel('Acq Number');
    ylabel('Traj Number');
    %--
    dif = [TestScnrImpProjArr(2:end) TestScnrImpProjArr] - [TestScnrImpProjArr TestScnrImpProjArr(1:end-1)];
    dif(dif<0) = nproj + dif(dif<0);
    figure(12345);
    plot(dif);
    %--

    %-----------------------------------------------
    % Define
    %-----------------------------------------------
    TORD.ScnrImpProjArr(ind) = IMP.PSMP.ScnrImpProjArr;     
    TORD.ReconProjArr = [TORD.ScnrImpProjArr(ind) IMP.PSMP.ScnrNotImpProjArr];
    
    %--------------------------------------------
    % Panel
    %--------------------------------------------
    TORD.Panel(1,:) = {'','','Output'};
    TORD.Panel(2,:) = {'',TORD.Method,'Output'};   
end



end
end
