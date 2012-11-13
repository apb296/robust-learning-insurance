function [ res ] = ResMPRHighLow(x,pi,pitildlow,PIID,PNonIID)
%UNTITLED Summary of  function goes here
%   Detailed explanation goes here

dist_pi_low= pitildlow; % distorted mixture probability in we have a recession
dist_pi_high=x(1); % distorted mixture probability in we have a boom

% low state
EffProb=pi.*PIID(1,:)+(1-pi)*PNonIID(1,:);
DistProb=dist_pi_low.*PIID(1,:)+(1-dist_pi_low)*PNonIID(1,:);
logmlow=log(DistProb./EffProb);
Elogm_low=sum(logmlow.*EffProb);
Elog2m_low=sum(EffProb.*log((DistProb./EffProb)).^2);
VarELogMlow=sqrt(Elog2m_low-(Elogm_low)^2);


% highstate
EffProb=pi.*PIID(2,:)+(1-pi)*PNonIID(2,:);
DistProb=dist_pi_high.*PIID(2,:)+(1-dist_pi_high)*PNonIID(2,:);
logmhigh=log(DistProb./EffProb);
Elogm_high=sum(logmhigh.*EffProb);
Elog2m_high=sum(EffProb.*log(DistProb./EffProb).^2);
VarELogMhigh=sqrt(Elog2m_high-(Elogm_high)^2);

res=VarELogMlow-VarELogMhigh;
end

