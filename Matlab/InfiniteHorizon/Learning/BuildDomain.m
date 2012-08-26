% This program initializes the value function iteration using the solutions
 n=1;
for z=1:Para.ZSize
    tic
    if (z==1 || z==3)
    for pi_ind=1:PiGridSize
        for v_ind=1:VGridSize
x_state(n,:)=[z PiGrid(pi_ind) VGrid(z,v_ind)];
n=n+1;

        end
        
    end
x_state=vertcat(x_state,x_state(end-PiGridSize*VGridSize+1:end,:));
x_state(end-PiGridSize*VGridSize+1:end,1)=x_state(end-PiGridSize*VGridSize+1:end,1)+1;
    n=n+PiGridSize*VGridSize;
    end
    
    toc
  
end




