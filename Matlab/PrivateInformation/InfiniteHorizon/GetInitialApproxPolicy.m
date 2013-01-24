function [PolicyInit,xref]=GetInitialApproxPolicy(xTarget,xStore,PolicyRulesStore)

%distance=(sum(((xStore-repmat(xTarget,length(xStore),1)).^2),1)).^.5;
distance=sum((xStore-repmat(xTarget,length(xStore),1)).^2,2);

[~, ref_id]=min(distance);
PolicyInit=PolicyRulesStore(ref_id,:);
xref=xStore(ref_id,:);
end

