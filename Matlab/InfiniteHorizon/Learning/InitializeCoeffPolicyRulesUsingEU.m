function [c,PolicyRules] =InitializeCoeffPolicyRulesUsingEU(Para,x_state,Q)
% this function initializes the coeffecients and the policy rules using the
% expected utility solution

GridSize=Para.GridSize;
ZSize=Para.ZSize;


zSlice=x_state(:,1);                                                        % isolate the first component of the domain - z
PiSlice=x_state(:,2);                                                       % isolate the second component of the domain - Pi
vSlice=x_state(:,3);                                                        % isolate the third component of the domain - v
for GridInd=1:GridSize
    z=zSlice(GridInd);                                                      % z
    v=vSlice(GridInd);                                                      % v - promised value to agent 2
    pi=PiSlice(GridInd);                                                    % pi - model priors
    
    if (z==1 || z==3)                                                          % solve for y(z)=y_l or y(z)=y_h
        EuRes=EUSol(z,v,pi,Para);                                                   % get the EU solution for z,v,pi
        Cons0=EuRes.Cons;                                                           % EU solution : consumption of agent 1
        VStar0=EuRes.VStar';                                                        % EU solution : Promised values for agent 2
        QNew0=EuRes.QNewEU;                                                         % EU solution : Agent 1 values
        
 % -- Store the solution in the Array ------------------------------------       
        QNew(GridInd)=QNew0;        
        PolicyRules(GridInd,:)=[Cons0 VStar0];
        ExitFlag(GridInd,:)=EuRes.exitflag;
        
    end
    
end
QNew(GridSize/4+1:2*GridSize/4)=QNew(1:GridSize/4);
QNew(3*GridSize/4+1:GridSize)=QNew(GridSize/2+1:3*GridSize/4);

PolicyRules(GridSize/4+1:2*GridSize/4,:)=PolicyRules(1:GridSize/4,:);
PolicyRules(3*GridSize/4+1:GridSize,:)=PolicyRules(GridSize/2+1:3*GridSize/4,:);
ExitFlag(GridSize/4+1:2*GridSize/4)=ExitFlag(1:GridSize/4);
ExitFlag(3*GridSize/4+1:GridSize)=ExitFlag(GridSize/2+1:3*GridSize/4);

% -- update the coeffecients  ------------------------------------------
for z=1:Para.ZSize
    ExitFlag_z=ExitFlag((z-1)*GridSize/ZSize+1:z*GridSize/ZSize);
IndxSolved=(z-1)*GridSize/ZSize+(find(ExitFlag_z==1));
c(z,:)= funfitxy(Q(z),x_state(IndxSolved,2:end),QNew(IndxSolved)' );
end
 


