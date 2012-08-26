function [cNew res]=ParallelCoeff(z,c,Q,x0,Para)
disp('...Executing z =')
disp(z)
%addpath(genpath(Para.CompEconPath));
PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;



    ctr=1;
    %%%%%%%%%%%%%%%%%%%%%%%
    for pi=1:PiGridSize
        % for pi=2:PiGridSize-1
        
        for v=1:VGridSize
            
            %%%%%
            
            
            %%%%%
            resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)));
            res(pi,v)=resQNew;
            
            
            
            
            
            
            if and(and(resQNew.Q >0,isreal(resQNew.Q)),resQNew.ExitFlag==1)
                x(ctr,:)=[PiGrid(pi) VGrid(z,v)] ;
                
                QNew(ctr)= resQNew.Q;
                %                            ConsShare(pi,v)=resQNew.Cons/(Y(z));
                ctr=ctr+1;
                
            end
            
            
        end
    end
    


[cNew]= funfitxy(Q(z),x,QNew' );

% 
% if flagNoLearning==1
%     %%%%%%%%%%%%%%%%%%%%%%%
%     %This sticks the solution from the no learning case into the learning case
%     
%     QNew(1:VGridSize)=QNL0(1:VGridSize);
%     x(1:VGridSize,:)=[zeros(VGridSize,1) VGrid(z,:)'];
%     ctr=VGridSize+1;
%     %res(1,1:VGridSize)=[];
%     
%     %%%%%%%%%%%%%%%%%%%%%%%
%     %for pi=1:PiGridSize
%     for pi=2:PiGridSize-1
%         
%         for v=1:VGridSize
%             
%             %%%%%
%             
%             
%             %%%%%
%             resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,squeeze(x0(z,pi,v,:)));
%             res(pi,v)=resQNew;
%             
%             
%             if and(and(resQNew.Q >0,isreal(resQNew.Q)),resQNew.ExitFlag==1)
%                 x(ctr,:)=[PiGrid(pi) VGrid(z,v)] ;
%                 
%                 QNew(ctr)= resQNew.Q;
%                 %                            ConsShare(pi,v)=resQNew.Cons/(Y(z));
%                 ctr=ctr+1;
%                 
%             end
%             
%             
%         end
%     end
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%
%     %This sticks the solution from the no learning case into the learning case
%     
%     %%%
%     % As we are not computing the learning problem results are kept as empty
%     res(PiGridSize,1:VGridSize)=res(1,1:VGridSize);
%     %%%
%     
%     
%     QNew= [QNew QNL0(end-VGridSize+1:end)];
%     xtail=[ones(VGridSize,1) VGrid(z,:)'];
%     x=[x; xtail];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%