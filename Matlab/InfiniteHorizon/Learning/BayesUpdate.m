function PiStar=BayesUpdate(Pi,z,zstar)
global Para;
for j=1:2
for m=1:length(Para.M)
PiStar(m,j)=Pi(m,j)*Para.P(z,zstar,m);
end
PiStar(:,j)=PiStar(:,j)./sum(PiStar(:,j));
end

end
