clear all
close all
clc
Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/persistent/'];

DataPath=['Persistent/Data/theta_1_infty/Persistent/'];
load([DataPath,'PDData.mat'])
 piPlot=1;
 PlotGridSize=15;
 PiPlotGrid=piPlot*ones(PlotGridSize,1);
 z=1;
 VPlotGrid=linspace(min(Para.VGrid(z,:)),max(Para.VGrid(z,:)),PlotGridSize)';
 PDPlotData=funeval(coeffPD(z,:)',PD(z),[PiPlotGrid VPlotGrid])*Para.Y(z);
 figure()
 subplot(1,2,1)
 plot(VPlotGrid,PDPlotData,'k')
 z=3;
 VPlotGrid=linspace(min(Para.VGrid(z,:)),max(Para.VGrid(z,:)),PlotGridSize)';
 PDPlotData=funeval(coeffPD(z,:)',PD(z),[PiPlotGrid VPlotGrid])*Para.Y(z);
 subplot(1,2,2)
 plot(VPlotGrid,PDPlotData,'k')
 
SimDataNonIID=load([DataPath 'SimData.mat']);
SimDataIID=load([DataPath 'SimData.mat']);

for z=1:Para.ZSize
Indx_z=find(SimDataIID.z_draw==z);
PDraw(Indx_z)=(funeval(coeffPD(z,:)',PD(z),[SimDataIID.pi_bayes(Indx_z)' SimDataIID.V(Indx_z)']))*Para.Y(z);
end
InxIID=find(SimDataIID.z_draw<3);
    for i=1:length(InxIID)-1
        bbIID{i}=InxIID(i):InxIID(i+1);
    end
figure()
plot(PDraw)
ShadePlotForEmpahsis( bbIID,'r',.05);
