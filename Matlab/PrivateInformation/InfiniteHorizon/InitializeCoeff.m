function [ domain, c, PolicyRulesStore] = InitializeCoeff( Para, Q)   
beta=Para.beta;
pl=Para.pl;
ph=Para.ph;
theta_21=Para.Theta(2,1);
theta_11=Para.Theta(1,1);
ra=Para.ra;
Delta=Para.Delta;
y=Para.y;
ComputeValueForSimpleContractAgent2=@(c) (1/(1-beta)) *(-theta_21*log(pl(2).*exp(-u(y-c,ra)./theta_21)+ph(2).*exp(-u(y-c-Delta,ra)./theta_21)));
ComputeValueForSimpleContractAgent1=@(c) (1/(1-beta)) *(-theta_11*log(pl(1).*exp(-u(c,ra)./theta_11)+ph(1).*exp(-u(c+Delta,ra)./theta_11)));

for vind=1:Para.vGridSize
    v=Para.vGrid(vind);
    ResComputeValueForSimpleContract = @(c) (1/(1-beta)) *(-theta_21*log(pl(2).*exp(-u(y-c,ra)./theta_21)+ph(2).*exp(-u(y-c-Delta,ra)./theta_21))) -v;
    c=fzero(@(c) ResComputeValueForSimpleContract(c),[ Para.c_offset y-Delta-Para.c_offset]);
    QNew(vind)=ComputeValueForSimpleContractAgent1(c);
PolicyRulesStore(vind,:)=[c c+Delta ComputeValueForSimpleContractAgent2(c) ComputeValueForSimpleContractAgent2(c)];
end
domain=Para.vGrid;
c=funfitxy(Q,domain',QNew');

end
