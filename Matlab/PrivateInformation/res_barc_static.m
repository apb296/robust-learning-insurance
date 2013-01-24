function res=res_barc_static(c,Para)
y=Para.y;
Delta=Para.Delta;
ra=Para.ra;
res=u(c,ra)-u(c+Delta,ra)-u(y-c,ra)+u(y-c-Delta,ra);

end
