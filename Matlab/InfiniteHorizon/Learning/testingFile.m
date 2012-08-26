citer=load( [Para.DataPath 'C_' '1' '.mat']);
c=citer.c;
Q=citer.Q;
x0=citer.x0;   

citer=load( [Para.DataPath 'InitialC.mat']);
cold=citer.c;
x0=citer.x0;   

cold
for i=1:50
citer=load( [Para.DataPath 'C_' num2str(i) '.mat']);
cdiff(i,:)=sum(abs(citer.c-cold));
cold=citer.c
end   
    

addpath(genpath(Para.CompEconPath));
PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;
% clear LambdaStarL
% clear VStar
% clear DelVStar
% clear ExitFlag
citer=load( [Para.DataPath 'C_' '20' '.mat']);
c=citer.c;
Q=citer.Q;
x0=citer.x0;   

z=3
pi=PiGridSize


CoeffRU_NL_1=load([Para.NoLearningPath 'CoeffRU_NL_1.mat']);
 CoeffRU_NL_2=load([Para.NoLearningPath 'CoeffRU_NL_2.mat']);
 QNL_1=load([ Para.NoLearningPath 'QNL_1.mat']);
 QNL_2=load([ Para.NoLearningPath 'QNL_2.mat']);

cNL_1(1,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(2,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(3,:)=CoeffRU_NL_1.coeff(2,:);
cNL_1(4,:)=CoeffRU_NL_1.coeff(2,:);
    
    for v=1:VGridSize
        
 
Para.m=1;
        cd(Para.NoLearningPath)

resQNew_1=getQNew(z,VGrid(z,v),cNL_1,QNL_1.Q,Para)
        
      %  resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)))  ;
      cd(LearningPath)
     resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)))  

        LambdaStarL(v,:)=resQNew_1.LambdaStar/(resQNew_1.Lambda);
        
        
    end
figure()
 
 plot(VGrid(z,:),LambdaStarL)
 
 close all
X.Data=(LambdaStarL);
X.Name='$\frac{\lambda^{*}}{\lambda}$';
X.FigName='LambdaStarRatio';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)

    X.Data=(DelVStar);
X.Name='$\Delta V^*$';
X.FigName='DelVStar';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)


clc

citer=load( [Para.DataPath 'InitialC.mat']);

c=citer.c;
x0=citer.x0;   
VEUmax0=CalcVEU(1,Para)
VMax=fsolve(@(V) CalcV(V,1,Para),VEUmax0,options)

z=3
pi=10
v=15
squeeze(x0(z,pi,v,:))
vv=VGrid(z,v)
for z=1:4
resQNew=getQNew(1,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(1,pi,v,:))*.9)  
Para.VSuperMax
end
vv=VGrid(z,v)
for z=1:4
resQNew=getQNew(1,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(1,pi,v,:))*.9)  
Para.VSuperMax
end

% resQNew=getQNew(1,PiGrid(pi),vv,c,Q,Para,squeeze(x0(1,pi,v,:)))  
% resQNew=getQNew(2,PiGrid(pi),vv,c,Q,Para,squeeze(x0(2,pi,v,:)))  
% resQNew=getQNew(3,PiGrid(pi),vv,c,Q,Para,squeeze(x0(3,pi,v,:)))  
% resQNew=getQNew(4,PiGrid(pi),vv,c,Q,Para,squeeze(x0(4,pi,v,:)))  