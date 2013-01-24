function [] = PKResidualForSimpleContract(x,v,Para)

% get components from Para struc
pl=Para.pl;
ph=Para.ph;
ra=Para.ra;
beta=Para.beta;
y=Para.y;
Delta=Para.Delta;
Theta=Para.Theta;
theta_21=Theta(2,1);

c(1)=x(1);
c(2)=c(1)+Delta;
bar_vstar(1)=x(2);
bar_vstar(2)=x(2);

U21=u(y-c(1),ra)+beta*bar_vstar(1);
U22=u(y-c(1),ra)+beta*bar_vstar(2);


res=-theta_21*log(pl*(exp(-U21/theta_21))+ph*(exp(-U22/theta_21)))-v;
end
