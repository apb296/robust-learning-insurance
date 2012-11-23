function [res]=SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q,x_state,PolicyRules,DataPath,flagTransitoryIID,Shocks)
flagUseExistingDraws=0;
close all
if nargin==12
    disp('Using existing draws')
    flagUseExistingDraws=1;
end
% Recover some parameters from the structure
N=Para.N;
Y=Para.Y;
P=Para.P;
P_M=Para.P_M;
VMax=Para.VMax;
VMin=Para.VMin;



% Declare variables
V=zeros(N,1);
z_draw=zeros(N,1);
m_draw=zeros(N,1);
pi_bayes=zeros(N,1);
pi_dist1=zeros(N,1);
pi_dist2=zeros(N,1);
ConsShareAgent1=zeros(N,1);
MPR_draw=zeros(N-1,1);
Lambda_draw=zeros(N-1,1);


% Display the running case
disp(m_draw0);
disp(Para.P_M)


% Initialize the the first draw
z_draw(1)=z_draw0;
V(1)=V0;
pi_bayes(1)=pi_bayes0;
m_draw(1)=m_draw0;
xtest=[z_draw(1) pi_bayes(1) V(1)];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);
resQNew=getQNew(z_draw(1),pi_bayes(1),V(1),c,Q,Para,xInit);
pi_dist1(1)=resQNew.DistPi_agent1;
pi_dist2(1)=resQNew.DistPi_agent1;
ConsShareAgent1(1)=resQNew.Cons./Y(z_draw(1));
MPR_draw(1)=resQNew.MPR;
Lambda_draw(1)=resQNew.Lambda;
tic
for i=2:Para.N
  
    if flagUseExistingDraws==1
    m_draw(i)=Shocks.m_draw(i);
    z_draw(i)=Shocks.z_draw(i);
    else
    m_dist=P_M(m_draw(i-1),:);
    m_draw(i)=discretesample(m_dist, 1);
    z_dist=P(z_draw(i-1),:,m_draw(i-1));
    z_draw(i)=discretesample(z_dist, 1);
    end
xtest=[z_draw(i-1) pi_bayes(i-1) V(i-1)];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);

resQNew=getQNew(z_draw(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,xInit);
if ~(resQNew.ExitFlag==1)
    disp('Fixing with alternative starting point')
    xInit=xInit*(1+.1*rand);
resQNew=getQNew(z_draw(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,xInit);
disp('Result')
resQNew.ExitFlag
end

V(i)=resQNew.VStar(z_draw(i));
pi_bayes(i)=resQNew.pistar(z_draw(i));
pi_dist1(i)=resQNew.DistPi_agent1;
pi_dist2(i)=resQNew.DistPi_agent2;
ConsShareAgent1(i)=resQNew.ConsStar(z_draw(i))./Y(z_draw(i));
if V(i) > VMax(z_draw(i))
    V(i)=VMax(z_draw(i));
end
if V(i) < VMin(z_draw(i))
    V(i)=VMin(z_draw(i));
end


MPR_draw(i-1)=resQNew.MPR;
Lambda_draw(i-1)=resQNew.Lambda;

res.z_draw=z_draw;
res.m_draw=m_draw;
res.pi_bayes=pi_bayes;
res.V=V;
res.pi_dist1=pi_dist1;
res.MPR_draw=MPR_draw;
res.pi_dist2=pi_dist2;
res.Lambda_draw=Lambda_draw;
res.ConsShareAgent1=ConsShareAgent1;

end
switch flagTransitoryIID
    
    case 1
save([DataPath  'SimDataIID.mat'] ,'z_draw' ,'m_draw' , 'pi_bayes','V', 'pi_dist1', 'MPR_draw','pi_dist2','Lambda_draw','ConsShareAgent1','Para')
    case 0 
save([DataPath  'SimDataNonIID.mat'] ,'z_draw' ,'m_draw' , 'pi_bayes','V', 'pi_dist1', 'MPR_draw','pi_dist2','Lambda_draw','ConsShareAgent1','Para')
    case -1
save([DataPath 'SimData.mat'] ,'z_draw' ,'m_draw' , 'pi_bayes','V', 'pi_dist1', 'MPR_draw','pi_dist2','Lambda_draw','ConsShareAgent1','Para')
end