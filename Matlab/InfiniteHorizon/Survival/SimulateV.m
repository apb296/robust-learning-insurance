function [y_draw V]=SimulateV(y_draw0,V0,Para,c,Q,x_state,PolicyRules,dgp)
close all
P1=Para.P1;
P2=Para.P2;
VMax=max(Para.VGrid');
VMin=min(Para.VGrid');
y_draw(1)=y_draw0;
V(1)=V0;
xtest=[y_draw(1) V(1)];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);
resQNew=getQNew(y_draw(1),V(1),c,Q,Para,xInit);
tic
for i=2:Para.N
    switch dgp
        case 'RefModelAgent1'
           y_dist=P1(y_draw(i-1),:);
        case 'RefModelAgent2'
           y_dist=P2(y_draw(i-1),:);
            case 'DistModelAgent1'
            y_dist=P1(y_draw(i-1),:).*resQNew.Distfactor1;   
            case 'DistModelAgent2'
            y_dist=P2(y_draw(i-1),:).*resQNew.Distfactor2;   
    end
    
    y_draw(i)=discretesample(y_dist, 1);
   
xtest=[y_draw(i-1) V(i-1)];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);
resQNew=getQNew(y_draw(i-1),V(i-1),c,Q,Para,xInit);
V(i)=resQNew.VStar(y_draw(i));

if V(i) > VMax(y_draw(i))
    V(i)=VMax(y_draw(i));
end
if V(i) < VMin(y_draw(i))
    V(i)=VMin(y_draw(i));
end


if mod(i,Para.N/10)==0
    disp('Executing iteration..');
    disp(i);
    toc
    tic
end
end

