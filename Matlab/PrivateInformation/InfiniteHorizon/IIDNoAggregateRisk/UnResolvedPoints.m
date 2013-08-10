% THIS SCRIPT S RESOVLVES THE PROBLEMATIC POINTS USING A HOMOTOPY SORT OF
% APPROACH. WE USE THE SOLUTIONS AT POINTS THAT HAD A SOLUTION AND CREATE A
% BRIDGE BETWEEEN THESE POINTS AND THE UNSOLVED POINTS. NEXT WE ATTEMPT TO
% SOLVE THE AT POINTS ALONG THIS BRIGE AND USE THE LAST SOLUTION AS THE
% NEXT GUESS


IndxUnSolved=find(~(ExitFlag==0));
    IndxSolved=find(ExitFlag==0);
  %disp('Total Unresolved Points')
  sprintf(' Unresolved so far  %1.2f',length(find(IndxUnSolved)))
NumUnsolved=length(IndxUnSolved);
for i=1:NumUnsolved
    IndxSolved=find(ExitFlag==0);
        uns_indx=IndxUnSolved(i);
    
     v=domain(uns_indx) ;
      disp('Resolving...');
       
disp([v]);

        
        
%% TRY I
NumTrials=10;
v0=[];
[PolicyRulesInit,vref]=GetInitialApproxPolicy(v,domain(IndxSolved,:),PolicyRulesStore(IndxSolved,:));
 v0(1,:)=linspace(vref(1),x,NumTrials) ;
for tr_indx=1:NumTrials
            strucOptimalContract=SolveInnerOptimization(domain(ctr),InitContract,Para,c,Q) ;      
             InitContract=strucOptimalContract.Contract;                        
end


 
 
        ExitFlag(uns_indx)=exitflag;
        VNew(uns_indx)=V_new;
        if exitflag==0
        PolicyRulesStore(uns_indx,:)=PolicyRules;
        end
           IndxSolved=find(ExitFlag==0);

        
end
           

    IndxSolved=find(ExitFlag==0);
    IndxUnSolved=find(~(ExitFlag==0));
   disp('Number of points resolved with alternative guess')
   NumResolved=NumUnsolved-length(IndxUnSolved)
   
 