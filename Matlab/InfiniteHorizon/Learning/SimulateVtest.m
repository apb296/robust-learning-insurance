function SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q)

close all
clear V;
clear pi_bayes;
clear z_draw;
clear MPR_draw;
disp('..Executing exp');

disp(m_draw0);
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

CoeffRU_NL_1=load([Para.NoLearningPath 'CoeffRU_NL_1.mat']);
 CoeffRU_NL_2=load([Para.NoLearningPath 'CoeffRU_NL_2.mat']);
 QNL_1=load([ Para.NoLearningPath 'QNL_1.mat']);
 QNL_2=load([ Para.NoLearningPath 'QNL_2.mat']);
cNL_1(1,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(2,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(3,:)=CoeffRU_NL_1.coeff(2,:);
cNL_1(4,:)=CoeffRU_NL_1.coeff(2,:);
cNL_2(1,:)=CoeffRU_NL_2.coeff(1,:);
cNL_2(2,:)=CoeffRU_NL_2.coeff(1,:);
cNL_2(3,:)=CoeffRU_NL_2.coeff(2,:);
cNL_2(4,:)=CoeffRU_NL_2.coeff(2,:);
z_draw(1)=z_draw0;
V(1)=V0;
pi_bayes(1)=pi_bayes0;
m_draw(1)=m_draw0;
cd(Para.NoLearningPath)
Para.m=1;
resQNew_1=getQNew(z_draw(1),V(1),cNL_1,QNL_1.Q,Para);
Cons_1=resQNew_1.Cons;
VStar_1=resQNew_1.VStar;
QNew_1=resQNew_1.QNew;


Para.m=2;
resQNew_2=getQNew(z_draw(1),V(1),cNL_2,QNL_2.Q,Para);
Cons_2=resQNew_2.Cons;
VStar_2=resQNew_2.VStar;
QNew_2=resQNew_2.QNew;

ConsNL=pi_bayes(1)*Cons_1+(1-pi_bayes(1))*Cons_2;
VStarNL=pi_bayes(1)*VStar_1+(1-pi_bayes(1))*VStar_2;
QNewNL=pi_bayes(1)*QNew_1+(1-pi_bayes(1))*QNew_2;

           x0=[ConsNL VStarNL];

cd(Para.LearningPath)


resQNew=getQNew(z_draw(1),pi_bayes(1),V(1),c,Q,Para,x0);
%resQNew=getQNew(z(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,xInit)
pi_dist(1)=resQNew.DistPi_agent1;


MPR_draw(1)=resQNew.MPR;

for i=2:Para.N
    
    m_dist=P_M(m_draw(i-1),:);
    m_draw(i)=discretesample(m_dist, 1);
    z_dist=P(z_draw(i-1),:,m_draw(i-1));
    z_draw(i)=discretesample(z_dist, 1);
end

for i=2:Para.N
    
   pi_m=[pi_bayes(i-1) 1-pi_bayes(i-1)];
   
   
   
   
   
   for m_star_indx=1:MSize
            Num=0;
            for m_indx=1:MSize
                %Num=Num+P_Z(z(i-1),z(i),m_star_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx,i-1);
                Num=Num+P(z_draw(i-1),z_draw(i),m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx);
            end
            pi_m_u(m_star_indx)= Num;
        end
        D=sum(pi_m_u);
        pi_m_star= pi_m_u/D;
       
        
        %%
%  pi_m_star= P_M*squeeze(P(z_draw(i-1),z_draw(i),:)).*pi_m'/sum(P_M*squeeze(P(z_draw(i-1),z_draw(i),:)).*pi_m');
  pi_bayes(i)=pi_m_star(1);
%V(i)=funeval(VStarC(z_draw(i),:)',FuncVStar(z_draw(i)),[ pi_bayes(i) V(i-1)]);



% cd(Para.NoLearningPath)
% Para.m=1;
% resQNew_1=getQNew(z_draw(i-1),V(i-1),cNL_1,QNL_1.Q,Para);
% Cons_1=resQNew_1.Cons;
% VStar_1=resQNew_1.VStar;
% QNew_1=resQNew_1.QNew;
% 
% 
% Para.m=2;
% resQNew_2=getQNew(z_draw(i-1),V(i-1),cNL_2,QNL_2.Q,Para);
% Cons_2=resQNew_2.Cons;
% VStar_2=resQNew_2.VStar;
% QNew_2=resQNew_2.QNew;
% 
% ConsNL=pi_bayes(i-1)*Cons_1+(1-pi_bayes(i-1))*Cons_2;
% VStarNL=pi_bayes(i-1)*VStar_1+(1-pi_bayes(i-1))*VStar_2;
% QNewNL=pi_bayes(i-1)*QNew_1+(1-pi_bayes(i-1))*QNew_2;
% 
%            x0=[ConsNL VStarNL];
% 
% cd(Para.LearningPath)
% 
% 
% resQNew=getQNew(z_draw(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,x0);
% %resQNew=getQNew(z(i-1),pi_bayes(i-1),V(i-1),c,Q,Para,xInit)
% V(i)=resQNew.VStar(z_draw(i));
% pi_dist(i)=resQNew.DistPi_agent1;
% if V(i) > VMax(z_draw(i))
%     V(i)=VMax(z_draw(i));
% end
% if V(i) < VMin(z_draw(i))
%     V(i)=VMin(z_draw(i));
% end
% 
% 
% if mod(i,100)==0
%     disp('Executing iteration..');
%     disp(i);
% end
% MPR_draw(i)=resQNew.MPR;
end


BurnSample=.5;

%save([Para.DataPath 'VSim_' int2str(m_draw(1)) '.mat'] ,'z_draw' ,'m_draw' , 'pi_bayes','V', 'pi_dist', 'MPR_draw')
hist(pi_bayes)

  print(gcf, '-dpng', [ Para.PlotPath 'Fig_' 'VSim_' int2str(m_draw(1)) '.png'] );
  
 % close all
  
  