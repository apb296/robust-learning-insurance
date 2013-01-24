function c=u_inv(v,ra)
if ra==1
    c=exp(v);
else
    c=(v*(1-ra))^(1/(1-ra));
end
