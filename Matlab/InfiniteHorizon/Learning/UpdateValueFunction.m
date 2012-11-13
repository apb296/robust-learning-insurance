% This program updates the value function

for z=1:Para.ZSize
    ExitFlag_z=ExitFlag((z-1)*GridSize/ZSize+1:z*GridSize/ZSize);

    IndxSolved=(z-1)*GridSize/ZSize+(find(ExitFlag_z==1));
IndxUnSolved=(find(~(ExitFlag_z==1)));
cNew(z,:)= funfitxy(Q(z),x_state(IndxSolved,2:end),QNew(IndxSolved)' );

% Compute derivatives 
Indx_z=find(x_state(:,1)==z);
Indx_zz=find(xCheckShape(:,1)==z);
MonotonicityCheck=funeval(cNew(z,:)',Q(z),x_state(Indx_z,2:end),[0 1])<0;
ConcavityCheck=funeval(cNew(z,:)',Q(z),x_state(Indx_z,2:end),[0 1])<0;
ShapeCheck=MonotonicityCheck.*ConcavityCheck;
IndxShapeProblem= Indx_z(logical(ShapeCheck==0));

if ~(isempty(IndxShapeProblem))
ShapeConstr=[xCheckShape(Indx_zz,2:end);x_state(IndxUnSolved,2:end) ; x_state(IndxShapeProblem,2:end)];
[ cNew(z,:) ] = FitConcaveValueFunction(Q(z),QNew(IndxSolved)',x_state(IndxSolved,2:end),ShapeConstr);
end
end

    cOld=c;
     
     c=cOld*(1-grelax)+cNew*grelax;






































