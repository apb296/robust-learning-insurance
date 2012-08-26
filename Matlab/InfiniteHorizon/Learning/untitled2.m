%GetResults


for ex=0:1
SetParaStruc;
Para.BenchMark=ex;    

SetPath;
ZSize=Para.ZSize;
ra=Para.RA;
Y=Para.Y;
P=Para.P;
delta=Para.delta;
Tr=150;
    for k=1:2
VSim=load([Para.DataPath 'VSim_' num2str(k)  '.mat']);
z_draw_trunc=VSim.z_draw(end-Tr:end);
MPR_draw_trunc=VSim.MPR_draw(end-Tr:end);
pi_bayes_trunc=VSim.pi_bayes(end-Tr:end);
pi_dist_trunc=VSim.pi_dist(end-Tr:end);
pi_bayes=VSim.pi_bayes;
  Inx=find(z_draw_trunc<3);
    for i=1:length(Inx)-1
        bb{i}=Inx(i):Inx(i+1);
    end

  for z=1:ZSize
      Er=Y./Y(z);
      PK_EU=delta*Er.^(-ra);
  end
  
  
 for i=2:length(VSim.MPR_draw) 
 EffProb=pi_bayes(i)*P(z,:,1)+(1-pi_bayes(i))*P(z,:,2);
 MuPK_EU=EffProb*PK_EU;
 SigmaPK_EU=(EffProb*(PK_EU-MuPK_EU).^2)^.5;
 MPR_EU_draw(i)=SigmaPK_EU/MuPK_EU;
 end
 MPR_EU_draw_trunc=MPR_EU_draw(end-Tr:end);   
%plot(MPR_draw_trunc)
figure()
plot(pi_bayes_trunc,':k','LineWidth',2)
hold on
plot(pi_dist_trunc,'k','LineWidth',2)
hold on
  ShadePlotForEmpahsis( bb,'r',.05);
  print(gcf, '-dpng', [ Para.PlotPath 'Fig_' 'Pi_' int2str(k) '.png'] );

close all

figure()
plot(MPR_draw_trunc,'k')
hold on 
plot(MPR_EU_draw_trunc,':k')

  ShadePlotForEmpahsis( bb,'r',.05);
  print(gcf, '-dpng', [ Para.PlotPath 'Fig_' 'MPR' int2str(k) '.png'] );
close all

figure()
hist(VSim.V(size(VSim.V)*.5:end),100)
  print(gcf, '-dpng', [ Para.PlotPath 'Fig_' 'VSS_' int2str(k) '.png'] );

%GetResults_bm

    end
end

% hist(VSim_2.pi_bayes-VSim_2.pi_dist)
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','r','EdgeColor','w')
% hold on 
% hist(VSim_2.pi_dist)

    