% This computes the 4 cases
SetParaStruc_p_learning;
clear all
% -- SET UP THE PARALLEL CONFIGURATION ----------------------------------
err=[];
try
    
    matlabpool size
    
catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close
    end
    
    matlabpool open local;
    
end

% -------------------------------------------------------------------------


InitData.OrderOfApproximationV=10;
InitData.OrderOfApproximationPi=10;
InitData.VGridDensityFactor=2;
InitData.PiGridDensityFactor=1;

%CASE I - theta_1,theta_2 <infty,PM=I
DataPath=['Data/theta_1_finite/Transitory/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(DataPath,ValueFunctionData,InitData)
%CASE II - theta_1,theta_2 <infty,PM=P
DataPath=['Data/theta_1_finite/Persistent/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(DataPath,ValueFunctionData,InitData)
%CASE III - theta_1=Infty,theta_2 <infty,PM=I
DataPath=['Data/theta_1_infty/Transitory/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(DataPath,ValueFunctionData,InitData)
%CASE IV - theta_1=Infty,theta_2 <infty,PM=P
DataPath=['Data/theta_1_infty/Persistent/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(DataPath,ValueFunctionData,InitData)


%  DataPath=['Data/theta_1_finite/transitory/'];
%   load([DataPath,'PDData.mat'])
%  
%  piPlot=.2;
%  PlotGridSize=15;
%  PiPlotGrid=piPlot*ones(PlotGridSize,1);
%  z=1;
%  VPlotGrid=linspace(min(Para.VGrid(z,:)),max(Para.VGrid(z,:)),PlotGridSize)';
%  PDPlotData=funeval(coeffPD(z,:)',PD(z),[PiPlotGrid VPlotGrid]);
%  figure()
%  subplot(1,2,1)
%  plot(VPlotGrid,PDPlotData,'k')
%  z=3;
%  VPlotGrid=linspace(min(Para.VGrid(z,:)),max(Para.VGrid(z,:)),PlotGridSize)';
%  PDPlotData=funeval(coeffPD(z,:)',PD(z),[PiPlotGrid VPlotGrid]);
%  subplot(1,2,2)
%  plot(VPlotGrid,PDPlotData,'k')
%  
% 
% 
