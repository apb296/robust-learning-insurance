% This small program computes the initializes the value function with EU
% coeffecients
ctr=1;
x_state=ones(GridSize,2);
PolicyRules=ones(GridSize,3);
for z=1:Para.ZSize
for vind=1:VGridSize
res=EUSol(z,VGrid(z,vind),Para); % Sove the EU case for state variables z,V
EU(z,vind)=res.V1(z);
 x_state(ctr,:)=[z,VGrid(z,vind)];
         ConsEU0=res.alpha1*Para.Y(z);  
       VStarEU0=res.V2';
       [ConsEU0 VStarEU0(1) VStarEU0(3)];
 PolicyRules(ctr,:)=[ConsEU0 VStarEU0(1) VStarEU0(3)];
 ctr=ctr+1;
 
end
% Compute the initial coeffecient for EU case
cEU0(z,:)=funfitxy(Q(z),VGrid(z,:)',EU(z,:)');
end
% Check that coeffecients are real
if isreal(cEU0)
    disp('Initial Coeff are real')
    disp(cEU0)
save('Data/coeffEU.mat','cEU0');
else 
       disp('Initial Coeff are complex')
end


zSlice=x_state(:,1);
vSlice=x_state(:,2);
