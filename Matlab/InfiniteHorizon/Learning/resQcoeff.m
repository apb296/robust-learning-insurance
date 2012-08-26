function resQcoeff=resQcoeff(coeff,Q,Para,x0)
tic
c=coeff;

Y=Para.Y;
delta=Para.delta;
VGridSize=Para.VGridSize;
VGrid=Para.VGrid;
ctol=Para.ctol;
grelax=Para.grelax;
PiGrid=Para.PiGrid;
PiGridSize=Para.PiGridSize;

for z=1:Para.ZSize
    ctr=1;
    for pi=1:PiGridSize
        
        for v=1:VGridSize
            x(ctr,:)=[PiGrid(pi) VGrid(z,v)];
            
            
            
            resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)));
            
            QNew(ctr)=resQNew.Q;
            
            ctr=ctr+1;
        end
    end
    cNew(z,:)= funfitxy(Q(z),x,QNew' );
    
end
cOld=c;

c=cOld*(1-grelax)+cNew*grelax;
%
resQcoeff=c;
toc
end
