%% Private Information
% This is the main file to execute the private information economy. I begin
% with the case of no aggregate risk. The agents have either a low
% endowment or a high endowment with a constant aggregate endowment. Denote
% z1 - (ys_l,ys_h) and z2 - (ys_h,ys_l) . Agent 1 has high endowment in z_2
% and vice versa.

clc
clear all
close all
%% Parameters
% This sets up the struture for the paramters and writes a tex file with
% table
SetParaStruc
Param=[y; sl ; sh; 1-beta(1);1-beta(2) ;Para.RA; Para.delta; Para.Theta(1,1);Para.Theta(1,2)];
rowLabels = {'Agggregate Income ($y$)', 'Low share of Endowment ($s_l$)', 'High share of Endowment ($s_h$)', 'Probability of switching - Model 1 (1-$\beta_1$)','Probability of switching - Model 2 (1-$\beta_2$)','Risk Aversion ($\gamma$)', 'Subjective Discount Factor($\delta$)', 'Ambiguity - Observable State ($\theta_1$)','Ambiguity - Hidden State ($\theta_2$)' };
columnLabels = {'Description', 'Value'};
matrix2latex(Param, [Para.TexPath 'Param.tex'] , 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.2f', 'size', 'tiny');

%% Grid for initial promised value
alphamin=0.01*y;
alphamax=1-(sh-sl);
alphamax=alphamax*.99;
for z=1:Para.ZSize
    for m=1:length(M)
        V_minm(z,m)=u(y*alphamin,ra)-delta*theta11*log(sum(exp(-u(y*alphamin,ra)'/theta11).*P(z,:,m)));
        V_maxm(z,m)=u(y*alphamax,ra)-delta*theta11*log(sum(exp(-u(y*alphamax,ra)'/theta11).*P(z,:,m)));
        
        
    end
    V_min(z)=-theta12*log(sum(pi'.*exp(-V_minm(z,:)/theta12)));
    V_max(z)=-theta12*log(sum(pi'.*exp(-V_maxm(z,:)/theta12)));
    VGrid(z,:)=linspace(V_min(z),V_max(z),Para.VGridSize);
end
Para.VGrid=VGrid;

% The above code is exessive - there is no risk in the alphamin/alphamax so
% we need only the EU at the deterministic allocation. but maybe it might
% be useful later when i introduce aggregate risk

% %%
Para.Theta=Para.Theta;
for z=1:ZSize
    
    for v_ind=1:VGridSize
        
        res(z,v_ind)=getQNew(z,VGrid(z,v_ind),Para);
        VStar(z,v_ind,:)=res(z,v_ind).VStar;
        Cons(z,v_ind)=res(z,v_ind).Cons;
        lambda(z,v_ind)=res(z,v_ind).lambda;
        cStar(z,v_ind,:)=res(z,v_ind).cStar;
       Mu(z,v_ind,:)=res(z,v_ind).Mu;
        cStarRatio(z,v_ind,:)=cStar(z,v_ind,:)/Cons(z,v_ind);
        DistMarg_agent_1(z,v_ind,:)=res(z,v_ind).DistMarg_agent_1(1);
        DistMarg_agent_2(z,v_ind,:)=res(z,v_ind).DistMarg_agent_2(2);
       
        DistPi_agent_1(z,v_ind)=res(z,v_ind).DistPi_agent_1(1);
        DistPi_agent_2(z,v_ind)=1-res(z,v_ind).DistPi_agent_2(1);
        %RelDistPi_agent_1(z,v_ind)=res(z,v_ind).DistPi_agent_1(1)/Para.Pi(1,1);
        RelDistPi_agent_1(z,v_ind)=DistPi_agent_1(z,v_ind)/DistPi_agent_2(z,v_ind);
        
    end
end
Para.Theta=Para.Theta*100000000;
for z=1:ZSize
    
    for v_ind=1:VGridSize
       
        resBM(z,v_ind)=getQNew(z,VGrid(z,v_ind),Para);
        VStarBM(z,v_ind,:)=resBM(z,v_ind).VStar;
        ConsBM(z,v_ind)=resBM(z,v_ind).Cons;
        lambdaBM(z,v_ind)=resBM(z,v_ind).lambda;
        cStarBM(z,v_ind,:)=resBM(z,v_ind).cStar;
        cStarRatioBM(z,v_ind,:)=cStarBM(z,v_ind,:)/ConsBM(z,v_ind);
        DistP_agent_1BM(z,v_ind,:)=resBM(z,v_ind).DistP_agent_1(1,1);
       MuBM(z,v_ind,:)=resBM(z,v_ind).Mu; 
       
       DistMarg_agent_1BM(z,v_ind,:)=resBM(z,v_ind).DistMarg_agent_1(1,1);
        DistMarg_agent_2BM(z,v_ind,:)=resBM(z,v_ind).DistMarg_agent_2(2,1);
%        DistPi_agent_1BM(z,v_ind)=resBM(z,v_ind).DistPi_agent_1;
        DistPi_agent_2BM(z,v_ind)=1-resBM(z,v_ind).DistPi_agent_2(1);
        
        
%       RelDistPi_agent_1BM(z,v_ind)=DistPi_agent_1BM(z,v_ind)/DistPi_agent_2BM(z,v_ind);
    end
end



DataStruc.lambda=lambda;
DataStruc.lambdaBM=lambdaBM;


DataStruc.Data=Cons;
DataStruc.BM=ConsBM;
DataStruc.Name='$c$';
DataStruc.Type=1;
DrawPlot(DataStruc,Para)    


DataStruc.Data=lambda;
DataStruc.BM=lambdaBM;
DataStruc.Name='$\lambda$';
DataStruc.Type=1;
DrawPlot(DataStruc,Para)    

DataStruc.Data=VStar;
DataStruc.BM=VStarBM;
DataStruc.Name='$v^*$';
DataStruc.Type=2;
DrawPlot(DataStruc,Para)    


DataStruc.Data=cStar/y;
DataStruc.BM=cStarBM/y;
DataStruc.Name='$\frac{c^*}{y}$';
DataStruc.Type=2;
DrawPlot(DataStruc,Para)    




DataStruc.Data=[DistMarg_agent_1'./DistMarg_agent_1BM' DistMarg_agent_2'./DistMarg_agent_2BM'];

DataStruc.Name='$\tilde{P}^i{low}$';
DataStruc.Type=3;
DrawPlot(DataStruc,Para)    


DataStruc.Data=Mu;
DataStruc.BM=MuBM;
DataStruc.Name='$\mu$';
DataStruc.Type=1;
DrawPlot(DataStruc,Para)    

[DistMarg_agent_1' DistMarg_agent_2' DistMarg_agent_1BM' DistMarg_agent_2BM']
[]
%%% Testing Space


% This function solves the FOC with the initial guess 

z=1
v=VGrid(end);
%Ex1
Para.Theta=[1  1;1 1];

%Guess the starting value for FOC using the complete information solution 
c0=y-u_inv(v/(1+delta),ra);
v0=u(y-c0,ra);
xInit=[c0 v0 0];
options = optimset('Display','off','TolFun',ctol,'FunValCheck','off','TolX',ctol,'MaxFunEvals', 5000*length(xInit));
[x fval exitflag] =fsolve(@(x) resQ(x,z,v,Para),xInit,options);
y-u_inv(x(2),ra)-y*(sh-sl)
%Ex2
Para.Theta=[1  1;1 1]*1000000;

%Guess the starting value for FOC using the complete information solution 
c0=y-u_inv(v/(1+delta),ra);
v0=u(y-c0,ra);
xInit=[c0 v0 0];
options = optimset('Display','off','TolFun',ctol,'FunValCheck','off','TolX',ctol,'MaxFunEvals', 5000*length(xInit));
[x fval exitflag] =fsolve(@(x) resQ(x,z,v,Para),xInit,options);
resQ(x,z,v,Para)
y-u_inv(x(2),ra)-y*(sh-sl)


  
