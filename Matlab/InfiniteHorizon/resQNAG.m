
function [resQ,iflag]=resQNAG(n,x,iflag)
% This function computes the residual for the FOC in the No Learning cae at
% the guess c,V(high), V(low)

% -- Retriving the Paramters -------------------------------
global Q c Para z v
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
theta1=Para.Theta(1,1);
theta2=Para.Theta(2,1);
% -- ----- Control Variables --------------------------------

cons=x(1);
VStar(1)=x(2);
VStar(2)=x(2);
VStar(3)=x(3);
VStar(4)=x(3);
      



if (and(cons<Y(z),cons>0))  % Non Negativity Check
        
lambda=(der_u(cons,ra)/der_u(Y(z)-cons,ra)); % FOC with restect to cons of Agent 1

for zstar=1:ZSize
lambdastar(zstar) = -funeval(c(zstar,:)',Q(zstar),VStar(zstar),1);  % Computing Lambda(zstar) using the Envelope Theorem
QStar(zstar)=funeval(c(zstar,:)',Q(zstar),VStar(zstar));   % Computing Q(zstar)
Distfactor1(zstar)=exp(-QStar(zstar)/theta1);   % exp(-Qstar/theta1)  - Agent 1
Distfactor2(zstar)=exp(-VStar(zstar)/theta2);   % exp(-Vstar/theta2)   - Agent 2
end


EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,m_true));    % E exp {-Qstar/theta } - Agent 1
Distfactor1=Distfactor1./EQStar;                       % Radon Dikodyn derivative for Agent 1= exp(-Qstar/theta1)  / E exp {- Qstar/theta1} ;


EVStar=sum(exp(-VStar/theta2).*Para.P(z,:,m_true));     % E exp {-Vstar/theta } - Agent 2
Distfactor2=Distfactor2./EVStar;                        % Radon Dikodyn derivative for Agent 2= exp(-Vstar/theta1)  / E exp {- Vstar/theta2} ;



% -------- FOC residual with respect to Vstar ---------------------

resQVstar=lambdastar.*Distfactor1-lambda*Distfactor2;

% -------- Promise Keeping  Agent 2 ---------------------------------------

resV=u(Y(z)-cons,ra)-theta2*delta*log(EVStar)-v;

% ------ Error in FOC ----------------------------------------------

resQ=[resQVstar(1) resQVstar(3) resV ];

% ------ Error in FOC ----------------------------------------------
    
else
    
    resQ=[10 10 10].*abs(cons-Y(z))+abs(cons); % For negative consumptions

end

if isreal(resQ)==0
    
    disp('Complex values at ')
    disp(x)
    disp(resQ)
    resQ=[10 10 10].*abs(resQ);
end
end

