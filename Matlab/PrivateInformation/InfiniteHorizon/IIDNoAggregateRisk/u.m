function u= u(c,ra)
%u=-exp(-ra.*c)+1;
 if ra<1
 u = c.^(1- ra)/(1-ra);
% %u=c.^(1-ra);
 elseif ra==1
%    u=log(1+c);
 u=log(c);
% else
%     u = (1+c).^(1- ra)./(1-ra)-1;

 end
