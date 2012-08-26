% Estimate LambdaStar
   


flagComputeLambdaStarC=1;
    LambdaStarCPath=[Para.DataPath 'LambdaStar_C.mat'];
if exist(LambdaStarCPath)==2
LambdaStarC=load([Para.DataPath 'LambdaStar_C.mat']);
[err] = comp_struct(Para,LambdaStarC.Para);
if (isempty(err)==1 || flagOverrideInitialCheck==1)
    disp('Using existing initial guess')
    flagComputeLambdaStarC=0;
    LambdaStar_C=LambdaStar_C.LambdaStar_C;
    
end
end


if flagComputeLambdaStarC==1
for zstar=1:Para.ZSize
for z=1:Para.ZSize
    tic
    ctr=1;
    
    for pi=1:PiGridSize
        
        for v=1:VGridSize
             x(ctr,:)=[PiGrid(pi) VGrid(z,v)];
        LambdaStar0(ctr)=LambdaStar(z,pi,v,zstar) ; 
%      
            ctr=ctr+1;
            
        end            
        end
        
end
    LambdaStar_C(zstar,:)=funfitxy(FuncLambdaStar(zstar),x,LambdaStar0');
end

save( [Para.DataPath 'LambdaStarC.mat'], 'LambdaStar_C','Para');
    
end





