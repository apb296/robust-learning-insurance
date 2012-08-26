function DrawZ(m_draw0,z_draw,V0,pi_bayes0,Para)

close all

disp(Para.P_M)

Y=Para.Y;
delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
P_M=Para.P_M;

theta1=Para.Theta(1,1);
theta2=Para.Theta(1,2);

PiMin=Para.PiMin;
PiMax=Para.PiMax;
MSize=Para.MSize;
VSuperMax=Para.VSuperMax;
VMax=Para.VMax;
VMin=Para.VMin;
ra=Para.RA;

V(1)=V0;
pi_bayes(1)=pi_bayes0;
m_draw(1)=m_draw0;

xtest=[z_draw(1) pi_bayes(1) V(1)];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);
resQNew=getQNew(z_draw(1),pi_bayes(1),V(1),c,Q,Para,xInit);
%resQNew=getQNew(z(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,xInit)

pi_dist1(1)=resQNew.DistPi_agent1;
pi_dist2(1)=resQNew.DistPi_agent1;
MPR_draw(1)=resQNew.MPR;
Lambda_draw(1)=resQNew.Lambda;



tic
for i=2:Para.N
  
    m_dist=P_M(m_draw(i-1),:);
    m_draw(i)=discretesample(m_dist, 1);
    z_dist=P(z_draw(i-1),:,m_draw(i-1));
    z_draw(i)=discretesample(z_dist, 1);
   pi_m=[pi_bayes(i-1) 1-pi_bayes(i-1)];
   
   for m_star_indx=1:MSize
            Num=0;
            for m_indx=1:MSize
                %Num=Num+P_Z(z(i-1),z(i),m_star_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx,i-1);
                Num=Num+P(z_draw(i-1),z_draw(i),m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx);
            end
            pi_m(m_star_indx)= Num;
        end
        D=sum(pi_m(:));
        pi_m_star= pi_m(:)/D;
        
        
        
        pistar=pi_m_star(1);
        %%
  pi_bayes(i)=pi_m_star(1);

xtest=[z_draw(i-1) pi_bayes(i-1) V(i-1)];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);
resQNew=getQNew(z_draw(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,xInit);
V(i)=resQNew.VStar(z_draw(i));
pi_dist1(i)=resQNew.DistPi_agent1;
pi_dist2(i)=resQNew.DistPi_agent2;

if V(i) > VMax(z_draw(i))
    V(i)=VMax(z_draw(i));
end
if V(i) < VMin(z_draw(i))
    V(i)=VMin(z_draw(i));
end


if mod(i,Para.N/10)==0
    disp('Executing iteration..');
    disp(i);
    toc
    tic
end
MPR_draw(i)=resQNew.MPR;
Lambda_draw(i)=resQNew.Lambda;
end
save([Para.DataPath 'SimData.mat'] ,'z_draw' ,'m_draw' , 'pi_bayes','V', 'pi_dist1', 'MPR_draw','pi_dist2','Lambda_draw','Para')
  