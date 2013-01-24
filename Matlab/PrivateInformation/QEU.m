function [Q,gradQ]=QEU(x,z_,Para)

% This program computes the Value function for the expected
% utility case. It also computes the gradients
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

Q=-(P(z_,1)*(u(c(1),ra)+delta*Qstar(1,1))+ P(z_,2)*(u(c(2),ra)+delta*Qstar(2,2)));
gradQ=-[der_u(c(1),ra)*P(z_,1) der_u(c(2),ra)*P(z_,2) -lambdastar(1,1)*delta*P(z_,1) -delta*P(z_,2)*lambdastar(2,2)];
if ~isreal(Q) || ~isreal(gradQ)
    Q=abs(Q)+100;
    gradQ=abs(gradQ)*1000;
end