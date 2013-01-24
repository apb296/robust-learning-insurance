

function res=TerminalPKRU(c,v,z,Para)
% This function solves the promise keeping constraint in the terminal
% period for exante promize of v utils and state in last period z; Note
% that this refers to utility of agent 2
P=Para.P(:,:,Para.m_true);
ra=Para.RA;
y=Para.y;
sl=Para.sl;
sh=Para.sh;
Delta=y*(sh-sl);
Theta=Para.Theta;
theta_11=Theta(1,1);
theta_21=Theta(2,1);
%theta_agent,operator

if( y-Delta-c>0 )
   
    
res=-theta_21*log(P(z,1)*exp(-u(y-c,ra)/theta_21)+P(z,2)*exp(-u(y-c-Delta,ra)/theta_21))-v;



else
    res=-(abs(y-Delta-c)*10+100);
end

