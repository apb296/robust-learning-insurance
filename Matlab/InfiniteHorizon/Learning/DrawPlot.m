function DrawPlot(X,flag3D,Para)
Data=X.Data;
Name=X.Name;
FigName=X.FigName;
StateName=Para.StateName;
VGrid=Para.VGrid;
Case{1}='NonIID';
Case{2}='Learning';
Case{3}='IID';

if exist(X.VGrid)
VGrid=X.VGrid;
end

PiGrid=Para.PiGrid;
if exist(X.PiGrid)
PiGrid=X.PiGrid;
end

DataSize=size(Data);
PiSize=DataSize(2);
PiGridIndex=[1 (round(PiSize/2)) PiSize];
PiIndexSize=length(PiGridIndex);
VSize=DataSize(3);
%Data_Mid=Data(:,end,:,:);

if length(DataSize)==3
    for z=1:Para.ZSize
    subplot(2,2,z)
    %plot(VGrid(z,:),squeeze(Data_Model_1(z,1,:,:)));
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(1),:)),'k','LineWidth',2);
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(2),:)),':b','LineWidth',2);
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(3),:)),'r','LineWidth',2);
    hold on
    
    
   %xlabel('Promised Value to Agent 2 - v')
   xlabel([StateName(z)],'Interpreter','LaTex')
   %title(StateName(z),'Interpreter','LaTex')
   ylabel(Name,'Interpreter','LaTex')
    end
    print(gcf, '-dpng', [ Para.PlotPath 'Fig_' FigName '.png'] );
end

if length(DataSize)==4
if flag3D==0
    for pi=1:PiIndexSize
    figure('Name', ['Pi = ' num2str(PiGrid(PiGridIndex(pi)))])
   for z=1:Para.ZSize
    subplot(2,2,z)
    %plot(VGrid(z,:),squeeze(Data_Model_1(z,1,:,:)));
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(pi),:,1)),'k','LineWidth',2);
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(pi),:,2)),':k','LineWidth',2);
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(pi),:,3)),'r','LineWidth',2);
    hold on
    plot(VGrid(z,:),squeeze(Data(z,PiGridIndex(pi),:,4)),':r','LineWidth',2);
    hold on
     %xlabel('Promised Value to Agent 2 - v')
   xlabel([StateName(z)],'Interpreter','LaTex')
   %title(StateName(z),'Interpreter','LaTex')
   ylabel(Name,'Interpreter','LaTex')
   
   %legend('z=s_ly_l', 'z=s_hy_l', 'z=s_ly_h' , 'z=s_hy_h')
   end
   print(gcf, '-dpng', [ Para.PlotPath 'Fig_' FigName Case{pi} '.png'] );
    end
end

if flag3D==1
    figure()
    for z=1:1
    %subplot(2,2,z)
    surf(PiGrid,VGrid(z,:),squeeze(Data(z,:,:,:))');
  
   end
end

end

