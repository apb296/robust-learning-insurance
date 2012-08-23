c=1;
ybar=100;
g=.25;
%g=0;
alpha1=.5;
alpha2=.9;
beta1=.5;
beta2=.9;
alpha =[ alpha1;alpha2;alpha2];
beta=[beta1;beta2;beta2];
theta11=1.0000000;
theta12=10000000;
V_N=15;
NN=1000;
PlotN=55;
delta=.2;
ra=.5;
pi1=1;
global ra;

% Aggregate States
yl=ybar*(1-g);
yh=ybar*(1+g);
%yl=ybar*.1;
%yh=ybar;
YS=[yl;yh];
Y=[yl;yl;yh;yh];
% Idiosyncratic States
sl=.2;
sh=.8;
S=[sl;sh];
% 2 Models
M=[1;2];
MSize=length(M);

%Prior

% Theta(i,j)=agent(i) operator(j)
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];


for m =1:MSize
    P(:,:,m) = [c*alpha(m)*beta(m) alpha(m)*(1-c*beta(m)) c*(1-alpha(m))*beta(m) (1-alpha(m))*(1-c*beta(m));
        alpha(m)*(1-c*beta(m)) c*alpha(m)*beta(m) (1-alpha(m))*(1-c*beta(m)) c*(1-alpha(m))*beta(m);
        (1-alpha(m))*beta(m)  (1-alpha(m))*(1-beta(m)) alpha(m)*beta(m) alpha(m)*(1-beta(m));
        (1-alpha(m))*(1-beta(m))  (1-alpha(m))*(beta(m)) alpha(m)*(1-beta(m)) alpha(m)*(beta(m))
        ];
end

%Define Struct for Para
Para.delta=delta;
Para.Y=Y;
Para.M=M;
Para.V_N=V_N;
Para.Theta=Theta;
Para.P=P;
Para.RA=ra;

m_true=1;

Para.m=m_true;
%TH=[1]
pi=[pi1;(1-pi1)];
Pi=[pi pi];
C=['r','r','b','b'];

Para.Pi=Pi;
Para.ZSize=4;
ctol=1e-5;
grelax=.7;
Para.ctol=ctol;
Para.grelax=grelax;
% Parameters for the approximation
VGridSize=25;
VGridInit=round(.2*VGridSize);
OrderOfApproximation=7;
OrderOfSpline=7;

