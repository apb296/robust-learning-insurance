


Para.BenchMark=1;

CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\PrivateInformation';
SL='\';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/Project Robust Learning/Matlab/PrivateInformation';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/RobustLearning/Mfiles/PrivateInformation';

SL='/';
end

PlotPath=[BaseDirectory SL 'Plots' SL];
TexPath=[BaseDirectory  SL 'Tex' SL];
DataPath=[BaseDirectory  SL 'Data' SL];



mkdir(PlotPath)
mkdir(TexPath)
mkdir(DataPath)
Para.PlotPath=PlotPath;
Para.TexPath=TexPath;
Para.DataPath=DataPath;

global ra;

c=1;
y=10;
alpha1=.5;
alpha2=.5;
beta1=.5;
beta2=.5;
alpha =[ alpha1;alpha2;alpha2];
beta=[beta1;beta2;beta2];
theta11=10000000;
theta12=10000000;
delta=.9;
%theta11*delta/theta12-1;
ra=.5;

sl=.3;
sh=.7;
Delta=y*(sh-sl);

S=[sl;sh];

Z=[sl sh;sh sl];

% 2 Models
M=[1;2];
MSize=length(M);
P_M=[1 0;
     0 1];
 Para.P_M=P_M;
%Prior
pi1=1;

% Theta(i,j)=agent(i) operator(j)
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];


for m =1:MSize
    P(:,:,m) = [beta(m) (1-beta(m));
        (1-beta(m)) beta(m)];
end
%Define Struct for Para
Para.y=y;
Para.delta=delta;
Para.M=M;
Para.Theta=Theta;
Para.P=P;
Para.RA=ra;
Para.MSize=MSize;

pi=[pi1;(1-pi1)];
Pi=[pi pi];
Para.m_true=1;
Para.Pi=Pi;
ZSize=2;
Para.ZSize=ZSize;
ctol=1e-7;
grelax=.9;
Para.ctol=ctol;
Para.grelax=grelax;
VGridSize=15;
Para.VGridSize=VGridSize;
Para.StateName={'$(y_{l},s_{l})$','$(y_{l},s_{h})$','$(y_{h},s_{l})$','$(y_{h},s_{h})$'};

Para.sh=sh;
Para.sl=sl;
Para.Delta=Delta;