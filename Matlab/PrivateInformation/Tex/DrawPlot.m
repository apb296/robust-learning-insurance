function DrawPlot(DataStruc,Para)
figure
Data=DataStruc.Data;
DataBM=DataStruc.BM;
Name=DataStruc.Name;
type=DataStruc.Type;
ZSize=Para.ZSize;
lambda=DataStruc.lambda;
lambdaBM=DataStruc.lambdaBM;
y=Para.y;
VGrid=Para.VGrid;
ss=size(Data);
if type==2
for z=1:ZSize
subplot(1,2,z)
plot(lambda(z,:),squeeze(Data(z,:,1)),'LineWidth',2,'Color','k')
hold on
plot(lambdaBM(z,:),squeeze(DataBM(z,:,1)),':k')
hold on
plot(lambda(z,:),squeeze(Data(z,:,2)),'LineWidth',2,'Color','r')
hold on
plot(lambdaBM(z,:),squeeze(DataBM(z,:,2)),':r')

xlabel('$\lambda$','Interpreter','Latex')
ylabel(Name,'Interpreter','Latex')

end
end

if type==1
for z=1:ZSize
subplot(1,2,z)
plot(lambda(z,:),squeeze(Data(z,:,1)),'LineWidth',2,'Color','k')
hold on
plot(lambdaBM(z,:),squeeze(DataBM(z,:,1)),':k')





xlabel('$\lambda$','Interpreter','Latex')
ylabel(Name,'Interpreter','Latex')

end
end

if type==3
for z=1:ZSize
subplot(1,2,z)
plot(lambda,squeeze(Data(:,z)),'LineWidth',2,'Color','k')
hold on
plot(lambdaBM(z,:),squeeze(Data(:,z+2)),'LineWidth',2,'Color','r')
hold on
%plot(VGrid(z,:),squeeze(DataBM(:,z)),'LineWidth',2,'Color',':k')
hold on
%plot(VGrid(z,:),squeeze(DataBM(:,z+2)),'LineWidth',2,'Color',':r')





xlabel('$\lambda$','Interpreter','Latex')
ylabel(Name,'Interpreter','Latex')

end


end

