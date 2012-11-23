% This computes the 4 cases
%matlabpool close force local
clear all
%CASE I - theta_1,theta_2 <infty,PM=I
SetParaStruc_p_learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % RUN THIS PART TO SOLVE FOR THE NO LEARNING CASES
    warning off all
     cd(Para.NoLearningPath)
     m_true=1;
 %     Main_NL(m_true,Para)
       m_true=2;
  %     Main_NL(m_true,Para)   
     cd(Para.LearningPath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Para.P_M=[1 0;0 1];
% Theta(i,j)=agent(i) operator(j)
theta11=.500000000;
theta12=.50000000;
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];
Para.Theta=Theta;
Para.DataPath=[Para.DataPath 'theta_1_finite' SL 'Transitory' SL];
mkdir(Para.DataPath)
MainBellman_L(Para)
clear Para
%CASE II - theta_1,theta_2 <infty,PM=P
SetParaStruc_p_learning
Para.P_M=[.9 .1;.1 .9];
theta11=.500000000;
theta12=.50000000;
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];
Para.Theta=Theta;
Para.DataPath=[Para.DataPath 'theta_1_finite' SL];
mkdir(Para.DataPath)
MainBellman_L(Para)

clear Para

%CASE III - theta_1=Infty,theta_2 <infty,PM=I
SetParaStruc_p_learning
Para.P_M=[1 0;0 1];
theta11=100000000;
theta12=.50000000;
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];
Para.Theta=Theta;
Para.DataPath=[Para.DataPath 'theta_1_infty' SL 'Transitory' SL];
mkdir(Para.DataPath)
MainBellman_L(Para)
clear Para

%CASE IV - theta_1=Infty,theta_2 <infty,PM=P
SetParaStruc_p_learning
Para.P_M=[.9 .1;.1 .9];
theta11=100000000;
theta12=.50000000;
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];
Para.Theta=Theta;
Para.DataPath=[Para.DataPath 'theta_1_infty' SL 'Persistent' SL];
mkdir(Para.DataPath)
MainBellman_L(Para)
clear Para
% Run long simulations
RunSimulations
