function [ res] = getCEResidual( c,theta,gamma,W,y,p)
% This function computes the residual from teh definition of certainty eq
% at the guess c
if ~(gamma==1)
uh=((W+y)^(1-gamma))/(1-gamma); % utility with good draw
ul=((W-y)^(1-gamma))/(1-gamma); % utility with bad draw
RU=-theta*log(exp(-uh/theta)*p+ exp(-ul/theta)*(1-p)); % Robust utility from the lottery
res=((W-c)^(1-gamma)/(1-gamma))-RU; %residual for certainty eq
else % LOG CASE
    uh=log(W+y); % utility with good draw
ul=log(W-y); % utility with bad draw
RU=-theta*log(exp(-uh/theta)*p+ exp(-ul/theta)*(1-p)); % Robust utility from the lottery

res=log(W-c)-RU; %residual for certainty eq
end

