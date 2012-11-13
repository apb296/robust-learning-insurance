% this script plots the expected returns 
clear all
clc

DataPath=['Persistent/Data/theta_1_finite/Transitory/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
 DataPath=['Persistent/Data/theta_1_finite/transitory/'];
PDData= load([DataPath,'PDData.mat'])
z=3;
v=3;
pi=.5;
PlotVGridSize=10;
PlotVGrid=linspace(min(ValueFunctionData.x_state(:,3)),max(ValueFunctionData.x_state(:,3)),PlotVGridSize);
PlotPiGridSize=1;
PlotPiGrid=linspace(.5,.5,PlotPiGridSize);
ZGrid=[1 3];
x_state=setprod(ZGrid,PlotPiGrid,PlotVGrid);
parfor GridInd=1:length(x_state)
ExpectedReturns(GridInd)=ComputeExpectedReturns(x_state(GridInd,1),x_state(GridInd,3),x_state(GridInd,2),ValueFunctionData,PDData)   
end



Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/persistent/'];
DataPath=['Persistent/Data/theta_1_infty/persistent/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PDData= load([DataPath,'PDData.mat'])
SimData=load([DataPath 'SimData.mat']);
x_state.Z=SimData.z_draw;
x_state.pi=SimData.pi_bayes;
x_state.V=SimData.V;

parfor GridInd=1:length(x_state.Z)
ExpectedReturns(GridInd)=ComputeExpectedReturns(x_state.Z(GridInd),x_state.V(GridInd),x_state.pi(GridInd),ValueFunctionData,PDData)   
end

InxIID=find(SimDataIID.z_draw<3);
    for i=1:length(InxIID)-1
        bbIID{i}=InxIID(i):InxIID(i+1);
    end
figure()
plot(ExpectedReturns)
ShadePlotForEmpahsis( bbIID,'r',.05);

