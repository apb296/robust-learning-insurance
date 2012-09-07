function PriceDividendRatio(DataPath,ValueFunctionData,InitData)
% This function computes the price dividend ratio for the lucas tree yielding
% the aggregate endowmwnt. It does not approximate the MRS[zstar|z,pi,v]
% function but computes MRS[zstar|z,pi,v] using the already solved planner's BM equation

switch  nargin
    case 2
      flagComputeGridWithInitData='no';
      disp('Using the same grid as the value function')
    case 3
        flagComputeGridWithInitData='yes';
        disp('Recomputing the grid using init data');
        disp(InitData);   
end
        
% -- load the coeff for the value function -------------------------------
%DataPath=['Persistent/Data/theta_1_infty/Transitory/'];
Para=ValueFunctionData.Para;
PolicyRules=ValueFunctionData.PolicyRules;
x_state=ValueFunctionData.x_state;
Q=ValueFunctionData.Q;
c=ValueFunctionData.c;

clear res;
ZSize=Para.ZSize;

if strcmpi(flagComputeGridWithInitData,'yes')==1
% -- redefine the grid points --------------------------------------
OrderOfApproximationV=InitData.OrderOfApproximationV;
OrderOfApproximationPi=InitData.OrderOfApproximationPi;
VGridSize=OrderOfApproximationV*InitData.VGridDensityFactor;
PiGridSize=OrderOfApproximationPi*InitData.VGridDensityFactor;
PiGrid=linspace(min(Para.PiGrid),max(Para.PiGrid),PiGridSize);
for z=1:Para.ZSize
    VGrid(z,:)=linspace(min(Para.VGrid(z,:)),max(Para.VGrid(z,:)),VGridSize);
end
x_state=[];
n=1;
for z=1:Para.ZSize
    for v_ind=1:VGridSize
        for pi_ind=1:PiGridSize
            x_state(n,:)=[z PiGrid(pi_ind) VGrid(z,v_ind)];
            n=n+1;
        end
    end
end
else
    VGridSize=Para.VGridSize;
    VGrid=Para.VGrid;
    PiGridSize=Para.PiGridSize;
    PiGrid=Para.PiGrid;
    OrderOfApproximationPi=Para.OrderOfApproximationPi;
    OrderOfApproximationV=Para.OrderOfApproximationV;

end
GridSize=VGridSize*PiGridSize*Para.ZSize;
%-- set up the functional space -------------------------------------------
% Define the functional space. Since the domain is similiar to the
% functions characterizing the value functions..I replicate the it for the
% price dividend ratio

 for z=1:Para.ZSize
PD(z) = fundefn(Para.ApproxMethod,[OrderOfApproximationPi OrderOfApproximationV] ,[min(PiGrid)  min(VGrid(z,:))],[max(PiGrid) max(VGrid(z,:))]);
 end
                                                                             % PD[z,pi,v]
zSlice=x_state(:,1);                                                        % isolate the first component of the domain - z
PiSlice=x_state(:,2);                                                       % isolate the second component of the domain - Pi
vSlice=x_state(:,3);                                                        % isolate the third component of the domain - v

% -- initialize the guess for the coeff for the price dividend ratio -----
% This is done using the Expected Utility solution
for m=1:Para.MSize
    pdguessY(m,:)=fsolve(@(pdguessY) GetResidualPDEU( pdguessY,Para,m ) ,[1/(1-Para.delta) 1/(1-Para.delta)]);
    pdguess(m,1)=pdguessY(m,1);
    pdguess(m,2)=pdguessY(m,1);
    pdguess(m,3)=pdguessY(m,2);
    pdguess(m,4)=pdguessY(m,2);
end

for z=1:Para.ZSize
    if (z==1 || z==3)
        zIndx=find(zSlice==z);
        PDValues=pdguess(1,z)*PiSlice(zIndx)+(1-PiSlice(zIndx))*pdguess(2,z);
        coeffPD(z,:)=funfitxy(PD(z),x_state(zIndx,2:end),PDValues);
    else
        coeffPD(z,:)=coeffPD(z-1,:);
    end
end
% Compute the objects that are not affected by PD ratio - MRS , Vstar,
% pistar, Effectiveprobability using the solution of the Planner's problem


parfor GridInd=1:GridSize
    
    z=zSlice(GridInd);
    v=vSlice(GridInd);
    pi=PiSlice(GridInd);
    xInit=GetInitalPolicyApprox([z pi v],x_state,PolicyRules);
    
    %since the value function depends only on y
    if (z==1 || z==3)
        
        resQNew=getQNew(z,pi,v,c,Q,Para,xInit);
        VStar(GridInd,:)=resQNew.VStar;
        pistar(GridInd,:)=resQNew.pistar;
        MRS(GridInd,:)=resQNew.MRS;
        GrowthRateY(GridInd,:)=Para.Y'/Para.Y(z);
        ExitFlag(GridInd,:)=resQNew.ExitFlag;
    end
    EffProb(GridInd,:)=pi*Para.P(z,:,1)+(1-pi)*Para.P(z,:,2);
end
VStar(GridSize/4+1:2*GridSize/4,:)=VStar(1:GridSize/4,:);
VStar(3*GridSize/4+1:GridSize,:)=VStar(GridSize/2+1:3*GridSize/4,:);


