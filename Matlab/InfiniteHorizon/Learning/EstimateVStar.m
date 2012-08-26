% Estimate VStar

flagComputeVStarC=1;
%
% clear VStarC
% flagOverrideInitialCheck=0
%
%     VStarCPath=[Para.DataPath 'VStar_C.mat'];
% if exist(VStarCPath)==2
% VStar_C=load([Para.DataPath 'VStar_C.mat']);
% [err] = comp_struct(Para,VStar_C.Para);
% if (isempty(err)==1 || flagOverrideInitialCheck==1)
%     disp('Using existing initial guess')
%     flagComputeVStarC=1;
%     VStarC=VStar_C.VStarC;
%
% end
% end


if flagComputeVStarC==1
    clear VStarC
    for zstar=1:Para.ZSize
        for z=1:Para.ZSize
            tic
            ctr=1;
            
            for pi=1:PiGridSize
                
                for v=1:VGridSize
                    x_v(ctr,:)=[PiGrid(pi) VGrid(z,v)];
                    VStar0(ctr)=VStar(z,pi,v,zstar) ;
                    %
                    ctr=ctr+1;
                    
                end
            end
            
        end
        VStarC(ztar,:)=funfitxy(FuncVStar(zstar),x_v,VStar0');
    end
    
    save( [Para.DataPath 'VStar_C.mat'], 'VStarC','Para');
    
end





