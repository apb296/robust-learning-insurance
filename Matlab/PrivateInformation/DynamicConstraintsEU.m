% This program computes the Dynamic Incentive and Promise Keeping Constraints for the expected
% utility case. It also computes the gradients
 function [CINQ, CEQ,  gradCINQ, gradCEQ ] = DynamicConstraintsEU(x,v0,z_,Para)
% v0 is the exante promised utility
% z_ is the state previous period
% These both are the state variables for the Optimization.
% c(1),c(2) are components of the consumption plan for z_1 and z_2
% bar_vstar(1),bar_vstar(2) are the mean of the continuation plans

% get components from x
c=x(1:2);
bar_vstar=x(3:4);


% get components from Para struc
P=Para.P(:,:,Para.m_true);
ra=Para.RA;
delta=Para.delta;
y=Para.y;
sl=Para.sl;
sh=Para.sh;
Delta=y*(sh-sl);



% Terminal Period 
%% This section computes the multiplier associated with PK and the value function in the terminal period corresponding to guessed bar_vstar. Note that the envelope condition links lambdastar=Qstar_v(vstar,z)
lambdastar=zeros(2,2);
for z_indx=1:2
    for vstar_indx=1:2
        cstar0=u_inv(bar_vstar(vstar_indx),ra);
        options=optimset('Display','off');
       
        cstar = fzero(@(cstar) TerminalPKEU(cstar,bar_vstar(vstar_indx),z_indx,Para),[.001 y-Delta-.001],options);
        % From the FOC of the terminal period
        lambdastar(vstar_indx,z_indx)=[der_u(cstar,ra) der_u(cstar+Delta,ra)]*P(z_indx,:)'/([der_u(y-cstar,ra) der_u(y-cstar-Delta,ra)]*P(z_indx,:)');
        Qstar(vstar_indx,z_indx)=u(cstar,ra)*P(z_indx,1)+u(cstar+Delta,ra)*P(z_indx,2);
    end
end








%% Promisekeeping for Agent 2

CEQ=(u(y-c,ra)+delta*bar_vstar)*P(z_,:)'-v0;
gradCEQ=[-der_u(y-c(1),ra)*P(z_,1) -der_u(y-c(2),ra)*P(z_,2)  delta*P(z_,1) delta*P(z_,2)]';
%PK=CEQ;
%gradPK=gradCEQ';
%CEQ=[];
%gradCEQ=[];
%% Incentive Constraints. Note the convention - I am writing the constraints as g(x)<=0

% 1) Agent 1, z=z_1
IC_1_1 = u(c(1),ra)-u(c(2)-Delta,ra)+delta*(Qstar(1,1)-Qstar(2,1));
% 2) Agent 1, z=z_2
IC_1_2 = u(c(2),ra)-u(c(1)+Delta,ra)+delta*(Qstar(2,2)-Qstar(1,2));
% 3) Agent 2, z=z_1
IC_2_1 = u(y-c(1),ra)-u(y-c(2)+Delta,ra)+delta*(bar_vstar(1)-bar_vstar(2));
% 4) Agent 2, z=z_2
IC_2_2 = u(y-c(2),ra)-u(y-c(1)-Delta,ra)+delta*(bar_vstar(2)-bar_vstar(1));

CINQ=-[IC_1_1 IC_1_2 IC_2_1 IC_2_2 ];


% This computes the gradient on the inequality constraints  -  the rows are
% the constraints and the columns are the control variables



gradCINQ=-[der_u(c(1),ra) -der_u(c(2)-Delta,ra) -delta*lambdastar(1,1)    delta*lambdastar(2,1) ;
    
-der_u(c(1)+Delta,ra) der_u(c(2),ra) delta*lambdastar(1,2)    -delta*lambdastar(2,2) ;

-der_u(y-c(1),ra) der_u(y-c(2)+Delta,ra) delta    -delta ;

der_u(y-c(1)-Delta,ra) -der_u(y-c(2),ra)  -delta    delta ;

]';
end



