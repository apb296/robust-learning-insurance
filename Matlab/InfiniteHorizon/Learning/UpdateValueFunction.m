% This program updates the value function

for z=1:Para.ZSize
    ExitFlag_z=ExitFlag((z-1)*GridSize/ZSize+1:z*GridSize/ZSize);
IndxSolved=(z-1)*GridSize/ZSize+(find(ExitFlag_z==1));
IndxUnSolved=(find(~(ExitFlag_z==1)));
cNew(z,:)= funfitxy(Q(z),x_state(IndxSolved,2:end),QNew(IndxSolved)' );
end
    cOld=c;
     
     c=cOld*(1-grelax)+cNew*grelax;













































