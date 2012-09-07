% This computes the 4 cases

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


InitData.OrderOfApproximationV=5;
InitData.OrderOfApproximationPi=5;
InitData.VGridDensityFactor=2;
InitData.PiGridDensityFactor=1;

%CASE I - theta_1,theta_2 <infty,PM=I
DataPath=['Persistent/Data/theta_1_finite/Transitory/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(ValueFunctionData,InitData)
%CASE II - theta_1,theta_2 <infty,PM=P
DataPath=['Persistent/Data/theta_1_finite/Persistent/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(ValueFunctionData,InitData)
%CASE III - theta_1=Infty,theta_2 <infty,PM=I
DataPath=['Persistent/Data/theta_1_infty/Transitory/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(ValueFunctionData,InitData)
%CASE IV - theta_1=Infty,theta_2 <infty,PM=P
DataPath=['Persistent/Data/theta_1_infty/Persistent/'];
ValueFunctionData=load([DataPath 'FinalC.mat']);
PriceDividendRatio(ValueFunctionData,InitData)
