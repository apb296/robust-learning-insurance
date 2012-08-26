% GSEIDEL Solves Ax=b using Gauss-Seidel iteration
% USAGE
%   x = gseidel(A,b,x);
% INPUTS
%   A      : nxn matrix
%   b      : n-vector
%   x      : n-vector of starting values, default=b
% OUTPUT
%   x      : approximate solution to Ax=b
%
% USER OPTIONS (SET WITH OPTSET)
%   maxit  : maximum number of iterations
%   tol    : convergence tolerence
%   lambda : over-relaxation parameter

% Copyright (c) 1997-2000, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function x = gseidel(A,b,x)

if nargin<3, x=b; end
maxit  = optget('gseidel','maxit',1000);
tol    = optget('gseidel','tol',sqrt(eps));
lambda = optget('gseidel','lambda',1);

Q = tril(A);
for it=1:maxit
   dx = Q\(b-A*x);
   x = x+lambda*dx;
   if norm(dx)<tol, return; end
end
warning('Maximum iterations exceeded in gseidel')
