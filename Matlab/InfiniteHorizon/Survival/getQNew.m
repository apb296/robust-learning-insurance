 
function resQNew=getQNew(yy,vv,cc,QQ,PPara,x0)
global Q c Para y v

%-------Get the Para from the struct --------------------------------------
Para=PPara;
y=yy;
v=vv;
c=cc;
Q=QQ;
YSize=Para.YSize;
theta1=Para.theta_1;
theta2=Para.theta_2;
VGrid=Para.VGrid;
delta=Para.delta;
Y=Para.Y;
ra=Para.gamma;

% ------- Default initialization to EU solution ---------------------------


if isempty(x0)
res=EUSol(y,v,Para);
        ConsEU0=res.alpha1*Para.Y(y);  
       VStarEU0=res.V2';
       x0=[ConsEU0 VStarEU0];
end


% -- v=0 or v=max(VGrid(y,:)) --------------------------------------------
if v==0
QStar=max(VGrid,[],2)'; 
VStar=[0 0];
for ystar=1:YSize
Distfactor1(ystar)=exp(-QStar(ystar)/theta1);   % exp(-Qstar/theta1)  - Agent 1
Distfactor2(ystar)=exp(-VStar(ystar)/theta2);   % exp(-Vstar/theta2)   - Agent 2
end
EQStar=sum(exp(-QStar/theta1).*Para.P1(y,:));    % E exp {-Qstar/theta } - Agent 1
Distfactor1=Distfactor1./EQStar;                       % Radon Dikodyn derivative for Agent 1= exp(-Qstar/theta1)  / E exp {- Qstar/theta1} ;


EVStar=sum(exp(-VStar/theta2).*Para.P2(y,:));            % E exp {-Vstar/theta } - Agent 2
Distfactor2=Distfactor2./EVStar;                        % Radon Dikodyn derivative for Agent 2= exp(-Vstar/theta1)  / E exp {- Vstar/theta2} ;

    
 resQNew.QNew=Para.QMax(y);
 resQNew.Cons=Y(y);
 resQNew.VStar=VStar;
 resQNew.ConsShare=1;
 resQNew.LambdaStar=0;
 resQNew.ExitFlag=1;
 resQNew.Lambda=0;
 resQNew.LambdaStarL=NaN;
 resQNew.Distfactor1=Distfactor1;
 resQNew.Distfactor2=Distfactor2;
 
elseif v==max(VGrid(y,:))
    QStar=[0 0];
VStar=max(VGrid,[],2)';
for ystar=1:YSize
Distfactor1(ystar)=exp(-QStar(ystar)/theta1);   % exp(-Qstar/theta1)  - Agent 1
Distfactor2(ystar)=exp(-VStar(ystar)/theta2);   % exp(-Vstar/theta2)   - Agent 2
end
EQStar=sum(exp(-QStar/theta1).*Para.P1(y,:));    % E exp {-Qstar/theta } - Agent 1
Distfactor1=Distfactor1./EQStar;                       % Radon Dikodyn derivative for Agent 1= exp(-Qstar/theta1)  / E exp {- Qstar/theta1} ;

EVStar=sum(exp(-VStar/theta2).*Para.P2(y,:));            % E exp {-Vstar/theta } - Agent 2
Distfactor2=Distfactor2./EVStar;                        % Radon Dikodyn derivative for Agent 2= exp(-Vstar/theta1)  / E exp {- Vstar/theta2} ;

     resQNew.QNew=0;
 resQNew.Cons=0;
 resQNew.VStar=VStar;
 resQNew.ConsShare=0;
 resQNew.LambdaStar=Inf;
 resQNew.ExitFlag=1;
 resQNew.Lambda=Inf;
 resQNew.LambdaStarL=NaN;
  resQNew.Distfactor1=Distfactor1;
 resQNew.Distfactor2=Distfactor2;
else

% ------- Solve the FOC with NAG toolbox ----------------------------------

 warning('off', 'NAG:warning')
[x, fval,exitflag]=c05nb('resQNAG',x0);
if exitflag==4
    x=x0;
    exitflag=-2;
else
    exitflag=1;
end


% -------Compute the rest of the objects using the solution ---------------

% -- ----- Control Variables --------------------------------

cons=x(1);
VStar(1)=x(2);
VStar(2)=x(3);

        
lambda=(der_u(cons,ra)/der_u(Y(y)-cons,ra)); % FOC with restect to cons of Agent 1

