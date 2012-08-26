% This program initializes the value function iteration using the solutions
 n=1;
for z=1:Para.ZSize
    tic
    ctr=1;
    if (z==1 || z==3)
    for pi_ind=1:PiGridSize
        for v_ind=1:VGridSize
 EuRes=EUSol(z,VGrid(z,v_ind),PiGrid(pi_ind),Para);
Cons0=EuRes.Cons;
VStar0=EuRes.VStar';
QNew0=EuRes.QNewEU;
ExitFlag(z,ctr)=EuRes.exitflag;
if (isreal(QNew0))
          x(ctr,:)=[PiGrid(pi_ind) VGrid(z,v_ind)];
  
    QL0(ctr)=QNew0;
            ctr=ctr+1;
            
end 
x_state(n,:)=[z PiGrid(pi_ind) VGrid(z,v_ind)];
PolicyRules(n,:)=[Cons0 VStar0];
n=n+1;

        end
        
    end
    c(z,:)=funfitxy(Q(z),x(logical(ExitFlag(z,:)==1),:),QL0(logical(ExitFlag(z,:)==1))' );
    else
      c(z,:)=c(z-1,:);
x_state=vertcat(x_state,x_state(end-PiGridSize*VGridSize+1:end,:));
x_state(end-PiGridSize*VGridSize+1:end,1)=x_state(end-PiGridSize*VGridSize+1:end,1)+1;

    PolicyRules=vertcat(PolicyRules,PolicyRules(end-PiGridSize*VGridSize+1:end,:));
    n=n+PiGridSize*VGridSize;
    end
    
    toc
    disp('Initialized z = ');
    disp(z);
end

save( [Para.DataPath 'InitialC.mat'], 'c','Para','Q','PolicyRules','x_state')



