% This solves the infinite horizon no learning case
clc
clear all
close all
addpath(genpath('C:\Program Files\MATLAB\R2010b\toolbox\compecon2011'))
%addpath(genpath('/Applications/MATLAB_R2011a_Student.app/toolbox/compecon2011/'))
%matlabpool open

% Parameters for the Model
SetParaStruc;


% Grid for State-Space
BuildGridNL;
% 
  InitializeCNL;
  load('coeffEU.mat');
  c0=cEU0;

%  load('coeffRU_win_final.mat')
%  c0(1,:)=coeff(1,:);
% c0(2,:)=coeff(1,:);
%c0(3,:)=coeff(2,:);
% c0(4,:)=coeff(2,:);

%der_c=der_c_EU0;
c=c0;
for i=1:10
    tic
    for z=1:Para.ZSize
        if (z==1 || z==3)
            
            for v=1:VGridSize
                
                resQNew=getQNew(z,VGrid(z,v),c,Q,Para);
                QNew(z,v)=resQNew.QNew;
                Cons(z,v)=resQNew.Cons;
                
            end
            
            cNew(z,:)=funfitxy(Q(z),VGrid(z,:)',QNew(z,:)');
        else
            cNew(z,:)=cNew(z-1,:);
        end
        
    end
    cOld=c;
    
    
    
    
    c=cOld*(1-grelax)+cNew*grelax;
    cdiff(i,:)=sum(abs(cOld-c));
    
    
    toc
    
end
%matlabpool close
save('InitGuessCoeff.mat','c')
options = optimset('Display','iter','TolFun',ctol,'FunValCheck','on','TolX',ctol);
c0=c([1 3],:);
coeff=fsolve(@(coeff) resQcoeff2(coeff,Q,Para) ,c0,options);
% 
% save('coeffRU_win_temp.mat','coeff')
% load('coeffRU_win_temp.mat')
% randdim=size(coeff);
% noise_min=.999;
% noise_max=1.001;
% noise=noise_min+(noise_max-noise_min)*rand(randdim);
% c0=coeff.*noise;
% coeff=fsolve(@(coeff) resQcoeff2(coeff,Q,Para) ,c0,options);
% load('coeffRU_NL_1.mat');
% load('coeffRU_NL_2.mat');

CoeffFileName=['CoeffRU_NL_' int2str(Para.m) '.mat'];
FSpaceFileName=['QNL_' int2str(Para.m) '.mat'];
save(FSpaceFileName,'Q');
save(CoeffFileName,'coeff');
load(CoeffFileName);
c(1,:)=coeff(1,:);
c(2,:)=coeff(1,:);
c(3,:)=coeff(2,:);
c(4,:)=coeff(2,:);

for z=1:Para.ZSize
    
    for v=1:VGridSize
        resQNew=getQNew(z,VGrid(z,v),c,Q,Para);
        QNew(z,v)=resQNew.QNew;
        Cons(z,v)=resQNew.Cons;
        ConsShare(z,v)=resQNew.ConsShare;
        LambdaStarRatio(z,v)=resQNew.LambdaStar(2)/resQNew.LambdaStar(3);
        VStar=resQNew.VStar;
        for zstar=1:Para.ZSize
        resQNew=getQNew(zstar,VStar(zstar),c,Q,Para);
        ConsShareStar(z,v,zstar)=resQNew.ConsShare;
        end
        
    end
    
end
save('consRU_win.mat','Cons','ConsShare')


%matlabpool close force localConsShare