for ystar=1:YSize
lambdastar(ystar) = -funeval(c(ystar,:)',Q(ystar),VStar(ystar),1);  % Computing Lambda(ystar) using the Envelope Theorem
QStar(ystar)=funeval(c(ystar,:)',Q(ystar),VStar(ystar));   % Computing Q(ystar)
Distfactor1(ystar)=exp(-QStar(ystar)/theta1);   % exp(-Qstar/theta1)  - Agent 1
Distfactor2(ystar)=exp(-VStar(ystar)/theta2);   % exp(-Vstar/theta2)   - Agent 2
end


EQStar=sum(exp(-QStar/theta1).*Para.P1(y,:));    % E exp {-Qstar/theta } - Agent 1
Distfactor1=Distfactor1./EQStar;                       % Radon Dikodyn derivative for Agent 1= exp(-Qstar/theta1)  / E exp {- Qstar/theta1} ;


EVStar=sum(exp(-VStar/theta2).*Para.P2(y,:));     % E exp {-Vstar/theta } - Agent 2
Distfactor2=Distfactor2./EVStar;                        % Radon Dikodyn derivative for Agent 2= exp(-Vstar/theta1)  / E exp {- Vstar/theta2} ;




QNew=u(cons,ra)-delta*theta1*log(EQStar);                                   % Value for Agent 1


% -------Asset Pricing details---------------------------------------------
% EffProb=Para.P(ystar,:,Para.m);                                                % Reference Probability 
% ConsStar1=Y-Y.*((1+lambdastar.^(-1/ra))'.^-1);                              % Consumption plan for Agent 1 in the next period
% MRS=(der_u(ConsStar1,ra)./der_u(cons,ra)).*Distfactor1';                    % MRS (RU) = usual MRS x Radon Nikodyn for Agent 1 
% ConsStar2=Y-ConsStar1;                                                      % Consumption plan for Agent 2 in the next period
% MRSEU=(Y./Y(y)).^(-ra);                                                    % MRS for Expected Utility
% MuMRSEU= EffProb*MRSEU;                                                    % Mean(MRS) for Expected Utility under the Reference Model
% SigmaMRSEU=(EffProb*(MRSEU-MuMRSEU).^2)^.5;                                % Std (MRS) for Expected Utility under the Reference Model
% MPREU=SigmaMRSEU/MuMRSEU;                                                  % Market Price of Risk  (MRS) for Expected Utility under the Reference Model
% MuMRS= EffProb*MRS;                                                        % Mean(MRS) for Robust Utility under the Reference Model
% SigmaMRS=(EffProb*(MRS-MuMRS).^2)^.5;                                      % Std (MRS) for Robust Utility under the Reference Model
% MPR=SigmaMRS/MuMRS;                                                        % Market Price of Risk  (MRS) for Robust Utility under the Reference Model
% 
% Emlogm_distmarg_agent1=sum((Distfactor1).*log((Distfactor1)).*EffProb);    % Relative Entropy for Agent 1
% Emlogm_distmarg_agent2=sum((Distfactor2).*log((Distfactor2)).*EffProb);    % Relative Entropy for Agent 2
% 
% %-------Now Store the results in resQNew structure  ----------------------
% resQNew.MRS=MRS;
% resQNew.Entropy_Marg_Agent1=Emlogm_distmarg_agent1;
% resQNew.Entropy_Marg_Agent2=Emlogm_distmarg_agent2;
% resQNew.MPR=MPR;
% resQNew.RelMPR=MPR./MPREU;
% resQNew.ConsStar=ConsStar1;
% resQNew.ConsStarRatio=(resQNew.ConsStar./Y)./(cons/(Y(y)));
 resQNew.QNew=QNew;
 resQNew.Cons=cons;
 resQNew.VStar=VStar;
 resQNew.ConsShare=cons*Y(y)^(-1);
 resQNew.LambdaStar=lambdastar;
 resQNew.Fval=fval;
 resQNew.ExitFlag=exitflag;
 resQNew.Lambda=lambda;
 resQNew.LambdaStarL=lambdastar./lambda;
   resQNew.Distfactor1=Distfactor1;
 resQNew.Distfactor2=Distfactor2;

% resQNew.Q=QNew;
end
end


% -- EXTRA CODE Not Used --
%options = optimset('MaxFunEvals', 5000*length(x0),'Display','off','TolFun',ctol);
%options = optimset('Display','off','TolFun',ctol,'FunValCheck','off','TolX',ctol,'MaxFunEvals', 5000*length(x0));
%  [x fval exitflag]=fsolve(@(x) resQ(x,y,v,c,Q,Para),x0,options);
% 
% if ~(exitflag==1)
%     opts = optimset('Algorithm','sqp','MaxIter',1000, 'MaxFunEvals',1000,...
%      'TolX', Para.ctol, 'TolFun', Para.ctol, 'TolCon', Para.ctol,'Display','iter');
%   lb=[0 0 0];
%   ub=[Y(y) VSuperMax(1) VSuperMax(3)];
% [x,fval,exitflag,output,lambda,grad] = fmincon(@(x) ValueFunction(x,y,c,Q,Para) ,x,[],[],[],[],lb,ub,@(x) PromiseKeeping(x,v ,y,Para),opts);
% if exitflag>0
%     exitflag=1;
% end
% end 