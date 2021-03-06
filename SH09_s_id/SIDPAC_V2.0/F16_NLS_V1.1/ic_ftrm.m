function [x0,u0] = ic_ftrm(p,xfree,xinit,ufree,uinit)
%
%  IC_FTRM  Sets initial conditions based on trim results.  
%
%  Usage: [x0,u0] = ic_ftrm(p,xfree,xinit,ufree,uinit);
%
%  Description:
%
%    This function initializes the x state vector
%    and u control vector for the nonlinear simulation, 
%    using results from the trim solution.  
%
%  Input:
%    
%      p = trim parameter vector.
%
%  Output:
%
%      x0 = initial state vector.
%      u0 = initial control vector.
%   xfree = vector indicating free states for trim:
%           = 1 for free state
%           = 0 for fixed state
%   xinit = initial state vector for trim, 
%           including fixed state values.
%   ufree = vector indicating free controls for trim:
%           = 1 for free control
%           = 0 for fixed control
%   uinit = initial control vector for trim, 
%           including fixed control values.
%

%
%    Calls:
%      None
%
%    Author:  Eugene A. Morelli
%
%    History:  
%      09 Nov 1995 - Created and debugged, EAM.
%
%
%  Copyright (C) 2006  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%  Please email bug reports or suggestions for improvements to:
%
%      e.a.morelli@nasa.gov
%

%
%  Assign elements of the x and u vectors for trimming.
%
x0=xinit;
ns=length(x0);
u0=uinit;
nc=length(u0);
np=0;
for i=1:ns,
  if xfree(i)==1
    np=np+1;
    x0(i)=p(np);
  end
end
for i=1:nc,
  if ufree(i)==1
    np=np+1;
    u0(i)=p(np);
  end
end
%
%  Check input parameter vector length against
%  the trim option selections.  
%
if length(p)~=np
  fprintf('\n\n Parameter length mismatch in ic_ftrm.m \n\n')
  return
end
%
%  Set engine power state equal to the power command  (bypass engine lag).
%
x0(13)=tgear(u0(1));
return
