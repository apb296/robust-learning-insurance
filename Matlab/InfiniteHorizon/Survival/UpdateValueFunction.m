% This program updates the value function

for y=1:Para.YSize
    ExitFlag_y=ExitFlag((y-1)*Para.GridSize/Para.YSize+1:y*Para.GridSize/Para.YSize);
IndxSolved=(y-1)*Para.GridSize/Para.YSize+(find(ExitFlag_y==1));
IndxUnSolved=(find(~(ExitFlag_y==1)));
%cNew(y,:)= funfitxy(Q(y),x_state(IndxSolved,2:end),QNew(IndxSolved)' );
 [ cNew(y,:) ] = FitConcaveValueFunction(Q(y),QNew(IndxSolved)',x_state(IndxSolved,2:end),x_state(IndxSolved,2:end))';
end
    cOld=c;
     
     c=cOld*(1-Para.grelax)+cNew*Para.grelax;
%funfitxy(Q(y),x_state(IndxSolved,2:end),QNew(IndxSolved)' )-FitConcaveValueFunction(Q(y),QNew(IndxSolved)',x_state(IndxSolved,2:end),x_state(IndxSolved(end-5:end),2:end))
