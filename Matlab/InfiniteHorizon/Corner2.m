

x(1)=0;
x(2)=Para.VSuperMax(1);
x(3)=Para.VSuperMax(3);

cons=x(1);
VStar(1)=x(2);
VStar(2)=x(2);
VStar(3)=x(3);
VStar(4)=x(3);
        
for zstar=1:ZSize
QStar(zstar)=0;                                          % Computing Q(zstar)
Distfactor1(zstar)=exp(-QStar(zstar)/theta1);                                % exp(-Qstar/theta1)  - Agent 1
Distfactor2(zstar)=exp(-VStar(zstar)/theta2);                                % exp(-Vstar/theta2)   - Agent 2
end


EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,m_true));                          % E exp {-Qstar/theta } - Agent 1
Distfactor1=Distfactor1./EQStar;                                             % Radon Dikodyn derivative for Agent 1= exp(-Qstar/theta1)  / E exp {- Qstar/theta1} ;


EVStar=sum(exp(-VStar/theta2).*Para.P(z,:,m_true));                         % E exp {-Vstar/theta } - Agent 2
Distfactor2=Distfactor2./EVStar;                                            % Radon Dikodyn derivative for Agent 2= exp(-Vstar/theta1)  / E exp {- Vstar/theta2} ;

QNew=u(cons,ra)-delta*theta1*log(EQStar);                                   % Value for Agent 1



% -------Asset Pricing details---------------------------------------------
EffProb=Para.P(z,:,Para.m);                                                % Reference Probability 
ConsStar1=0;
ConsStar2=Y-ConsStar1;                                                      % Consumption plan for Agent 2 in the next period
% Consumption plan for Agent 1 in the next period
MRS=(der_u(ConsStar2,ra)./der_u(Y(z)-cons,ra)).*Distfactor2';                    % MRS (RU) = usual MRS x Radon Nikodyn for Agent 1 
MRSEU=(Y./Y(z)).^(-ra);                                                    % MRS for Expected Utility
MuMRSEU= EffProb*MRSEU;                                                    % Mean(MRS) for Expected Utility under the Reference Model
SigmaMRSEU=(EffProb*(MRSEU-MuMRSEU).^2)^.5;                                % Std (MRS) for Expected Utility under the Reference Model
MPREU=SigmaMRSEU/MuMRSEU;                                                  % Market Price of Risk  (MRS) for Expected Utility under the Reference Model
MuMRS= EffProb*MRS;                                                        % Mean(MRS) for Robust Utility under the Reference Model
SigmaMRS=(EffProb*(MRS-MuMRS).^2)^.5;                                      % Std (MRS) for Robust Utility under the Reference Model
MPR=SigmaMRS/MuMRS;                                                        % Market Price of Risk  (MRS) for Robust Utility under the Reference Model

Emlogm_distmarg_agent1=sum((Distfactor1).*log((Distfactor1)).*EffProb);    % Relative Entropy for Agent 1
Emlogm_distmarg_agent2=sum((Distfactor2).*log((Distfactor2)).*EffProb);    % Relative Entropy for Agent 2

%-------Now Store the results in resQNew structure  ----------------------
resQNew.MRS=MRS;
resQNew.Entropy_Marg_Agent1=Emlogm_distmarg_agent1;
resQNew.Entropy_Marg_Agent2=Emlogm_distmarg_agent2;
resQNew.MPR=MPR;
resQNew.RelMPR=MPR./MPREU;
resQNew.ConsStar=ConsStar1;
resQNew.ConsStarRatio=(resQNew.ConsStar./Y)./(cons/(Y(z)));
resQNew.QNew=QNew;
resQNew.Cons=cons;
resQNew.VStar=VStar;
resQNew.ConsShare=cons*Y(z)^(-1);
resQNew.LambdaStar=Inf*ones(1,length(Y));
resQNew.Fval=fval;
resQNew.ExitFlag=1;
resQNew.Lambda=Inf;
resQNew.LambdaStarL=NaN*ones(1,length(Y));
resQNew.Q=QNew;

