
% This program computes the Robust Utility for an agent who consumes a
% fixed proportion of endowment - alpha
function RU=RobustUtilityAlpha(alpha,z,pi,Para)



% Set the value of alpha r the share of the agregate endowmwnt
alphamin=alpha;


% Set up the grid for beliefs - this is taken to be uniform between 0 1 

PiMin=0.001;
PiMax=.999;
PiGridSize=20;
OrderOfApproximation=5;
OrderOfSpline=5;
PiGrid=linspace(PiMin,PiMax,PiGridSize);
theta1=Para.Theta(1,1);
theta2=Para.Theta(1,2);

ZSize=Para.ZSize;
% Define the function space structure 

for z=1:ZSize
    Q_alpha(z) = fundefn('cheb',OrderOfApproximation,PiMin,PiMax,OrderOfSpline);
end

% Initialize using EU guess
VFinEU0=CalcVEU(alphamin,Para); 
options = optimset('MaxFunEvals', 5000*length(VFinEU0),'Display','off','TolFun',1e-5);
Para.m_true=2;
VFin1=fsolve(@(V) CalcV(V,alphamin,Para),VFinEU0,options);
Para.m_true=2;
VFin2=fsolve(@(V) CalcV(V,alphamin,Para),VFinEU0,options);



for z=1:ZSize
Coeff_alpha_0(z,:)=funfitxy(Q_alpha(z),PiGrid',[ones(PiGridSize/2,1)*VFin1(z);ones(PiGridSize/2,1)*VFin2(z)]);
end
Coeff_alpha=Coeff_alpha_0;
 for i=1:25
     
     tic
     for z=1:Para.ZSize
                     
             for pi=1:PiGridSize
                 
                 for zstar=1:ZSize
                    pistar=PiGrid(pi)*Para.P(z,zstar,1)/(PiGrid(pi)*Para.P(z,zstar,1)+(1-PiGrid(pi))*Para.P(z,zstar,2))   ;          
                    if pistar<PiMin
                        pistar=PiMin;
                    end
                    if pistar>PiMax
                        pistar=PiMax;
                    end
          
                    
                    QStar(zstar)=funeval(Coeff_alpha(zstar,:)',Q_alpha(zstar),pistar);

                 end

                
                 % T1 operator
                 
                 for m=1:MSize
                 T1(m)=u(alphamin*Y(z))-theta1*delta*log(sum(P(z,:,m).*exp(-QStar/theta1)))   ;
                 end

                % Apply T2 operator
                T2=-theta2*log(exp(-T1/theta2)*([PiGrid(pi); 1-PiGrid(pi)]));
                 
                 Q_alphaNew(z,pi) = T2;
                
                 
                 
             end
%             
             cNew(z,:)=funfitxy(Q_alpha(z),PiGrid',Q_alphaNew(z,:)');
%         
     cOld=Coeff_alpha;
%     
     end
%     
%     
     Coeff_alpha=cOld*(1-grelax)+cNew*grelax;
    cdiff(i,:)=sum(abs(cOld-Coeff_alpha))
%     
%     
     toc
%     
 
 end



RU=funeval(Coeff_alpha(z,:)',Q_alpha(z),pi);
