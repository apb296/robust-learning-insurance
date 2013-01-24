clear all
a = [1, 1, 1, 1];
bl = [1; 1; 1; 1; -10e+24; -10e+24; 25];
bu = [5; 5; 5; 5; 20; 40; 10e+24];
istate = zeros(7, 1, 'int64');
cjac = zeros(2, 4);
clamda = zeros(7, 1);
r = zeros(4, 4);
x = [1; 5; 5; 1];
[cwsav,lwsav,iwsav,rwsav,ifail] = nag_opt_init('nag_opt_nlp1_solve');
[iter, istate, c, cjac, clamda, objf, objgrd, r, x] = ...
     nag_opt_nlp1_solve(a, bl, bu, @confun, @objfun, istate, cjac, clamda, r, x, lwsav, iwsav, rwsav)