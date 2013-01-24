function [mode, objf, objgrd, user] = objfun(mode, n, x, objgrd, nstate, user)

  if (mode == 0 || mode == 2)
    objf = x(1)*x(4)*(x(1)+x(2)+x(3)) + x(3);
  else
    objf = 0;
  end

  if (mode == 1 || mode == 2)
    objgrd(1) = x(4)*(2*x(1)+x(2)+x(3));
    objgrd(2) = x(1)*x(4);
    objgrd(3) = x(1)*x(4) + 1;
    objgrd(4) = x(1)*(x(1)+x(2)+x(3));
  end