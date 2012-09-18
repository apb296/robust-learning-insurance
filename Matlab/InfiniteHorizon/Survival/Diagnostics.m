% Diagnostics
clear all
close all
load(['/ersistent/Data/C_25.mat'])
Y=Para.Y
VGrid=Para.VGrid;
z=3
zstar=3
pi=1;
VFineGridSize=50;
VFineGrid=linspace(min(VGrid(z,:)),max(VGrid(z,:)),VFineGridSize)
ConsStarRatio=zeros(VFineGridSize,1);
ExitFlag=zeros(VFineGridSize,1);
for vind=1:VFineGridSize
xInit=GetInitalPolicyApprox([z pi VFineGrid(vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VFineGrid(vind),c,Q,Para,xInit);
ExitFlag(vind)=resQNew.ExitFlag;
ConsStarRatio(vind)=(resQNew.ConsStar(zstar)/(Y(zstar)))/(resQNew.Cons/(Y(z)));
LambdaStarL(vind)=resQNew.LambdaStarL(zstar);
QNew(vind)=resQNew.Q;
end
figure()
plot(VFineGrid(logical(ExitFlag==1)),LambdaStarL(logical(ExitFlag==1)))
figure()
plot(VFineGrid(logical(ExitFlag==1)),ConsStarRatio(logical(ExitFlag==1)))
figure()
plot(VFineGrid(logical(ExitFlag==1)),QNew(logical(ExitFlag==1)))

