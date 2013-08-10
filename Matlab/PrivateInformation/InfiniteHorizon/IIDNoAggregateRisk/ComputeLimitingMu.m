function [LimitingGrowthRate,LimitingMu,MuApprox]=ComputeLimitingMu(Para)
AmbData=load (['Data/' Para.StoreFileName]) ;


obj=AmbData;

a=3;

mu_1_sh=obj.MuStore(a:end,2)./obj.DistortedBeliefsAgent1Store(a:end,2);
DiffMu_1_sh=mu_1_sh(a+1:end)-mu_1_sh(a:end-1);
LastIndex=min(find((DiffMu_1_sh>0)));

[ref,LastIndex]=min(mu_1_sh(a:LastIndex));

mu_1_sh=mu_1_sh(a:LastIndex);

Lambda=obj.LambdaStore(a:LastIndex)';
mu_sh_spline=spline((Lambda),mu_1_sh);
ppval(mu_sh_spline,0);
%Mu_sh_fspace = fundefn('spli',20 , (Lambda(1)), (Lambda(end)));

%[cguess]=funfitxy(Mu_sh_fspace ,(Lambda),mu_1_sh(1:LastIndex));

%funeval(cguess,Mu_sh_fspace,(Lambda(1))*1.001)


vl=u(0,obj.Para.ra);
vh=u(obj.Para.Delta,obj.Para.ra);

dist_p2=1-((1/(1+exp((vh-vl)/obj.Para.Theta(1)))));


vl=u(obj.Para.y,obj.Para.ra);
vh=u(obj.Para.y-obj.Para.Delta,obj.Para.ra);

dist_p1=1-(1/(1+exp((vh-vl)/obj.Para.Theta(1))));



% ext=.1
% figure()
%     plot((Lambda),mu_1_sh)
%     figure()
%     %hold on
%     plot(linspace(0,Lambda(end),100)',-log(1./(1+ppval(mu_sh_spline,linspace(0,Lambda(end),100)'))),'k')
%     hold on
%     plot(linspace(0,Lambda(end),100)',log(dist_p2./dist_p1)+0*linspace(0,Lambda(end),100)','r')
%     
% 
%     
    LimitingGrowthRate=log(dist_p2./dist_p1)+log(1/(1+ppval(mu_sh_spline,0)));
    LimitingMu=ppval(mu_sh_spline,0);
    MuApprox=mu_sh_spline;
end
