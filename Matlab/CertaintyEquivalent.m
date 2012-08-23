% This file computes the certainty equivalent surface for a given wealth
% level and lottery size in the theta-gamma space.

clc
clear all
close all
% ---- Paramters -----
W=1;
y=.1*W;
p=.5;
thetamin=.01;
thetamax=5;
thetagridsize=25;
gammamin=0;
gammamax=30;
gammagridsize=25;
thetagrid=linspace(thetamin,thetamax,thetagridsize);
gammagrid=linspace(gammamin,gammamax,gammagridsize);

for theta_ind=1:thetagridsize
    theta=thetagrid(theta_ind);
    for gamma_ind=1:gammagridsize
        gamma=gammagrid(gamma_ind);
        CE(theta_ind,gamma_ind)=fzero(@(c) getCEResidual( c,theta,gamma,W,y,p),y-2*p*y,optimset('display','off'));
    end
end
CE
figure()
contour(gammagrid,thetagrid,CE);
xlabel('$\gamma$','Interpreter','Latex')
ylabel('$\theta$','Interpreter','Latex')
print(gcf,'-dpng','CertaintyEq.png')


%fzero(@(c) getCEResidual( c,theta,gamma,W,y,p),0,optimset('display','iter'))