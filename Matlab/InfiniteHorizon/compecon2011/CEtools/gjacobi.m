% GJACOBI Solves Ax=b using Jacobi iteration
% USAGE
%   x = gjacobi(A,b,x);
% INPUTS
%   A     : nxn matrix
%   b     : n-vector
%   x     : n-vector of starting values, default=b
% OUTPUT
%   x     : approximate solution to Ax=b
%
% USER OPTIONS (SET WITH OPSET)
%   maxit : maximum number of iterations
%   tol   : convergence tolerence

% Copyright (c) 1997-2000, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function x = gjacobi(A,b,x)

if nargin<3, x=b; end
maxit = optget('gjacobi','maxit',1000);
tol   = optget('gjacobi','tol',sqrt(eps));

n=size(A,1);
Q = sparse(1:n,1:n,diag(A),n,n);  % Diagonalize the diagonal of A
for i=1:maxit
   dx = Q\(b-A*x);
   x = x + dx;
   if norm(dx)<tol, return; end
end
error('Maximum iterations exceeded in gjacobi')
