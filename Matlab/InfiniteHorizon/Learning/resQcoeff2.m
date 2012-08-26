function resQcoeff=resQcoeff2(coeff,Q,Para)
c(1,:)=coeff(1,:);
c(2,:)=coeff(1,:);
c(3,:)=coeff(2,:);
c(4,:)=coeff(2,:);

Y=Para.Y;
delta=Para.delta;
VGridSize=Para.VGridSize;
VGrid=Para.VGrid;
ctol=Para.ctol;
grelax=Para.grelax;
      

for z=1:Para.ZSize
               if (z==1 || z==3) 

    for v=1:VGridSize
        
  resQNew=getQNew(z,VGrid(z,v),c,Q,Para);
QNew(z,v)=resQNew.QNew;
    end
    
    cNew(z,:)=funfitxy(Q(z),VGrid(z,:)',QNew(z,:)');
    else
        cNew(z,:)=cNew(z-1,:);
    end    
    
    end
    cOld=c;

    
     
    
c=cOld*(1-grelax)+cNew*grelax;
resQcoeff=cOld([1 3],:)-c([1 3],:);
%resQcoeff=sum(abs(cOld([1 3],:)-c([1 3],:)));

end
