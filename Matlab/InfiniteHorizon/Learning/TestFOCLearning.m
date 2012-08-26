% This functions compares the FOC of Learning at pi= 0 or 1 with FOC of no
% learning. The value functions are evaluated at following choice of
% coeefecients - For No learning I use the converged coefffecient. For
% learning I use the initialized coefff.. where QL(pi=1) = QNL_1





clc
clear all
close all
SetParaStruc;

disp('set para struc done.....')
flagOverrideInitialCheck=1;
%ComputeRU_alpha(.2,1,.3,Para)

% Grid for State-Space
disp('building grid begin.....')
tic
BuildGrid;
toc
disp('building grid done.....')
flagOverrideInitialCheck=1;

InitializeC;

%citer=load( [Para.DataPath 'C_1.mat']);
citer=load( [Para.DataPath 'InitialC.mat']);
%Para=citer.Para;
clc
PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;

% Obtain the coeffs and value functions for both the cases 
%citer=load( [Para.DataPath 'C_20.mat']);
cL=citer.c;
x0=citer.x0;
Q=citer.Q;
res=[];
%res=citer.res;
CoeffRU_NL_1=load([Para.NoLearningPath 'CoeffRU_NL_1.mat']);
 QNL_1=load([ Para.NoLearningPath 'QNL_1.mat']);
QNL=QNL_1.Q;
cNL_1(1,:)=CoeffRU_NL_1.coeff(1,:);
 cNL_1(2,:)=CoeffRU_NL_1.coeff(1,:);
 cNL_1(3,:)=CoeffRU_NL_1.coeff(2,:);
 cNL_1(4,:)=CoeffRU_NL_1.coeff(2,:);
 resQNew_1=[];

for z=1:Para.ZSize
    for v=1:VGridSize
        
        
        %test Value functions
        QNL_1_Val(z,v)=funeval(cNL_1(z,:)',QNL(z),VGrid(z,v));
        QL_1_Val(z,v)=funeval(cL(z,:)',Q(z),[1 VGrid(z,v)]);
        DiffVal(z,v)=QNL_1_Val(z,v)-QL_1_Val(z,v);

  %test derivatives of Value functions
        QNL_1_der_Val(z,v)=-funeval(cNL_1(z,:)',QNL(z),VGrid(z,v),1);
        QL_1_der_Val(z,v)=-funeval(cL(z,:)',Q(z),[1 VGrid(z,v)],[0 1]);
        Diff_der_Val(z,v)=QNL_1_der_Val(z,v)-QL_1_der_Val(z,v);
        
         Para.m=1;
         cd(Para.NoLearningPath)
 resQNew_1=getQNew(z,VGrid(z,v),cNL_1,QNL,Para);
Cons_1=resQNew_1.Cons;
 VStar_1=resQNew_1.VStar;
 x=[Cons_1 VStar_1];
 
% 
 %FOC for No learning
% 
resQ([x(1) x(2) x(4)],z,VGrid(z,v),cNL_1,QNL_1.Q,Para);
% % Forc for No Learning
cd(Para.LearningPath)
resQ(x,z,1,VGrid(z,v),cL,Q,Para);
resQNew=getQNew(z,1,VGrid(z,v),c,Q,Para,x);




    end
end
figure()
plot(DiffVal')
title('QNL-QL')
figure()
plot(Diff_der_Val')
title('Der_QNL-Der_QL')