pistar(GridSize/4+1:2*GridSize/4,:)=pistar(1:GridSize/4,:);
pistar(3*GridSize/4+1:GridSize,:)=pistar(GridSize/2+1:3*GridSize/4,:);


MRS(GridSize/4+1:2*GridSize/4,:)=MRS(1:GridSize/4,:);
MRS(3*GridSize/4+1:GridSize,:)=MRS(GridSize/2+1:3*GridSize/4,:);

GrowthRateY(GridSize/4+1:2*GridSize/4,:)=GrowthRateY(1:GridSize/4,:);
GrowthRateY(3*GridSize/4+1:GridSize,:)=GrowthRateY(GridSize/2+1:3*GridSize/4,:);

ExitFlag(GridSize/4+1:2*GridSize/4,:)=ExitFlag(1:GridSize/4,:);
ExitFlag(3*GridSize/4+1:GridSize,:)=ExitFlag(GridSize/2+1:3*GridSize/4,:);

%save([DataPath 'PDData.mat'],'VStar','pistar','MRS','GrowthRateY','ExitFlag','Para','PD','coeffPF');
%load([DataPath,'PDData.mat'])
% -----------------------------------------------------------------------------

% -- Now iterate on the PD approximation ---------------------------------
for i=2:Para.NIter;
    tic
    disp('Iteration No') ;disp(i)
  
    
   
 PDValues=GetPDValueVectorizedCode(PD,coeffPD,pistar,VStar,EffProb,MRS,GrowthRateY);
 %PDValues=GetPDValueParFor(PD,coeffPD,pistar,VStar,EffProb,MRS,GrowthRateY,GridSize,zSlice)
    
    for z=1:Para.ZSize
        ExitFlag_z=ExitFlag((z-1)*GridSize/ZSize+1:z*GridSize/ZSize);
        IndxSolved=(z-1)*GridSize/ZSize+(find(ExitFlag_z==1));
        IndxUnSolved=(find(~(ExitFlag_z==1)));
        coeffPDNew(z,:)= funfitxy(PD(z),x_state(IndxSolved,2:end),PDValues(IndxSolved) );
    end
    coeffPDOld=coeffPD;
    
    coeffPD=coeffPDOld*(1-Para.grelax)+coeffPDNew*Para.grelax;
   cdiffcoeffPD(i,:)=max(abs(coeffPD-coeffPDOld));
   toc
end

save([DataPath 'PDData.mat'],'VStar','pistar','MRS','GrowthRateY','ExitFlag','Para','PD','coeffPD');
end
function PDValues=GetPDValueVectorizedCode(PD,coeffPD,pistar,VStar,EffProb,MRS,GrowthRateY)
   % Compute the value of the PDratio tomorrow for each zstar,vstar,pistar
    PDStar1=funeval(coeffPD(1,:)',PD(1),[pistar(:,1) VStar(:,1)]);
    PDStar2=funeval(coeffPD(2,:)',PD(2),[pistar(:,2) VStar(:,2)]);
    PDStar3=funeval(coeffPD(3,:)',PD(3),[pistar(:,3) VStar(:,3)]);
    PDStar4=funeval(coeffPD(4,:)',PD(4),[pistar(:,4) VStar(:,4)]);
    PDValues=sum(EffProb.*MRS.*[PDStar1 PDStar2 PDStar3 PDStar4] .*GrowthRateY+GrowthRateY,2);
end

function PDValues=GetPDValueParFor(PD,coeffPD,pistar,VStar,EffProb,MRS,GrowthRateY,GridSize,zSlice)
    parfor GridInd=1:GridSize
    z=zSlice(GridInd);
    if (z==1 || z==3)
    PDStar1=funeval(coeffPD(1,:)',PD(1),[pistar(GridInd,1) VStar(GridInd,1)]);
    PDStar2=funeval(coeffPD(2,:)',PD(2),[pistar(GridInd,2) VStar(GridInd,2)]);
    PDStar3=funeval(coeffPD(3,:)',PD(3),[pistar(GridInd,3) VStar(GridInd,3)]);
    PDStar4=funeval(coeffPD(4,:)',PD(4),[pistar(GridInd,4) VStar(GridInd,4)]);
    PDValues(GridInd,:)=sum(EffProb(GridInd,:).*MRS(GridInd,:).*[PDStar1 PDStar2 PDStar3 PDStar4] .*GrowthRateY(GridInd,:)+GrowthRateY(GridInd,:));
    end
    end
    PDValues(GridSize/4+1:2*GridSize/4,:)=PDValues(1:GridSize/4,:);
    PDValues(3*GridSize/4+1:GridSize,:)=PDValues(GridSize/2+1:3*GridSize/4,:);
end


% load([DataPath,'PDData.mat'])
% 
% piPlot=1;
% PlotGridSize=15;
% PiPlotGrid=piPlot*ones(PlotGridSize,1);
% VPlotGrid=linspace(min(Para.VGrid(z,:)),max(Para.VGrid(z,:)),PlotGridSize)';
% z=1;
% PDPlotData=funeval(coeffPD(z,:)',PD(z),[PiPlotGrid VPlotGrid]);
% figure()
% subplot(1,2,1)
% plot(VPlotGrid,PDPlotData,'k')
% z=3;
% PDPlotData=funeval(coeffPD(z,:)',PD(z),[PiPlotGrid VPlotGrid]);
% subplot(1,2,2)
% plot(VPlotGrid,PDPlotData,'k')
% 
% 
% 
