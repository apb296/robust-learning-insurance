function cNew =run_iter_parallel(c,Q,x0,Para)
    %parfor z=1:Para.ZSize
      


         cNew1= ParallelCoeff(1,c,Q,x0,Para);
         cNew2= ParallelCoeff(2,c,Q,x0,Para);
%          cNew3= ParallelCoeff(3,c,Q,x0,Para);
%          cNew4= ParallelCoeff(4,c,Q,x0,Para);
%         
    % cNew=[cNew1;cNew2;cNew3;cNew4]
     cNew=[cNew1;cNew2];
end
      