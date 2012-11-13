
IndxUnSolved=find(~(ExitFlag==1));
    IndxSolved=find(ExitFlag==1);
  %disp('Total Unresolved Points')
  sprintf(' Unresolved so far  %1.2f',length(find(IndxUnSolved)))
                NumUnsolved=length(IndxUnSolved);
for inx=1:NumUnsolved
    IndxSolved=find(ExitFlag==1);
    disp('Resolving...');
    uns_indx=IndxUnSolved(inx);
    
     v=vSlice(uns_indx) ;
        z=zSlice(uns_indx) ;
        pi=PiSlice(uns_indx);

        
        
%% TRY I
NumTrials=5;
x0=[];
SearchIndx=IndxSolved([
find(~(x_state(IndxSolved,3)==min(Para.VGrid(1,:))));
 find(~(x_state(IndxSolved,3)==min(Para.VGrid(2,:))));
 find(~(x_state(IndxSolved,3)==min(Para.VGrid(3,:))));
 find(~(x_state(IndxSolved,3)==min(Para.VGrid(4,:))));
 
find(~(x_state(IndxSolved,3)==max(Para.VGrid(1,:))));
 find(~(x_state(IndxSolved,3)==max(Para.VGrid(2,:))));
 find(~(x_state(IndxSolved,3)==max(Para.VGrid(3,:))));
 find(~(x_state(IndxSolved,3)==max(Para.VGrid(4,:))))]);

[PolicyRulesInit,xref]=GetInitalPolicyApprox([z pi v],x_state(SearchIndx,:),PolicyRules(SearchIndx,:));
 vtrialgrid=linspace(xref(3),v,NumTrials) ;
 pitrialgrid=linspace(xref(2),pi,NumTrials) ;
 
for tr_indx=1:NumTrials
    vtrial=vtrialgrid(tr_indx);
     pitrial=pitrialgrid(tr_indx);
    [PolicyRulesInit,ref_id]=GetInitalPolicyApprox([z pitrial vtrial],x_state(SearchIndx,:),PolicyRules(SearchIndx,:));
    resQNew=getQNew(z,pitrial,vtrial,c,Q,Para,PolicyRulesInit);                            % Solve the inner optimization for y, V(y,v)
        PolicyRulesInit=[resQNew.Cons resQNew.VStar];
exitflag=resQNew.ExitFlag;
            Qval=resQNew.Q;

end



 
 
        ExitFlag(uns_indx)=exitflag;
        QNew(uns_indx)=Qval;
        if exitflag==1
        PolicyRules(uns_indx,:)=PolicyRulesInit;
        end
           IndxSolved=find(ExitFlag==1);

        
end
           

    IndxSolved=find(ExitFlag==1);
    IndxUnSolved=find(~(ExitFlag==1));
   disp('Number of points resolved with alternative guess')
   NumResolved=NumUnsolved-length(IndxUnSolved)
   
 