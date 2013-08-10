function c= u_inv(v,ra)
if ra ~= 1
%u = c.^(1- ra)/(-1+ra);
c=(v.*(1-ra)).^(1/(1-ra)) ;
%u=c.^(1-ra);
else
    c=exp(v);
end
