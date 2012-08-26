% FUNINFGEN Infinitesimal generator for approximating families of functions
% USAGE
%   [L,B]=funinfgen(mu,sigma,x,fspace,upwind);
% INPUTS
%   mu      : 1xd cell array of drift terms, each empty or an mx1 vector
%   sigma   : dxq cell array of diffusion terms, each empty or an mx1 vector
%   x       : mxd matrix of evaluation points or a 1xd cell array of
%                 columns vectors (to evaluate at grid points)
%   fspace  : function definition structure (see fundef)
%   upwind  : 0/1 variable - set to 1 if using 'lin' family of functions
%               and an upwinding basis is desired (default: 0)
%               Note: this option is only implemented for evenly spaced
%               breakpoints with basis matrices evaluated at the
%               breakpoints (no checks are made, however)
%
% OUTPUTS
%   L       : mxn infinitesimal generator operator
%   B       : mxn basis matrix (optional)

function [varargout]=funinfgen(mu,sigma,x,fspace,upwind)
if nargin<5 | isempty(upwind)
  upwind=0;
end
if nargout>2
  error('Only 2 outputs may be requested')
end
[m,d]=size(x);
q=size(sigma,2);

varargout=cell(max(1,nargout),1);
if isfield(fspace,'funtype')
  switch fspace.funtype
    case 'csrbf'
      if iscell(x), x=gridmake(x); end
      [varargout{:}]=csrbfinfgen(mu,sigma,x,fspace.parms{:});
    case 'rbf'
      if iscell(x), x=gridmake(x); end
      [varargout{:}]=rbfinfgen(mu,sigma,x,fspace.parms{:});
    otherwise
      error('not implemented for this basis type')
  end
else
  switch fspace.bastype{1}    
  case 'lin'
    if upwind
      Sigma=sigma2Sigma(sigma,d);
      varargout{1}=infgen(mu,Sigma,fspace.n,(fspace.b-fspace.a)./(fspace.n-1));
      if nargout>1, varargout{2}=speye(size(varargout{1},1)); end
    else
      [varargout{:}]=infgenx(mu,sigma,x,fspace);
    end
  otherwise
    [varargout{:}]=infgenx(mu,sigma,x,fspace);
  end
end
    

% INFGENX Infinitesimal generator for general functions
% USAGE
%   [L,B]=infgenx(mu,sigma,x,fspace);
% INPUTS
%   mu      : 1xd cell array of drift terms, each empty or an mx1 vector
%   sigma   : dxq cell array of diffusion terms, each empty or an mx1 vector
%   x       : mxd matrix of evaluation points
%   fspace  : function definition structure (see fundef)
%
% OUTPUTS
%   L       : mxn infinitesimal generator operator
%   B       : mxn basis matrix (optional)

%%%%%%%%%%%% Doesn't work for direct form when x is not a cell array of
%%%%%%%%%%%% vectors
function [L,B]=infgenx(mu,sigma,x,fspace)
if iscell(x)
  d=length(x);
  m=1; for i=1:d, m=m*length(x{i}); end
else
  [m,d]=size(x);
end
q=size(sigma,2);
n=prod(fspace.n);

% check whether sigma is empty
order2=0;
if iscell(sigma)
  for i=1:d, for j=1:q, if ~isempty(sigma{i,j}), order2=1; break; end; end; end
else
  if ~isempty(sigma), order2=1; end
end

if order2
  B=funbasx(fspace,x,[0;1;2]);
else
  B=funbasx(fspace,x,[0;1]);
end

if issparse(B.vals{1})
  if iscell(x)
    ss=1; for i=1:d, ss=ss*nnz(B.vals{end,i}); end
  else
    ss=(nnz(B.vals{end,1})/size(B.vals{end,1},1))^d*size(B.vals{end,1},1);
  end
  L=spalloc(m,n,ss);
else
  L=zeros(m,n);
end

% compute the first order part
if iscell(mu)
  for i=1:d
    if ~isempty(mu{i});
      ind=zeros(1,d); ind(i)=1;
      L=L+diagmult(mu{i},basget(B,ind));
    end
  end
else
  for i=1:d
    ind=zeros(1,d); ind(i)=1;
    L=L+diagmult(mu(:,i),basget(B,ind));
  end
end

% compute the second order part (if needed)
if order2
  if iscell(sigma)
    for i=1:d
      Sij=zeros(m,1);
      sij=0;
      for k=1:q
        if ~isempty(sigma{i,k}) 
          Sij=Sij+sigma{i,k}.^2; 
          sij=1; 
        end
      end
      if sij, 
        ind=zeros(1,d); ind(i)=2;
        L=L+diagmult(Sij/2,basget(B,ind)); 
      end
      for j=i+1:d
        Sij=zeros(m,1);
        sij=0;
        for k=1:q
          if ~isempty(sigma{i,k}) & ~isempty(sigma{j,k}), 
            Sij=Sij+sigma{i,k}.*sigma{j,k}; 
            sij=1; 
          end
        end
        if sij, 
          ind=zeros(1,d); ind(i)=1; ind(j)=1;
          L=L+diagmult(Sij,basget(B,ind)); 
        end
      end
    end  
  else
    for i=1:d
      Sij=zeros(m,1);
      for k=1:q 
        Sij=Sij+sigma(:,i,k).^2; 
      end
      ind=zeros(1,d); ind(i)=2; 
      L=L+diagmult(Sij/2,basget(B,ind));
      for j=i+1:d
        Sij=zeros(m,1);
        for k=1:q 
          Sij=Sij+sigma(:,i,k).*sigma(:,j,k); 
        end
        ind=zeros(1,d); ind(i)=1; ind(j)=1;
        L=L+diagmult(Sij,basget(B,ind));
      end
    end
  end
end
if nargout>1
  B=ckron(B.vals(1,d:-1:1));
end



function b=basget(B,ind)
d=length(ind);
if strcmp(B.format,'tensor')
  b=B.vals{ind(1)+1,1};
  for i=2:d
    b=kronmex(B.vals{ind(i)+1,i},b);
  end
else
  b=B.vals{ind(1)+1,1};
  for i=2:d
    b=dprod(B.vals{ind(i)+1,i},b);
  end
end
  
  
