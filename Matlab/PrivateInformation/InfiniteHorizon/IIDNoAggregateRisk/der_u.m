function der_u= der_u(c,ra)
 if ra ~= 1
 der_u = c.^(-ra);
 else
     der_u = 1/c;
 end


