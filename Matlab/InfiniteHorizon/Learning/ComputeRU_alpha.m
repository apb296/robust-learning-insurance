% This program computes the Robust Utility for an agent who consumes a
% fixed proportion of endowment - alpha

function [Coeff_alpha,Q_alpha]=ComputeRU_alpha(alpha,Para,PiGrid,PiGridDensity,NIter)
% - GET THE PARAMETERS FROM THE STRUCTURE  --------------------------------
ra=Para.RA;
MSize=Para.MSize;
Y=Para.Y;
delta=Para.delta;
P=Para.P;
P_M=Para.P_M;
grelax=Para.grelax;
ZSize=Para.ZSize;
theta1=Para.Theta(1,1);
theta2=Para.Theta(1,2);

PiMin=min(PiGrid);
PiMax=max(PiGrid);
% --Set up the grid for beliefs - this is taken to be uniform between 0 1--
PiGridSize=length(PiGrid);
OrderOfApproximation=PiGridSize/PiGridDensity;
OrderOfSpline=3;
% Define the function space structure Q_alpha[z,pi]

for z=1:ZSize
    Q_alpha(z) = fundefn('spli',OrderOfApproximation,PiMin,PiMax,OrderOfSpline);
end

% Initialize coeff for Q_alpha [z,pi] using EU guess
VFinEU0=CalcVEU(alpha,Para);
options = optimset('MaxFunEvals', 5000*length(VFinEU0),'Display','off','TolFun',1e-5);
Para.m=1;
VFin1=fsolve(@(V) CalcV(V,alpha,Para),VFinEU0,options);                    % EU value at alpha share model 1
Para.m=2;
VFin2=fsolve(@(V) CalcV(V,alpha,Para),VFinEU0,options);                     % EU value at alpha share model 2
% -- LS fit with EQ solution
for z=1:ZSize
    Coeff_alpha_0(z,:)=funfitxy(Q_alpha(z),PiGrid',[PiGrid'*VFin1(z)+(1-PiGrid')*VFin2(z)]);
end
Coeff_alpha=Coeff_alpha_0;



%--- NOW ITERATE ON FOR THE ROBUST UTILITY -----------------------------------
for i=1:NIter
    
    %tic
    for z=1:Para.ZSize
        for pi=1:PiGridSize
            
            pi_m=[PiGrid(pi) 1-PiGrid(pi)];  % vector pi
            
            % Applying Bayes Law given P,P_M and pi
            for zstar=1:ZSize
                
                % Updating the filter using bayes law (checked the code with
                % HMMFilter.m)
                for m_star_indx=1:MSize
                    Num=0;
                    for m_indx=1:MSize
                        Num=Num+P(z,zstar,m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx);
                    end
                    pi_m(m_star_indx)= Num;
                end
                D=sum(pi_m(:));
                pi_m_star= pi_m(:)/D;
                pistar(zstar)=pi_m_star(1);
                if pistar(zstar)<PiMin
                    pistar(zstar)=PiMin;
                end
                if pistar(zstar)>PiMax
                    pistar(zstar)=PiMax;
                end
                
               % Evaluate Q_alpha [z*,pi*] 
                QStar(zstar)=funeval(Coeff_alpha(zstar,:)',Q_alpha(zstar),pistar(zstar));
                
            end
            
            
            % Apply T1[m] operator
            
            for m=1:MSize
                T1(m)=u(alpha*Y(z),ra)-theta1*delta*log(sum(P(z,:,m).*exp(-QStar/theta1)))   ;
            end
            
            % Apply T2 operator
            T2=-theta2*log(exp(-T1/theta2)*([PiGrid(pi); 1-PiGrid(pi)]));
            Q_alphaNew(z,pi) = T2;
            end
        % fit new coeff
        cNew(z,:)=funfitxy(Q_alpha(z),PiGrid',Q_alphaNew(z,:)');
        cOld=Coeff_alpha;
      end
    Coeff_alpha=cOld*(1-grelax)+cNew*grelax;  
    
end


% Return the value for alpha,pi0,z0
%RU=funeval(Coeff_alpha(z0,:)',Q_alpha(z0),pi0);
