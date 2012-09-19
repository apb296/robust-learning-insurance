
function [resQ,iflag]=resQNAG(n,x,iflag)
% This function computes the residual for the FOC in the No Learning cae at
% the guess c,V(high), V(low)

% -- Retriving the Paramters -------------------------------
global Q c Para y v
ra=Para.gamma;
Y=Para.Y;
delta=Para.delta;
YSize=Para.YSize;
P1=Para.P1;
P2=Para.P2;
theta1=Para.theta_1;
theta2=Para.theta_2;
% -- ----- Control Variables --------------------------------

cons=x(1);
VStar(1)=x(2);
VStar(2)=x(3);

if (and(cons<Y(y),cons>0))  % Non Negativity Check
        
lambda=(der_u(cons,ra)/der_u(Y(y)-cons,ra)); % FOC with restect to cons of Agent 1

for ystar=1:YSize
lambdastar(ystar) = -funeval(c(ystar,:)',Q(ystar),VStar(ystar),1);  % Computing Lambda(zstar) using the Envelope Theorem
QStar(ystar)=funeval(c(ystar,:)',Q(ystar),VStar(ystar));   % Computing Q(zstar)
Distfactor1(ystar)=exp(-QStar(ystar)/theta1);   % exp(-Qstar/theta1)  - Agent 1
Distfactor2(ystar)=exp(-VStar(ystar)/theta2);   % exp(-Vstar/theta2)   - Agent 2
end


EQStar=sum(exp(-QStar/theta1).*Para.P1(y,:));    % E exp {-Qstar/theta } - Agent 1
Distfactor1=Distfactor1./EQStar;                       % Radon Dikodyn derivative for Agent 1= exp(-Qstar/theta1)  / E exp {- Qstar/theta1} ;


EVStar=sum(exp(-VStar/theta2).*Para.P2(y,:));     % E exp {-Vstar/theta } - Agent 2
Distfactor2=Distfactor2./EVStar;                        % Radon Dikodyn derivative for Agent 2= exp(-Vstar/theta1)  / E exp {- Vstar/theta2} ;



% -------- FOC residual with respect to Vstar ---------------------

resQVstar=Para.P1(y,:).*lambdastar.*Distfactor1-lambda*Para.P2(y,:).*Distfactor2;

% -------- Promise Keeping  Agent 2 ---------------------------------------

resV=u(Y(y)-cons,ra)-theta2*delta*log(EVStar)-v;

% ------ Error in FOC ----------------------------------------------

resQ=[resQVstar resV ];

% ------ Error in FOC ----------------------------------------------
    
else
    
    resQ=[10 10 10].*abs(cons-Y(y))+abs(cons); % For negative consumptions

end

if isreal(resQ)==0
    
    disp('Complex values at ')
    disp(x)
    disp(resQ)
    resQ=[10 10 10].*abs(resQ);
end
end

