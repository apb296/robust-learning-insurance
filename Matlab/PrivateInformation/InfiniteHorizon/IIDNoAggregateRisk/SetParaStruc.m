
  
Para.y=10; % Aggregate output
Para.sl=.4; % low share
Para.sh=.6; % high share
Para.Delta=Para.y*(Para.sh-Para.sl); % Amount you can stead
Para.pl=[.5 .5]; % probability of low shock
Para.ph=[.5 .5]; % probability of high shock
Para.beta=.9; % subjective discount factor
Para.c_offset=.005*Para.y;
Para.ra=.5; % risk aversion
Para.vGridSize=25; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=20; % order of approximation
Para.Theta=ones(2,2)*10000000; % ambiguity parameter
Para.grelax=.03;
Para.KTR.opts = optimset( 'Display','off', ...
    'GradObj','on','GradConstr','on',...
    'MaxIter',2500, 'MaxFunEvals',2500);
Para.KTR.opts.MaxTime=100;
Para.MaxIter=300;
Para.flagInitializeCoeffWithExistingData=0;