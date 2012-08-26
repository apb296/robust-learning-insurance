function [flag]=CheckPara(Para1,Para2)

    Check(1)=(Para1.delta==Para2.delta);
    Check(2)=max((Para1.Y==Para2.Y));
    Check(3)=max(max(Para1.Theta==Para2.Theta));
    Check(4)=max(max(max(Para1.P==Para2.P)));
    Check(5)=max(Para1.RA==Para2.RA);
   Check(6)=max(Para1.ApproxMethod==Para2.ApproxMethod);
  Check(7)=max(Para1.OrderOfApproximationPi==Para2.OrderOfApproximationPi);
  Check(8)=max(Para1.OrderOfApproximationV==Para2.OrderOfApproximationV);
  Check(9)=max(max(Para1.P_M==Para2.P_M));
    flag=min(Check);

end
