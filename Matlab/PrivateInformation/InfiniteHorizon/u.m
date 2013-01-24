function u= u(c,ra)
if ra ~= 1
%u = c.^(1- ra)/(-1+ra);
u = c.^(1- ra)/(1-ra);
%u=c.^(1-ra);
else
    u=log(c);
end
