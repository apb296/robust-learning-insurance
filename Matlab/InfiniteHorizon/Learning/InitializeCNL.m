
% Compute EU coeff
if exist('flagDisp')==0
    flagDisp=1;
end

if flagDisp==1
figDerEUApprox=figure('Name','Derivative approximation');
figEUApprox=figure('Name','Value function approximation');
end
for z=1:Para.ZSize
%Q(z) = fundefn('cheb',OrderOfApproximation,VMin(z),VMax(z),OrderOfSpline);
%VGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize);
%VFineGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize*10);

for v=1:VGridSize
res=EUSol(z,VGrid(z,v),Para);
EU(z,v)=res.V1(z);
DerEU(z,v)=-res.lambda;
end
% Compute the initial coeffecient for EU case
cEU0(z,:)=funfitxy(Q(z),VGrid(z,:)',EU(z,:)');
der_c_EU0(z,:)=funfitxy(DerQ(z),VGrid(z,:)',DerEU(z,:)');
% Check the Fit
if flagDisp==1
for v=1:VGridSize*10
res=EUSol(z,VFineGrid(z,v),Para);
EU_y(z,v)=res.V1(z);
DerEU_y(z,v)=-res.lambda;
Approx_y(z,v)=funeval(cEU0(z,:)',Q(z),VFineGrid(z,v));
Approx_der_y(z,v)=funeval(cEU0(z,:)',Q(z),VFineGrid(z,v),1);
Approx_der_y_fit(z,v)=funeval(der_c_EU0(z,:)',DerQ(z),VFineGrid(z,v));
Approx_2der_y(z,v)=funeval(cEU0(z,:)',Q(z),VFineGrid(z,v),2);

end
figure(figDerEUApprox)
subplot(Para.ZSize/2,Para.ZSize/2,z)
plot(VFineGrid(z,:)',[DerEU_y(z,:)'],'k','LineWidth',2)
hold on
plot(VFineGrid(z,:)',[Approx_der_y(z,:)'],':k','LineWidth',1)
hold on
plot(VFineGrid(z,:)',[Approx_der_y_fit(z,:)'],':b','LineWidth',1)
xlabel('v')
ylabel('DerEU(v)');
title(['z = ' num2str(z)])
figure(figEUApprox)
subplot(Para.ZSize/2,Para.ZSize/2,z)
plot(VFineGrid(z,:)',[EU_y(z,:)'],'k','LineWidth',2)
hold on
plot(VFineGrid(z,:)',[Approx_y(z,:)'],':k','LineWidth',1)
xlabel('v')
ylabel('EU(v)');
title(['z = ' num2str(z)])
end
end


save('coeffEU.mat','cEU0','der_c_EU0');

