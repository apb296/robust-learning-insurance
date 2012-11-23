%% Finite State Hidden Markov Models
% This program investigates the steady state properties of finite state -
% space model. The hidden states are parameters (regimes) that populate the
% transition matrix of the signal distribution. 
clear all
%% Model 
% Size of Model Space M
MSize=2;

% Transition for M

P_M=[1 0;
     0 1];
% Model space - alpha_m,beta_m
% Signal Structure
%Model 1 
p_ylow_ylow(1)=.5;
p_ylow_yhigh(1)=1-p_ylow_ylow(1);
p_yhigh_yhigh(1)=.5;
p_yhigh_ylow(1)=1-p_yhigh_yhigh(1);
p_slow_ylow(1)=.5;
p_shigh_ylow(1)=1-p_slow_ylow(1);
p_slow_yhigh(1)=.5;
p_shigh_yhigh(1)=1-p_slow_yhigh(1);
%Model 2
p_ylow_ylow(2)=.9;
p_ylow_yhigh(2)=1-p_ylow_ylow(2);
p_yhigh_yhigh(2)=.9;
p_yhigh_ylow(2)=1-p_yhigh_yhigh(2);
p_slow_ylow(2)=.9;
p_shigh_ylow(2)=1-p_slow_ylow(2);
p_slow_yhigh(2)=.5;
p_shigh_yhigh(2)=1-p_slow_yhigh(2);



for m =1:MSize
    P_Z(:,:,m) = [p_ylow_ylow(m)*p_slow_ylow(m) p_ylow_ylow(m)*p_shigh_ylow(m) p_ylow_yhigh(m)*p_slow_yhigh(m) p_ylow_yhigh(m)*p_shigh_yhigh(m) 
        p_ylow_ylow(m)*p_slow_ylow(m) p_ylow_ylow(m)*p_shigh_ylow(m) p_ylow_yhigh(m)*p_slow_yhigh(m) p_ylow_yhigh(m)*p_shigh_yhigh(m) 
        p_yhigh_ylow(m)*p_slow_ylow(m) p_yhigh_ylow(m)*p_shigh_ylow(m) p_yhigh_yhigh(m)*p_slow_yhigh(m) p_yhigh_yhigh(m)*p_shigh_yhigh(m) 
        p_yhigh_ylow(m)*p_slow_ylow(m) p_yhigh_ylow(m)*p_shigh_ylow(m) p_yhigh_yhigh(m)*p_slow_yhigh(m) p_yhigh_yhigh(m)*p_shigh_yhigh(m) 
        ];
end


 
% 
% for m =1:MSize
%     P(:,:,m) = [c*alpha(m)*beta(m) alpha(m)*(1-c*beta(m)) c*(1-alpha(m))*beta(m) (1-alpha(m))*(1-c*beta(m));
%         alpha(m)*(1-c*beta(m)) c*alpha(m)*beta(m) (1-alpha(m))*(1-c*beta(m)) c*(1-alpha(m))*beta(m);
%         (1-alpha(m))*beta(m)  (1-alpha(m))*(1-beta(m)) alpha(m)*beta(m) alpha(m)*(1-beta(m));
%         (1-alpha(m))*(1-beta(m))  (1-alpha(m))*(beta(m)) alpha(m)*(1-beta(m)) alpha(m)*(beta(m))
%         ];
% end

%% Simulation
% Number of draws -  N
N=2;
% Simulate Data of length N from the Model
m(1)=2;
z(1)=1;
z=[1 4]
for i=2:N
    
    m_dist=P_M(m(i-1),:);
    m(i)=discretesample(m_dist, 1);
    z_dist=P_Z(z(i-1),:,m(i-1));
   % z(i)=discretesample(z_dist, 1);
end

%% Filter
pi_m(:,1)=[.5 .5];

for i=2:N
for m_star_indx=1:MSize
    Num=0;
    for m_indx=1:MSize
    %Num=Num+P_Z(z(i-1),z(i),m_star_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx,i-1);
    Num=Num+P_Z(z(i-1),z(i),m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx,i-1)
    end
    pi_m(m_star_indx,i)= Num
end
D=sum(pi_m(:,i))
pi_m(:,i)= pi_m(:,i)/D
%pi_m_star= P_M*squeeze(P_Z(z(i-1),z(i),:)).*pi_m(:,i-1)/sum(P_M*squeeze(P_Z(z(i-1),z(i),:)).*pi_m(:,i-1));
end
pi_m
BurnSample=N*.7;
hist(pi_m(1,BurnSample:end))
