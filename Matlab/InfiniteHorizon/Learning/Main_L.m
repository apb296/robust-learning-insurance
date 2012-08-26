% This solves the infinite horizon no learning case
clc
clear all
close all
addpath(genpath('C:\Program Files\MATLAB\R2010b\toolbox\compecon2011'));
cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\Learning');

%addpath(genpath('/Applications/MATLAB_R2011a_Student.app/toolbox/compecon2011/'))
%matlabpool open

% Parameters for the Model
SetParaStruc;
disp('set para struc done.....')


%ComputeRU_alpha(.2,1,.3,Para)

% Grid for State-Space
BuildGrid;
disp('building grid done.....')
disp('Initializing coeffecients begin.....')
InitializeC;
disp('Initializing coeffecients done.....')
%load('coeffEU.mat');
c0=CoeffRU_L_0;


%  load('coeffRU_win_final.mat')
%  c0(1,:)=coeff(1,:);
% c0(2,:)=coeff(1,:);
%c0(3,:)=coeff(2,:);
% c0(4,:)=coeff(2,:);

%der_c=der_c_EU0;


c=c0;
for i=1:NIter
    disp('Starting Iteration No')
    disp(i)
    
    tic
    for z=1:Para.ZSize
        ctr=1;
        for pi=1:PiGridSize
            
            for v=1:VGridSize
                x(ctr,:)=[PiGrid(pi) VGrid(z,v)];
                
                
                
                resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)));
                
                QNew(ctr)=resQNew.Q;
                
                ctr=ctr+1;
            end
        end
        cNew(z,:)= funfitxy(Q(z),x,QNew' );
        
    end
    cOld=c;
    
    c=cOld*(1-grelax)+cNew*grelax;
    cdiff(i,:)=sum(abs(cOld-c));
    %
    %
    toc
    %
    
end
save('InitGuessCoeff_L.mat','c')
options = optimset('Display','iter','TolFun',ctol,'FunValCheck','on','TolX',ctol);
coeff=fsolve(@(coeff) resQcoeff(coeff,Q,Para,x0) ,c,options);


z=1
pi=2
v=VGridSize-2
VGrid
cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon')
cNL_1(1,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(2,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(3,:)=CoeffRU_NL_1.coeff(2,:);
cNL_1(4,:)=CoeffRU_NL_1.coeff(2,:);
resQNew_1=getQNew(z,VGrid(z,v),cNL_1,QNL_1.Q,Para);
Cons_1=resQNew_1.Cons
VStar_1=resQNew_1.VStar
QNew_1=resQNew_1.QNew;

cNL_2(1,:)=CoeffRU_NL_2.coeff(1,:);
cNL_2(2,:)=CoeffRU_NL_2.coeff(1,:);
cNL_2(3,:)=CoeffRU_NL_2.coeff(2,:);
cNL_2(4,:)=CoeffRU_NL_2.coeff(2,:);

resQNew_2=getQNew(z,VGrid(z,v),cNL_2,QNL_2.Q,Para);
Cons_2=resQNew_2.Cons
VStar_2=resQNew_2.VStar
QNew_2=resQNew_2.QNew;

ConsNL=PiGrid(pi)*Cons_1+(1-PiGrid(pi))*Cons_2
VStarNL=PiGrid(pi)*VStar_1+(1-PiGrid(pi))*VStar_2
QNewNL=PiGrid(pi)*QNew_1+(1-PiGrid(pi))*QNew_2
           x0(z,pi,v,:)=[ConsNL VStarNL];
             QL0(ctr)=QNewNL;
cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\Learning')

xInit=squeeze(x0(z,pi,v,:))
 for zstar=1:Para.ZSize
        % Applying Bayes rule to update the state variable pi (probability of
        % model 1)
        
        
        pistar(zstar)=pi*P(z,zstar,1)/(pi*P(z,zstar,1)+(1-pi)*P(z,zstar,2))   ;
        
        % This adjustment keeps the pi within the bounds of state space
        
        if pistar(zstar)<PiMin
            pistar(zstar)=PiMin;
        end
        if pistar(zstar)>PiMax
            pistar(zstar)=PiMax;
        end
 end
 
tic
resQFast(xInit,z,PiGrid(pi),VGrid(z,v),c,Q,Para);
toc
tic
resQ(xInit,z,PiGrid(pi),VGrid(z,v),c,Q,Para);
toc
tic

for z=1:1
v=1;
pi=1;
VGrid(z,v)
squeeze(x0(z,pi,v,2:end))
resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)));
resQNew.VStar
end
theta1=Para.Theta(1,1)
theta2=Para.Theta(1,2)
tic
v=4
VGrid(z,v)
pi=10 % model 1
cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\')
Para.m=1;
ResNL=getQNew(z,VGrid(z,v),cNL_1,QNL_1.Q,Para)
 resQ([ResNL.Cons ResNL.VStar(1) ResNL.VStar(3) ],z,VGrid(z,v),cNL_1,QNL_1.Q,Para)
 EVStar=sum(exp(-ResNL.VStar/theta1).*Para.P(z,:,1)); 
 -theta1*delta*log(EVStar)
xInit=squeeze(x0(z,pi,v,:))
cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\Learning')
for m=1:MSize
    ee=sum(Para.P(z,:,1).*exp(-ResNL.VStar/theta1))
               T1_agent2(1)=-theta1*log(ee)   ;
end
delta*T1_agent2(1)
    -theta2*log(exp(-(u(Y(z)-ResNL.Cons)+delta*T1_agent2)/theta2)*([PiGrid(pi); 1-PiGrid(pi)]))
resQ([ResNL.Cons ResNL.VStar],z,PiGrid(pi),VGrid(z,v),c,Q,Para)

resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)));
resQNew=getQNew(z,PiGrid(pi),35,c,Q,Para,squeeze(x0(z,pi,v,:)));
%funeval(c(z,:)',Q(z),[ PiGrid(1) VGrid(z,v)])
toc
%load('x_complex.mat')
%resQ(x,z,PiGrid(pi),VGrid(z,v),c,Q,Para)
tic
z=1
v=1
pi=10
resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)))
toc