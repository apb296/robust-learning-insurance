function xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules)
%distance=(sum(((xStore-repmat(xTarget,length(xStore),1)).^2),1)).^.5;
distance=sum((x_state-repmat(xtest,length(x_state),1)).^2,2);
[~, ref_id]=min(distance);
xInit=PolicyRules(ref_id,:);

end
