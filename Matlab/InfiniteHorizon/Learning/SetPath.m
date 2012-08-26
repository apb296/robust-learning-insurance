%SetPath


CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\';
SL='\';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/Project Robust Learning/Matlab/InfiniteHorizon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/RobustLearning/Mfiles/InfiniteHorizon/';

SL='/';
end
if Para.BenchMark==1

CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Plots' SL];
TexPath=[BaseDirectory 'Learning' SL 'Tex' SL];
DataPath=[BaseDirectory 'Learning' SL 'Data' SL];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];
else
    CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Plots' SL];
TexPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Tex' SL];
DataPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Data' SL];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];
end

    
mkdir(PlotPath)
mkdir(TexPath)
mkdir(DataPath)
Para.CompEconPath=CompEconPath;
Para.PlotPath=PlotPath;
Para.TexPath=TexPath;
Para.DataPath=DataPath;
Para.NoLearningPath=NoLearningPath;
Para.LearningPath=LearningPath;
