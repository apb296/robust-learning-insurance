    
%LOCATE THE UNRESOVLED POINTS
    IndxUnSolved=find(~(ExitFlag==1));
    IndxSolved=find(ExitFlag==1);
    
    % --  Rsolve the FOC at points that failed in the first round -----
    if mod(iter,Para.ResolveCtr)==0
        NumTrials=5;
        disp('Points that failed the first round of FOC')
        domain(IndxUnSolved,:)
        sprintf('Resolving the unresolved points using alterative routine ')
        UnResolvedPoints
        if NumResolved>0
            Numtrials=10;
            sprintf('Resolving the unresolved points using alterative routine ')
            UnResolvedPoints;
        end
    end
    IndxUnSolved=find(~(ExitFlag==1));
    IndxSolved=find(ExitFlag==1);
    IndxSolved_1=IndxSolved(IndxSolved<=GridSize/Para.sSize);
    IndxSolved_2=IndxSolved(IndxSolved>GridSize/Para.sSize);
    %
    