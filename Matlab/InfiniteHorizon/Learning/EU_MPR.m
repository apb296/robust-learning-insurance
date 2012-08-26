% this program computes the compartive statics of market price of risk for
% the case with theta_1 and theta_2=infty




function MPR=EU_MPR(alpha,ra,g)
gamma=ra;

fl=(1-((1+g)/(1-g))^(-gamma));
fh=(-1+((1-g)/(1+g))^(-gamma));
    MPR(1)=(fl*sqrt(alpha*(1-alpha)))/(1-(1-alpha)*fl);
  MPR(2)=(fh*sqrt(alpha*(1-alpha)))/(1+(1-alpha)*fh);
end
